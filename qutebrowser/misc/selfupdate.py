# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Safe staged updater for packaged xt9y qutebrowser builds."""

from __future__ import annotations

import dataclasses
import hashlib
import os
import pathlib
import shutil
import stat
import subprocess
import sys
import tarfile
import tempfile
import zipfile
from collections.abc import Sequence

from qutebrowser.api import message
from qutebrowser.qt.core import QObject, QTimer, QUrl, pyqtSignal
from qutebrowser.qt.network import QNetworkAccessManager, QNetworkReply
from qutebrowser.misc import httpclient, quitter, releaseinfo
from qutebrowser.utils import log, standarddir


class UpdateError(Exception):
    """Raised when an update cannot be staged or safely applied."""


@dataclasses.dataclass(frozen=True)
class UpdateStrategy:
    kind: str


_STRATEGIES = {
    ("windows", "x86_64", "installer"): UpdateStrategy("windows-installer"),
    ("windows", "x86_64", "standalone"): UpdateStrategy("windows-standalone"),
    ("macos", "arm64", "app"): UpdateStrategy("macos-app"),
    ("macos", "x86_64", "app"): UpdateStrategy("macos-app"),
    ("linux", "x86_64", "standalone"): UpdateStrategy("linux-standalone"),
}

_active_sessions: set["UpdateSession"] = set()


def strategy_for(target: releaseinfo.PlatformTarget) -> UpdateStrategy:
    try:
        return _STRATEGIES[(target.os, target.arch, target.install_kind)]
    except KeyError as exc:
        raise UpdateError(
            "No safe self-update strategy exists for "
            f"{target.os}/{target.arch}/{target.install_kind}"
        ) from exc


def find_checksum_asset(
        asset: releaseinfo.ReleaseAsset,
        assets: Sequence[releaseinfo.ReleaseAsset]) -> releaseinfo.ReleaseAsset:
    expected_name = asset.name + ".sha256"
    matches = [candidate for candidate in assets if candidate.name == expected_name]
    if len(matches) != 1:
        raise UpdateError(
            f"Release must contain exactly one checksum asset {expected_name!r}")
    return matches[0]


def parse_checksum(data: str, filename: str) -> str:
    """Parse a sha256sum-compatible checksum line for *filename*."""
    for raw_line in data.splitlines():
        line = raw_line.strip()
        if not line:
            continue
        parts = line.split(maxsplit=1)
        if len(parts) != 2:
            continue
        digest, named_file = parts
        named_file = named_file.lstrip("*").strip()
        if named_file != filename:
            continue
        if len(digest) != 64:
            break
        try:
            int(digest, 16)
        except ValueError:
            break
        return digest.lower()
    raise UpdateError(f"No valid SHA-256 entry found for {filename!r}")


def verify_checksum(path: pathlib.Path, expected: str) -> None:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    actual = digest.hexdigest()
    if actual != expected.lower():
        raise UpdateError(
            f"SHA-256 mismatch for {path.name}: expected {expected}, got {actual}")


def safe_relative_member(path: pathlib.PurePosixPath) -> bool:
    """Return whether an archive member is safely relative to its extraction root."""
    return bool(path.parts) and not path.is_absolute() and ".." not in path.parts


def _safe_extract_tar(archive: pathlib.Path, destination: pathlib.Path) -> None:
    with tarfile.open(archive, "r:gz") as tar:
        members = tar.getmembers()
        for member in members:
            member_path = pathlib.PurePosixPath(member.name)
            if not safe_relative_member(member_path):
                raise UpdateError(f"Unsafe path in update archive: {member.name!r}")
            if member.issym() or member.islnk():
                raise UpdateError(
                    f"Links are not allowed in update archive: {member.name!r}")
        tar.extractall(destination, members=members)


def _safe_extract_zip(archive: pathlib.Path, destination: pathlib.Path) -> None:
    with zipfile.ZipFile(archive) as zipped:
        for info in zipped.infolist():
            member_path = pathlib.PurePosixPath(info.filename)
            if not safe_relative_member(member_path):
                raise UpdateError(f"Unsafe path in update archive: {info.filename!r}")
        zipped.extractall(destination)


