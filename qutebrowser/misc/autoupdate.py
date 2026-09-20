# SPDX-FileCopyrightText: Freya Bruhin (The Compiler) <mail@qutebrowser.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Classes related to auto-updating and getting the latest version."""

import dataclasses
import enum
import hashlib
import json
import os
import pathlib
import posixpath
import re
import shutil
import subprocess
import sys
import tarfile
import tempfile
import zipfile
from collections.abc import Callable
from typing import Any

from qutebrowser.qt.core import pyqtSignal, pyqtSlot, QObject, QUrl

from qutebrowser.misc import httpclient
from qutebrowser.utils import resources


@dataclasses.dataclass(frozen=True, order=True)
class ForkReleaseVersion:

    """Comparable version for xt9y's downstream qutebrowser releases."""

    major: int
    minor: int
    patch: int
    revision: int

    _TAG_RE = re.compile(r'^v(\d+)\.(\d+)\.(\d+)-xt9y\.(\d+)$')

    @classmethod
    def from_tag(cls, tag: str) -> 'ForkReleaseVersion':
        match = cls._TAG_RE.fullmatch(tag)
        if match is None:
            raise ValueError(f'Invalid xt9y release tag: {tag!r}')
        return cls(*(int(part) for part in match.groups()))


@dataclasses.dataclass(frozen=True)
class ReleaseAsset:

    """A downloadable asset attached to a fork release."""

    name: str
    download_url: str


@dataclasses.dataclass(frozen=True)
class ReleaseInfo:

    """Metadata for a GitHub release relevant to self-updating."""

    tag: str
    assets: tuple[ReleaseAsset, ...]
    draft: bool = False
    prerelease: bool = False


class InstallKind(enum.Enum):

    """Supported packaged installation layouts."""

    windows_installer = enum.auto()
    windows_standalone = enum.auto()
    macos_app = enum.auto()
    linux_standalone = enum.auto()


@dataclasses.dataclass(frozen=True)
class PlatformTarget:

    """Exact OS, architecture and install layout to update."""

    os: str
    arch: str
    install_kind: InstallKind


@dataclasses.dataclass(frozen=True)
class BuildInfo:

    """Identity embedded into an official packaged xt9y build."""

    version: str
    release: str
    commit: str
    platform: str
    arch: str
    package: str

    @classmethod
    def from_json(cls, data: str) -> 'BuildInfo':
        try:
            payload = json.loads(data)
        except ValueError as e:
            raise ValueError(f'Invalid release-info JSON: {e}') from e
        if not isinstance(payload, dict):
            raise ValueError('release-info must be a JSON object')
        keys = ('version', 'release', 'commit', 'platform', 'arch', 'package')
        if any(not isinstance(payload.get(key), str) for key in keys):
            raise ValueError('release-info contains missing or invalid fields')
        ForkReleaseVersion.from_tag(payload['release'])
        return cls(**{key: payload[key] for key in keys})


@dataclasses.dataclass(frozen=True)
class StagedUpdate:

    """A verified update staged outside the live installation."""

    package_path: pathlib.Path
    target: PlatformTarget
    staged_root: pathlib.Path | None = None


@dataclasses.dataclass(frozen=True)
class UpdateHandoff:

    """Detached helper which replaces the live install after qutebrowser exits."""

    command: tuple[str, ...]
    helper_path: pathlib.Path
    config_path: pathlib.Path | None
    log_path: pathlib.Path


def load_build_info() -> BuildInfo | None:
    try:
        data = resources.read_file('release-info.json')
    except OSError:
        return None
    try:
        return BuildInfo.from_json(data)
    except ValueError:
        return None


