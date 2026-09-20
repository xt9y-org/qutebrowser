# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Generate metadata and checksums for xt9y packaged releases."""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import pathlib
import platform
import re
import subprocess
import sys
from typing import Any


_FORK_TAG_RE = re.compile(r"^v\d+\.\d+\.\d+-xt9y\.\d+$")
_ARTIFACT_SUFFIXES = (
    ".dmg",
    ".exe",
    ".zip",
    ".tar.gz",
)


def _normalize_platform(name: str) -> tuple[str, str]:
    if name == "darwin":
        return "macos", "app"
    if name in {"win32", "cygwin", "msys"}:
        return "windows", "auto"
    if name.startswith("linux"):
        return "linux", "standalone"
    raise ValueError(f"Unsupported release platform: {name!r}")


def _normalize_arch(machine: str) -> str:
    normalized = machine.lower()
    if normalized in {"amd64", "x86_64", "x64"}:
        return "x86_64"
    if normalized in {"arm64", "aarch64"}:
        return "arm64"
    raise ValueError(f"Unsupported release architecture: {machine!r}")


def release_info(
        *, tag: str, commit: str, platform_name: str,
        machine: str) -> dict[str, str]:
    """Return release metadata embedded into a packaged build."""
    if _FORK_TAG_RE.fullmatch(tag) is None:
        raise ValueError(f"Not an xt9y release tag: {tag!r}")
    if not commit:
        raise ValueError("Release commit must not be empty")

    os_name, package = _normalize_platform(platform_name)
    arch = _normalize_arch(machine)
    return {
        "release": tag,
        "commit": commit,
        "platform": os_name,
        "arch": arch,
        "package": package,
    }


def write_release_info(
        target: pathlib.Path, *, tag: str, commit: str,
        platform_name: str, machine: str) -> None:
    """Write release identity JSON for PyInstaller to bundle."""
    info = release_info(
        tag=tag,
        commit=commit,
        platform_name=platform_name,
        machine=machine,
    )
    target.parent.mkdir(parents=True, exist_ok=True)
    target.write_text(
        json.dumps(info, indent=2, sort_keys=True) + "\n",
        encoding="utf-8",
    )


def _is_release_artifact(path: pathlib.Path) -> bool:
    if not path.is_file() or path.name.endswith(".sha256"):
        return False
    if not path.name.startswith("qutebrowser-"):
        return False
    return any(path.name.endswith(suffix) for suffix in _ARTIFACT_SUFFIXES)


def _sha256(path: pathlib.Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as handle:
        for chunk in iter(lambda: handle.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def write_checksums(directory: pathlib.Path) -> list[pathlib.Path]:
    """Create one sha256sum-compatible file beside each packaged artifact."""
    written: list[pathlib.Path] = []
    for artifact in sorted(
            (path for path in directory.iterdir() if _is_release_artifact(path)),
            key=lambda path: path.name):
        checksum_path = artifact.with_name(artifact.name + ".sha256")
        checksum_path.write_text(
            f"{_sha256(artifact)}  {artifact.name}\n",
            encoding="ascii",
        )
        written.append(checksum_path)
    return written


def _git_commit() -> str:
    return subprocess.run(
        ["git", "rev-parse", "HEAD"],
        check=True,
        stdout=subprocess.PIPE,
        text=True,
    ).stdout.strip()


def _write_metadata_from_environment(target: pathlib.Path) -> bool:
    tag = os.environ.get("GITHUB_REF_NAME", "")
    if _FORK_TAG_RE.fullmatch(tag) is None:
        # Branch/PR/nightly builds are deliberately not self-updatable.
        try:
            target.unlink()
        except FileNotFoundError:
            pass
        return False

    write_release_info(
        target,
        tag=tag,
        commit=_git_commit(),
        platform_name=sys.platform,
        machine=platform.machine(),
    )
    return True


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(dest="command", required=True)

    metadata_parser = subparsers.add_parser("metadata")
    metadata_parser.add_argument(
        "--output",
        type=pathlib.Path,
        default=pathlib.Path("qutebrowser/release-info.json"),
    )

    checksum_parser = subparsers.add_parser("checksums")
    checksum_parser.add_argument(
        "directory", nargs="?", type=pathlib.Path,
        default=pathlib.Path("dist"),
    )

    args = parser.parse_args(argv)
    if args.command == "metadata":
        _write_metadata_from_environment(args.output)
    elif args.command == "checksums":
        write_checksums(args.directory)
    else:  # pragma: no cover
        raise AssertionError(args.command)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