def _single_staged_directory(root: pathlib.Path) -> pathlib.Path:
    directories = [entry for entry in root.iterdir() if entry.is_dir()]
    if len(directories) != 1:
        raise UpdateError(
            f"Expected one top-level directory in update archive, found {len(directories)}")
    return directories[0]


def _mac_app_root() -> pathlib.Path:
    executable = pathlib.Path(sys.executable).resolve()
    for parent in executable.parents:
        if parent.suffix == ".app":
            return parent
    raise UpdateError("Could not locate the running macOS .app bundle")


def _standalone_root() -> pathlib.Path:
    executable = pathlib.Path(sys.executable).resolve()
    root = executable.parent
    if not root.is_dir():
        raise UpdateError("Could not locate the running standalone bundle")
    if not os.access(root.parent, os.W_OK):
        raise UpdateError(f"Update directory is not writable: {root.parent}")
    return root


def _write_helper(suffix: str, content: str) -> pathlib.Path:
    fd, raw_path = tempfile.mkstemp(prefix="qutebrowser-update-", suffix=suffix)
    path = pathlib.Path(raw_path)
    with os.fdopen(fd, "w", encoding="utf-8", newline="\n") as handle:
        handle.write(content)
    if os.name != "nt":
        path.chmod(path.stat().st_mode | stat.S_IXUSR)
    return path


_POSIX_WAIT = """while kill -0 \"$1\" 2>/dev/null; do sleep 0.2; done\n"""


def _mac_helper(asset: pathlib.Path) -> list[str]:
    app = _mac_app_root()
    helper = _write_helper(".sh", """#!/bin/sh
set -eu
pid="$1"
dmg="$2"
app="$3"
while kill -0 "$pid" 2>/dev/null; do sleep 0.2; done
mount_dir="$(mktemp -d)"
cleanup() {
    hdiutil detach "$mount_dir" >/dev/null 2>&1 || true
    rmdir "$mount_dir" >/dev/null 2>&1 || true
}
trap cleanup EXIT INT TERM
hdiutil attach "$dmg" -nobrowse -mountpoint "$mount_dir" >/dev/null
new_app="$(find "$mount_dir" -maxdepth 1 -type d -name '*.app' -print -quit)"
[ -n "$new_app" ]
backup="${app}.update-backup.$$"
mv "$app" "$backup"
if ditto "$new_app" "$app"; then
    open "$app"
    rm -rf -- "$backup"
else
    rm -rf -- "$app"
    mv "$backup" "$app"
    exit 1
fi
""")
    return ["/bin/sh", str(helper), str(os.getpid()), str(asset), str(app)]


def _linux_helper(asset: pathlib.Path) -> list[str]:
    app_root = _standalone_root()
    staging_parent = pathlib.Path(tempfile.mkdtemp(
        prefix=".qutebrowser-update-stage-", dir=app_root.parent))
    try:
        _safe_extract_tar(asset, staging_parent)
        staged_root = _single_staged_directory(staging_parent)
    except Exception:
        shutil.rmtree(staging_parent, ignore_errors=True)
        raise

    executable_name = pathlib.Path(sys.executable).name
    helper = _write_helper(".sh", """#!/bin/sh
set -eu
pid="$1"
staged="$2"
app="$3"
exe_name="$4"
staging_parent="$5"
while kill -0 "$pid" 2>/dev/null; do sleep 0.2; done
backup="${app}.update-backup.$$"
mv "$app" "$backup"
if mv "$staged" "$app"; then
    "$app/$exe_name" >/dev/null 2>&1 &
    new_pid=$!
    sleep 2
    if kill -0 "$new_pid" 2>/dev/null; then
        rm -rf -- "$backup"
        rmdir "$staging_parent" >/dev/null 2>&1 || true
        exit 0
    fi
fi
rm -rf -- "$app"
mv "$backup" "$app"
rm -rf -- "$staging_parent"
exit 1
""")
    return [
        "/bin/sh", str(helper), str(os.getpid()), str(staged_root),
        str(app_root), executable_name, str(staging_parent),
    ]