def _is_windows_installer_install() -> bool:
    if os.name != 'nt':
        return False
    try:
        import winreg
    except ImportError:  # pragma: no cover
        return False

    key_path = r'Software\Microsoft\Windows\CurrentVersion\Uninstall\qutebrowser'
    executable = pathlib.Path(sys.executable).resolve()
    roots = (winreg.HKEY_CURRENT_USER,  # type: ignore[attr-defined]
             winreg.HKEY_LOCAL_MACHINE)  # type: ignore[attr-defined]
    accesses = (winreg.KEY_READ,  # type: ignore[attr-defined]
                winreg.KEY_READ | winreg.KEY_WOW64_64KEY)  # type: ignore[attr-defined]
    for root in roots:
        for access in accesses:
            try:
                with winreg.OpenKey(  # type: ignore[attr-defined]
                        root, key_path, 0, access) as key:
                    install_dir, _ = winreg.QueryValueEx(  # type: ignore[attr-defined]
                        key, 'InstallLocation')
            except OSError:
                continue
            if not install_dir:
                continue
            try:
                executable.relative_to(pathlib.Path(install_dir).resolve())
            except ValueError:
                continue
            return True
    return False


def platform_target(info: BuildInfo) -> PlatformTarget | None:
    if info.platform == 'macos' and info.package == 'macos-app':
        return PlatformTarget('macos', info.arch, InstallKind.macos_app)
    if info.platform == 'linux' and info.package == 'linux-standalone':
        return PlatformTarget('linux', info.arch, InstallKind.linux_standalone)
    if info.platform == 'windows' and info.package == 'windows-bundle':
        kind = (InstallKind.windows_installer if _is_windows_installer_install()
                else InstallKind.windows_standalone)
        return PlatformTarget('windows', info.arch, kind)
    return None


def latest_release(
        releases: list[ReleaseInfo], *,
        current_tag: str,
        include_prerelease: bool = False,
) -> ReleaseInfo | None:
    """Return the newest usable downstream release newer than current_tag."""
    current = ForkReleaseVersion.from_tag(current_tag)
    candidates: list[tuple[ForkReleaseVersion, ReleaseInfo]] = []
    for release in releases:
        if release.draft or (release.prerelease and not include_prerelease):
            continue
        try:
            parsed = ForkReleaseVersion.from_tag(release.tag)
        except ValueError:
            continue
        if parsed > current:
            candidates.append((parsed, release))
    if not candidates:
        return None
    return max(candidates, key=lambda item: item[0])[1]


def matching_asset(
        release: ReleaseInfo,
        target: PlatformTarget,
) -> ReleaseAsset | None:
    """Find the exact artifact for a platform/install target."""
    version = release.tag.removeprefix('v')
    expected: str | None = None
    if target == PlatformTarget('windows', 'x86_64', InstallKind.windows_installer):
        expected = f'qutebrowser-{version}-amd64.exe'
    elif target == PlatformTarget('windows', 'x86_64', InstallKind.windows_standalone):
        expected = f'qutebrowser-{version}-windows-standalone.zip'
    elif target.os == 'macos' and target.install_kind == InstallKind.macos_app:
        if target.arch in {'arm64', 'x86_64'}:
            expected = f'qutebrowser-{version}-{target.arch}.dmg'
    elif target == PlatformTarget('linux', 'x86_64', InstallKind.linux_standalone):
        expected = f'qutebrowser-{version}-linux-x86_64.tar.gz'

    if expected is None:
        return None
    return next((asset for asset in release.assets if asset.name == expected), None)


def checksum_asset(release: ReleaseInfo) -> ReleaseAsset | None:
    return next((asset for asset in release.assets if asset.name == 'SHA256SUMS'), None)


def parse_github_releases(data: str) -> list[ReleaseInfo]:
    try:
        payload = json.loads(data)
    except ValueError as e:
        raise ValueError(f'Invalid GitHub releases JSON: {e}') from e
    if not isinstance(payload, list):
        raise ValueError('GitHub releases response must be a JSON array')

    releases = []
    for raw_release in payload:
        if not isinstance(raw_release, dict):
            raise ValueError('Malformed GitHub release entry')
        tag = raw_release.get('tag_name')
        assets_raw = raw_release.get('assets', [])
        if not isinstance(tag, str) or not isinstance(assets_raw, list):
            raise ValueError('Malformed GitHub release entry')
        assets = []
        for raw_asset in assets_raw:
            if not isinstance(raw_asset, dict):
                raise ValueError('Malformed GitHub release asset')
            name = raw_asset.get('name')
            download_url = raw_asset.get('browser_download_url')
            if not isinstance(name, str) or not isinstance(download_url, str):
                raise ValueError('Malformed GitHub release asset')
            assets.append(ReleaseAsset(name=name, download_url=download_url))
        releases.append(ReleaseInfo(
            tag=tag,
            assets=tuple(assets),
            draft=bool(raw_release.get('draft', False)),
            prerelease=bool(raw_release.get('prerelease', False)),
        ))
    return releases


def parse_sha256sums(data: str) -> dict[str, str]:
    result = {}
    for line in data.splitlines():
        line = line.strip()
        if not line:
            continue
        match = re.fullmatch(r'([0-9a-fA-F]{64}) [ *](.+)', line)
        if match is None:
            raise ValueError(f'Invalid SHA256SUMS line: {line!r}')
        digest, filename = match.groups()
        result[filename] = digest.lower()
    return result


def verify_sha256(path: pathlib.Path, expected: str) -> bool:
    digest = hashlib.sha256()
    with path.open('rb') as fileobj:
        for chunk in iter(lambda: fileobj.read(1024 * 1024), b''):
            digest.update(chunk)
    return digest.hexdigest() == expected.lower()


def _validate_archive_path(name: str, *, link_target: str | None = None) -> None:
    """Reject archive paths which could escape the extraction directory."""
    normalized = posixpath.normpath(name.replace('\\', '/'))
    if normalized.startswith('/') or normalized == '..' or normalized.startswith('../'):
        raise ValueError(f'Unsafe archive path: {name!r}')
    if link_target is not None:
        normalized_link = posixpath.normpath(link_target.replace('\\', '/'))
        if (normalized_link.startswith('/') or normalized_link == '..' or
                normalized_link.startswith('../')):
            raise ValueError(f'Unsafe archive link target: {link_target!r}')


def _extract_standalone(
        package_path: pathlib.Path,
        target: PlatformTarget,
        destination: pathlib.Path,
) -> pathlib.Path:
    """Extract and validate a standalone release into destination."""
    payload = destination / 'payload'
    payload.mkdir()

    if target.install_kind == InstallKind.windows_standalone:
        with zipfile.ZipFile(package_path) as archive:
            for member in archive.infolist():
                _validate_archive_path(member.filename)
            archive.extractall(payload)
        executable_name = 'qutebrowser.exe'
    elif target.install_kind == InstallKind.linux_standalone:
        with tarfile.open(package_path, 'r:gz') as archive:
            for member in archive.getmembers():
                link_target = member.linkname if (member.issym() or member.islnk()) else None
                _validate_archive_path(member.name, link_target=link_target)
                if member.isdev() or member.isfifo():
                    raise ValueError(f'Unsafe archive member: {member.name!r}')
            archive.extractall(payload)  # noqa: S202 - paths validated above
        executable_name = 'qutebrowser'
    else:
        raise ValueError(f'Not a standalone update target: {target.install_kind!r}')

    roots = [path for path in payload.iterdir() if path.name != '__MACOSX']
    if len(roots) != 1 or not roots[0].is_dir():
        raise ValueError('Standalone update must contain exactly one top-level directory')
    staged_root = roots[0]
    if not (staged_root / executable_name).is_file():
        raise ValueError(
            f'Standalone update is missing its {executable_name} executable')
    return staged_root


def stage_update(
        asset_path: pathlib.Path,
        target: PlatformTarget,
        *,
        staging_dir: pathlib.Path | None = None,
) -> StagedUpdate:
    source = pathlib.Path(asset_path).resolve()
    if staging_dir is None:
        destination = pathlib.Path(tempfile.mkdtemp(prefix='qutebrowser-update-'))
    else:
        destination = pathlib.Path(staging_dir)
        destination.mkdir(parents=True, exist_ok=False)

    package_path = destination / source.name
    try:
        shutil.copy2(source, package_path)
        staged_root = None
        if target.install_kind in {
                InstallKind.windows_standalone,
                InstallKind.linux_standalone,
        }:
            staged_root = _extract_standalone(package_path, target, destination)
    except Exception:
        shutil.rmtree(destination, ignore_errors=True)
        raise
    return StagedUpdate(
        package_path=package_path,
        target=target,
        staged_root=staged_root,
    )