def _windows_installer_helper(asset: pathlib.Path) -> list[str]:
    helper = _write_helper(".ps1", r"""param(
    [int]$PidToWait,
    [string]$Installer
)
Wait-Process -Id $PidToWait -ErrorAction SilentlyContinue
Start-Process -FilePath $Installer
Remove-Item -LiteralPath $MyInvocation.MyCommand.Path -Force
""")
    return [
        "powershell.exe", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File",
        str(helper), str(os.getpid()), str(asset),
    ]


def _windows_standalone_helper(asset: pathlib.Path) -> list[str]:
    app_root = _standalone_root()
    staging_parent = pathlib.Path(tempfile.mkdtemp(
        prefix=".qutebrowser-update-stage-", dir=app_root.parent))
    try:
        _safe_extract_zip(asset, staging_parent)
        staged_root = _single_staged_directory(staging_parent)
    except Exception:
        shutil.rmtree(staging_parent, ignore_errors=True)
        raise

    helper = _write_helper(".ps1", r"""param(
    [int]$PidToWait,
    [string]$Staged,
    [string]$AppRoot,
    [string]$StagingParent
)
Wait-Process -Id $PidToWait -ErrorAction SilentlyContinue
$backup = "$AppRoot.update-backup.$PID"
Move-Item -LiteralPath $AppRoot -Destination $backup
try {
    Move-Item -LiteralPath $Staged -Destination $AppRoot
    $exe = Join-Path $AppRoot "qutebrowser.exe"
    $proc = Start-Process -FilePath $exe -PassThru
    Start-Sleep -Seconds 2
    if ($proc.HasExited) {
        throw "Updated qutebrowser exited during startup"
    }
    Remove-Item -LiteralPath $backup -Recurse -Force
    Remove-Item -LiteralPath $StagingParent -Recurse -Force -ErrorAction SilentlyContinue
    Remove-Item -LiteralPath $MyInvocation.MyCommand.Path -Force
} catch {
    if (Test-Path -LiteralPath $AppRoot) {
        Remove-Item -LiteralPath $AppRoot -Recurse -Force
    }
    Move-Item -LiteralPath $backup -Destination $AppRoot
    Remove-Item -LiteralPath $StagingParent -Recurse -Force -ErrorAction SilentlyContinue
    throw
}
""")
    return [
        "powershell.exe", "-NoProfile", "-ExecutionPolicy", "Bypass", "-File",
        str(helper), str(os.getpid()), str(staged_root), str(app_root),
        str(staging_parent),
    ]


def _helper_command(strategy: UpdateStrategy, asset: pathlib.Path) -> list[str]:
    if strategy.kind == "macos-app":
        return _mac_helper(asset)
    if strategy.kind == "linux-standalone":
        return _linux_helper(asset)
    if strategy.kind == "windows-installer":
        return _windows_installer_helper(asset)
    if strategy.kind == "windows-standalone":
        return _windows_standalone_helper(asset)
    raise UpdateError(f"Unknown update strategy {strategy.kind!r}")


def _launch_helper(command: list[str]) -> None:
    env = os.environ.copy()
    env["PYINSTALLER_RESET_ENVIRONMENT"] = "1"
    kwargs = {"env": env}
    if os.name == "nt":
        kwargs["creationflags"] = (
            subprocess.CREATE_NEW_PROCESS_GROUP | subprocess.DETACHED_PROCESS)
    else:
        kwargs["start_new_session"] = True
    try:
        subprocess.Popen(  # pylint: disable=consider-using-with
            command,
            stdin=subprocess.DEVNULL,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            **kwargs,
        )
    except OSError as exc:
        raise UpdateError(f"Could not launch update helper: {exc}") from exc