_LINUX_UPDATE_HELPER = r'''#!/bin/sh
set -eu

pid=$1
install_root=$2
staged_root=$3
restart_executable=$4
shift 4

while kill -0 "$pid" 2>/dev/null; do
    sleep 0.1
done

restart_old() {
    if [ -x "$restart_executable" ]; then
        "$restart_executable" "$@" >/dev/null 2>&1 &
    fi
}

backup="${install_root}.update-old"
if ! rm -rf "$backup"; then
    restart_old "$@"
    exit 1
fi
if ! mv "$install_root" "$backup"; then
    restart_old "$@"
    exit 1
fi
if ! mv "$staged_root" "$install_root"; then
    mv "$backup" "$install_root" || true
    restart_old "$@"
    exit 1
fi

if [ ! -x "$restart_executable" ]; then
    rm -rf "$install_root" || true
    mv "$backup" "$install_root" || true
    restart_old "$@"
    exit 1
fi

"$restart_executable" "$@" >/dev/null 2>&1 &
rm -rf "$backup" || true
'''


_MACOS_UPDATE_HELPER = r'''#!/bin/sh
set -eu

pid=$1
app_path=$2
dmg_path=$3
mount_path=$4
shift 4

while kill -0 "$pid" 2>/dev/null; do
    sleep 0.1
done

restart_old() {
    /usr/bin/open -n "$app_path" --args "$@" >/dev/null 2>&1 || true
}

if ! mkdir -p "$mount_path"; then
    restart_old "$@"
    exit 1
fi
if ! /usr/bin/hdiutil attach "$dmg_path" -nobrowse -readonly -mountpoint "$mount_path" >/dev/null; then
    restart_old "$@"
    exit 1
fi
mounted=1
cleanup_mount() {
    if [ "${mounted:-0}" = 1 ]; then
        /usr/bin/hdiutil detach "$mount_path" >/dev/null 2>&1 || true
    fi
}
trap cleanup_mount EXIT HUP INT TERM

source_app="$mount_path/qutebrowser.app"
if [ ! -d "$source_app" ]; then
    restart_old "$@"
    exit 1
fi

backup="${app_path}.update-old"
if ! rm -rf "$backup"; then
    restart_old "$@"
    exit 1
fi
if ! mv "$app_path" "$backup"; then
    restart_old "$@"
    exit 1
fi
if ! /usr/bin/ditto "$source_app" "$app_path"; then
    rm -rf "$app_path" || true
    mv "$backup" "$app_path" || true
    restart_old "$@"
    exit 1
fi

/usr/bin/hdiutil detach "$mount_path" >/dev/null 2>&1 || true
mounted=0
rm -rf "$mount_path" || true

if ! /usr/bin/open -n "$app_path" --args "$@"; then
    rm -rf "$app_path" || true
    mv "$backup" "$app_path" || true
    restart_old "$@"
    exit 1
fi
rm -rf "$backup" || true
'''


_WINDOWS_UPDATE_HELPER = r'''param([Parameter(Mandatory=$true)][string]$ConfigPath)
$ErrorActionPreference = 'Stop'
$config = Get-Content -Raw -LiteralPath $ConfigPath | ConvertFrom-Json

Wait-Process -Id $config.pid -ErrorAction SilentlyContinue

function Start-Qutebrowser {
    Start-Process -FilePath $config.restart_executable -ArgumentList $config.restart_arguments
}

if ($config.kind -eq 'windows_installer') {
    try {
        $installer = Start-Process -FilePath $config.package_path -ArgumentList '/S' -Wait -PassThru
        if ($installer.ExitCode -ne 0) {
            throw "qutebrowser installer exited with code $($installer.ExitCode)"
        }
        Start-Qutebrowser
    } catch {
        try { Start-Qutebrowser } catch { }
        throw
    }
    exit 0
}

if ($config.kind -ne 'windows_standalone') {
    throw "Unsupported qutebrowser update kind: $($config.kind)"
}

$installRoot = $config.install_root
$stagedRoot = $config.staged_root
$backup = "$installRoot.update-old"
$oldMoved = $false
try {
    if (Test-Path -LiteralPath $backup) {
        Remove-Item -LiteralPath $backup -Recurse -Force
    }
    Move-Item -LiteralPath $installRoot -Destination $backup
    $oldMoved = $true
    Move-Item -LiteralPath $stagedRoot -Destination $installRoot
    if (-not (Test-Path -LiteralPath $config.restart_executable)) {
        throw 'Updated qutebrowser executable is missing'
    }
    Start-Qutebrowser
    Remove-Item -LiteralPath $backup -Recurse -Force
} catch {
    if ($oldMoved -and (Test-Path -LiteralPath $installRoot)) {
        try { Remove-Item -LiteralPath $installRoot -Recurse -Force } catch { }
    }
    if ($oldMoved -and (Test-Path -LiteralPath $backup)) {
        try { Move-Item -LiteralPath $backup -Destination $installRoot } catch { }
    }
    try { Start-Qutebrowser } catch { }
    throw
}
'''


def _write_helper(path: pathlib.Path, content: str) -> None:
    path.write_text(content, encoding='utf-8')
    path.chmod(0o700)


def _default_install_root(
        target: PlatformTarget,
        executable: pathlib.Path,
) -> pathlib.Path:
    if target.install_kind == InstallKind.macos_app:
        try:
            app_path = executable.parents[2]
        except IndexError as e:
            raise ValueError('Could not determine the current macOS app bundle') from e
        if app_path.suffix != '.app':
            raise ValueError('Current executable is not inside a macOS app bundle')
        return app_path
    return executable.parent


def create_update_handoff(
        staged: StagedUpdate,
        restart_command: list[str] | tuple[str, ...] | Any,
        *,
        current_pid: int | None = None,
        install_root: pathlib.Path | None = None,
) -> UpdateHandoff:
    """Create the external helper which takes over after this process exits."""
    restart_args = tuple(str(arg) for arg in restart_command)
    if not restart_args:
        raise ValueError('Restart command must not be empty')
    pid = os.getpid() if current_pid is None else current_pid
    executable = pathlib.Path(restart_args[0])
    root = (_default_install_root(staged.target, executable)
            if install_root is None else pathlib.Path(install_root))
    helper_dir = staged.package_path.parent
    log_path = helper_dir / 'update.log'

    if staged.target.install_kind == InstallKind.linux_standalone:
        if staged.staged_root is None:
            raise ValueError('Linux standalone update has no extracted payload')
        helper = helper_dir / 'apply-update.sh'
        _write_helper(helper, _LINUX_UPDATE_HELPER)
        command = (
            '/bin/sh', str(helper), str(pid), str(root),
            str(staged.staged_root), restart_args[0], *restart_args[1:],
        )
        return UpdateHandoff(command, helper, None, log_path)

    if staged.target.install_kind == InstallKind.macos_app:
        helper = helper_dir / 'apply-update.sh'
        mount_path = helper_dir / 'mounted-update'
        _write_helper(helper, _MACOS_UPDATE_HELPER)
        command = (
            '/bin/sh', str(helper), str(pid), str(root),
            str(staged.package_path), str(mount_path), *restart_args[1:],
        )
        return UpdateHandoff(command, helper, None, log_path)

    if staged.target.install_kind in {
            InstallKind.windows_installer,
            InstallKind.windows_standalone,
    }:
        if (staged.target.install_kind == InstallKind.windows_standalone and
                staged.staged_root is None):
            raise ValueError('Windows standalone update has no extracted payload')
        helper = helper_dir / 'apply-update.ps1'
        config_path = helper_dir / 'update-config.json'
        _write_helper(helper, _WINDOWS_UPDATE_HELPER)
        config = {
            'kind': staged.target.install_kind.name,
            'pid': pid,
            'package_path': str(staged.package_path.resolve()),
            'install_root': str(root),
            'staged_root': (str(staged.staged_root)
                            if staged.staged_root is not None else None),
            'restart_executable': restart_args[0],
            'restart_arguments': subprocess.list2cmdline(list(restart_args[1:])),
        }
        config_path.write_text(json.dumps(config), encoding='utf-8')
        system_root = os.environ.get('SystemRoot', r'C:\Windows')
        powershell = str(pathlib.PureWindowsPath(
            system_root, 'System32', 'WindowsPowerShell', 'v1.0', 'powershell.exe'))
        command = (
            powershell, '-NoProfile', '-NonInteractive', '-ExecutionPolicy', 'Bypass',
            '-File', str(helper), str(config_path),
        )
        return UpdateHandoff(command, helper, config_path, log_path)

    raise ValueError(f'Unsupported update target: {staged.target.install_kind!r}')