class BinaryDownload(QObject):
    """Small binary download client using Qt's network stack."""

    success = pyqtSignal(object)
    error = pyqtSignal(str)

    def __init__(self, *, url: str, destination: pathlib.Path, parent=None):
        super().__init__(parent)
        self._url = url
        self._destination = destination
        self._nam = QNetworkAccessManager(self)
        self._reply = None
        self._timer = QTimer(self)
        self._timer.setSingleShot(True)
        self._timer.setInterval(120_000)
        self._timer.timeout.connect(self._abort)

    def start(self) -> None:
        self._destination.parent.mkdir(parents=True, exist_ok=True)
        request = httpclient.HTTPRequest(QUrl(self._url))
        self._reply = self._nam.get(request)
        self._reply.finished.connect(self._finished)
        self._timer.start()

    def _abort(self) -> None:
        if self._reply is not None:
            self._reply.abort()

    def _finished(self) -> None:
        reply = self._reply
        self._reply = None
        self._timer.stop()
        if reply is None:
            return
        try:
            if reply.error() != QNetworkReply.NetworkError.NoError:
                self.error.emit(reply.errorString())
                return
            data = bytes(reply.readAll())
            partial = self._destination.with_name(self._destination.name + ".part")
            partial.write_bytes(data)
            partial.replace(self._destination)
            self.success.emit(self._destination)
        except OSError as exc:
            self.error.emit(str(exc))
        finally:
            reply.deleteLater()


class UpdateSession(QObject):
    """Download, verify, stage and hand off one update."""

    def __init__(
        self, *, build: releaseinfo.BuildInfo, release: releaseinfo.ForkRelease,
        asset: releaseinfo.ReleaseAsset,
        checksum_asset: releaseinfo.ReleaseAsset,
    ):
        super().__init__()
        self._build = build
        self._release = release
        self._asset = asset
        self._checksum_asset = checksum_asset
        base = pathlib.Path(standarddir.cache()) / "updates" / release.tag
        self._asset_path = base / asset.name
        self._checksum_path = base / checksum_asset.name
        self._download = None

    def start(self) -> None:
        message.info(f"Downloading update metadata for {self._release.tag}…")
        self._download_to(
            self._checksum_asset.url, self._checksum_path,
            self._checksum_downloaded)

    def _download_to(self, url: str, path: pathlib.Path, callback) -> None:
        download = BinaryDownload(url=url, destination=path, parent=self)
        self._download = download
        download.success.connect(callback)
        download.error.connect(self._failed)
        download.start()

    def _checksum_downloaded(self, path: pathlib.Path) -> None:
        try:
            checksum = parse_checksum(
                path.read_text(encoding="utf-8"), self._asset.name)
        except (OSError, UnicodeDecodeError, UpdateError) as exc:
            self._failed(str(exc))
            return
        self._expected_checksum = checksum
        message.info(f"Downloading {self._asset.name}…")
        self._download_to(self._asset.url, self._asset_path, self._asset_downloaded)

    def _asset_downloaded(self, path: pathlib.Path) -> None:
        try:
            verify_checksum(path, self._expected_checksum)
            strategy = strategy_for(self._build.target)
            command = _helper_command(strategy, path)
            _launch_helper(command)
        except (OSError, UpdateError, tarfile.TarError, zipfile.BadZipFile) as exc:
            self._failed(str(exc))
            return

        message.info(
            f"Verified {self._release.tag}; applying update after qutebrowser exits.")
        _active_sessions.discard(self)
        if quitter.instance is None:
            self._failed("qutebrowser shutdown manager is unavailable")
            return
        quitter.instance.shutdown(is_restart=True)

    def _failed(self, error: str) -> None:
        log.misc.error("Self-update failed: %s", error)
        message.error(f"Update failed: {error}")
        _active_sessions.discard(self)


def start_update(
        *, build: releaseinfo.BuildInfo, release: releaseinfo.ForkRelease,
        asset: releaseinfo.ReleaseAsset,
        assets: Sequence[releaseinfo.ReleaseAsset] | None = None) -> UpdateSession:
    """Start downloading and staging a verified packaged update."""
    strategy_for(build.target)
    if assets is None:
        raise UpdateError("Release asset list is required for checksum verification")
    checksum_asset = find_checksum_asset(asset, assets)
    if pathlib.Path(asset.name).name != asset.name:
        raise UpdateError("Unsafe release asset filename")
    if pathlib.Path(checksum_asset.name).name != checksum_asset.name:
        raise UpdateError("Unsafe checksum asset filename")

    session = UpdateSession(
        build=build,
        release=release,
        asset=asset,
        checksum_asset=checksum_asset,
    )
    _active_sessions.add(session)
    session.start()
    return session