def _helper_environment() -> dict[str, str]:
    env = os.environ.copy()
    if hasattr(sys, 'frozen'):
        env['PYINSTALLER_RESET_ENVIRONMENT'] = '1'
        if 'LD_LIBRARY_PATH_ORIG' in env:
            env['LD_LIBRARY_PATH'] = env['LD_LIBRARY_PATH_ORIG']
        else:
            env.pop('LD_LIBRARY_PATH', None)
    return env


def launch_update_handoff(
        staged: StagedUpdate,
        restart_command: list[str] | tuple[str, ...] | Any,
) -> UpdateHandoff:
    """Launch a detached helper which waits for qutebrowser to exit."""
    handoff = create_update_handoff(staged, restart_command)
    popen_kwargs: dict[str, Any] = {
        'env': _helper_environment(),
        'stdin': subprocess.DEVNULL,
        'stdout': None,
        'stderr': subprocess.STDOUT,
    }
    if staged.target.os == 'windows':
        popen_kwargs['creationflags'] = (
            getattr(subprocess, 'CREATE_NO_WINDOW', 0) |
            getattr(subprocess, 'CREATE_NEW_PROCESS_GROUP', 0))
    else:
        popen_kwargs['start_new_session'] = True

    with handoff.log_path.open('ab') as logfile:
        popen_kwargs['stdout'] = logfile
        subprocess.Popen(  # pylint: disable=consider-using-with
            handoff.command, **popen_kwargs)
    return handoff


_BUILD_INFO_UNSET = object()


class ForkUpdateClient(QObject):

    """Asynchronous updater for tagged xt9y packaged builds."""

    RELEASES_URL = (
        'https://api.github.com/repos/xt9y-org/qutebrowser/releases?per_page=100')

    update_available = pyqtSignal(str)
    up_to_date = pyqtSignal(str)
    staged = pyqtSignal(str, str)
    error = pyqtSignal(str)

    def __init__(
            self,
            parent: QObject | None = None,
            *,
            release_client: Any | None = None,
            checksum_client: Any | None = None,
            download_func: Callable[[QUrl], Any] | None = None,
            build_info: Any = _BUILD_INFO_UNSET,
            staging_dir: pathlib.Path | None = None,
    ) -> None:
        super().__init__(parent)
        self._release_client = (httpclient.HTTPClient(self)
                                if release_client is None else release_client)
        self._checksum_client = (httpclient.HTTPClient(self)
                                 if checksum_client is None else checksum_client)
        self._download_func = download_func
        self._build_info = (load_build_info() if build_info is _BUILD_INFO_UNSET
                            else build_info)
        self._staging_dir = staging_dir
        self._target: PlatformTarget | None = None
        self._release: ReleaseInfo | None = None
        self._asset: ReleaseAsset | None = None
        self._expected_digest: str | None = None
        self._download: Any | None = None
        self._staged_update: StagedUpdate | None = None
        self._check_only = False

        self._release_client.success.connect(self._on_releases_success)
        self._release_client.error.connect(self._on_release_error)
        self._checksum_client.success.connect(self._on_checksum_success)
        self._checksum_client.error.connect(self._on_checksum_error)

    @property
    def staged_update(self) -> StagedUpdate | None:
        """The verified update prepared for post-exit installation."""
        return self._staged_update

    def start(self, *, check_only: bool = False) -> None:
        if self._build_info is None:
            self.error.emit(
                'Self-update is only available for tagged packaged xt9y builds.')
            return

        self._target = platform_target(self._build_info)
        if self._target is None:
            self.error.emit(
                'This packaged installation type is not supported by self-update.')
            return

        self._check_only = check_only
        self._release_client.get(QUrl(self.RELEASES_URL))

    @pyqtSlot(str)
    def _on_releases_success(self, data: str) -> None:
        assert self._build_info is not None
        assert self._target is not None
        try:
            releases = parse_github_releases(data)
            release = latest_release(
                releases, current_tag=self._build_info.release)
        except ValueError as e:
            self.error.emit(str(e))
            return

        if release is None:
            self.up_to_date.emit(self._build_info.release)
            return

        asset = matching_asset(release, self._target)
        checksums = checksum_asset(release)
        if asset is None:
            self.error.emit(
                f'No exact update artifact for this platform in {release.tag}.')
            return
        if checksums is None:
            self.error.emit(f'{release.tag} has no SHA256SUMS asset.')
            return

        self._release = release
        self._asset = asset
        self.update_available.emit(release.tag)
        if self._check_only:
            return
        self._checksum_client.get(QUrl(checksums.download_url))

    @pyqtSlot(str)
    def _on_checksum_success(self, data: str) -> None:
        assert self._asset is not None
        try:
            sums = parse_sha256sums(data)
            expected = sums[self._asset.name]
        except (ValueError, KeyError) as e:
            self.error.emit(
                f'Invalid checksum manifest for {self._asset.name}: {e}')
            return

        self._expected_digest = expected
        if self._download_func is None:
            from qutebrowser.api import downloads as api_downloads
            download_func = api_downloads.download_temp
        else:
            download_func = self._download_func
        self._download = download_func(QUrl(self._asset.download_url))
        if self._download is None:
            self.error.emit('Could not start update download.')
            return
        self._download.finished.connect(self._on_download_finished)

    @pyqtSlot()
    def _on_download_finished(self) -> None:
        assert self._download is not None
        assert self._asset is not None
        assert self._release is not None
        assert self._target is not None
        assert self._expected_digest is not None

        if not self._download.successful:
            self.error.emit('Update download failed.')
            return

        fileobj = self._download.fileobj
        fileobj.seek(0)
        payload = fileobj.read()
        download_dir = pathlib.Path(tempfile.mkdtemp(
            prefix='qutebrowser-update-download-'))
        downloaded = download_dir / self._asset.name
        downloaded.write_bytes(payload)

        try:
            if not verify_sha256(downloaded, self._expected_digest):
                self.error.emit('Downloaded update failed SHA-256 verification.')
                return
            try:
                staged = stage_update(
                    downloaded, self._target, staging_dir=self._staging_dir)
            except (OSError, ValueError, zipfile.BadZipFile, tarfile.TarError) as e:
                self.error.emit(f'Could not prepare downloaded update: {e}')
                return
        finally:
            downloaded.unlink(missing_ok=True)
            download_dir.rmdir()

        self._staged_update = staged
        self.staged.emit(self._release.tag, str(staged.package_path))

    @pyqtSlot(str)
    def _on_release_error(self, error: str) -> None:
        self.error.emit(f'Could not check GitHub releases: {error}')

    @pyqtSlot(str)
    def _on_checksum_error(self, error: str) -> None:
        self.error.emit(f'Could not download SHA256SUMS: {error}')


class PyPIVersionClient(QObject):

    """A client for the PyPI API using HTTPClient.

    It gets the latest version of qutebrowser from PyPI.

    Attributes:
        _client: The HTTPClient used.

    Class attributes:
        API_URL: The base API URL.

    Signals:
        success: Emitted when getting the version info succeeded.
                 arg: The newest version.
        error: Emitted when getting the version info failed.
               arg: The error message, as string.
    """

    API_URL = 'https://pypi.org/pypi/{}/json'
    success = pyqtSignal(str)
    error = pyqtSignal(str)

    def __init__(self, parent=None, client=None):
        super().__init__(parent)
        if client is None:
            self._client = httpclient.HTTPClient(self)
        else:
            self._client = client
        self._client.error.connect(self.error)
        self._client.success.connect(self.on_client_success)

    def get_version(self, package='qutebrowser'):
        """Get the newest version of a given package.

        Emits success/error when done.

        Args:
            package: The name of the package to check.
        """
        url = QUrl(self.API_URL.format(package))
        self._client.get(url)

    @pyqtSlot(str)
    def on_client_success(self, data):
        """Process the data and finish when the client finished.

        Args:
            data: A string with the received data.
        """
        try:
            json_data = json.loads(data)
        except ValueError as e:
            self.error.emit("Invalid JSON received in reply: {}!".format(e))
            return
        try:
            self.success.emit(json_data['info']['version'])
        except KeyError as e:
            self.error.emit("Malformed data received in reply "
                            "({!r} not found)!".format(e))
            return
