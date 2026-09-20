# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Release identity and packaged-asset selection for the xt9y fork."""

from __future__ import annotations

import dataclasses
import json
import re
from collections.abc import Sequence

from qutebrowser.utils import resources


_FORK_TAG_RE = re.compile(
    r"^v(?P<major>\d+)\.(?P<minor>\d+)\.(?P<patch>\d+)-xt9y\.(?P<revision>\d+)$"
)


class UnsupportedTargetError(ValueError):
    """Raised when no self-update package format exists for a target."""


class NoMatchingAssetError(LookupError):
    """Raised when a release has no asset matching a supported target."""


@dataclasses.dataclass(frozen=True, order=True)
class ForkRelease:
    """A parsed xt9y qutebrowser release tag."""

    upstream: tuple[int, int, int]
    revision: int
    tag: str = dataclasses.field(compare=False)


@dataclasses.dataclass(frozen=True)
class ReleaseAsset:
    """A downloadable GitHub release asset."""

    name: str
    url: str


@dataclasses.dataclass(frozen=True)
class PlatformTarget:
    """The exact packaged installation shape to update."""

    os: str
    arch: str
    install_kind: str


@dataclasses.dataclass(frozen=True)
class BuildInfo:
    """Identity embedded in a packaged xt9y qutebrowser build."""

    release: ForkRelease
    commit: str
    target: PlatformTarget


def parse_fork_tag(tag: str) -> ForkRelease:
    """Parse a release tag such as ``v3.7.0-xt9y.7``."""

    match = _FORK_TAG_RE.fullmatch(tag)
    if match is None:
        raise ValueError(f"Not an xt9y qutebrowser release tag: {tag!r}")

    return ForkRelease(
        upstream=(
            int(match.group("major")),
            int(match.group("minor")),
            int(match.group("patch")),
        ),
        revision=int(match.group("revision")),
        tag=tag,
    )


def current() -> BuildInfo | None:
    """Return packaged fork build metadata, or ``None`` for source installs."""

    try:
        raw = resources.read_file("release-info.json")
    except (FileNotFoundError, OSError, ImportError):
        return None

    try:
        payload = json.loads(raw)
    except ValueError as exc:
        raise ValueError(f"Invalid packaged release metadata: {exc}") from exc

    if not isinstance(payload, dict):
        raise ValueError("Packaged release metadata must be a JSON object")

    required = ("release", "commit", "platform", "arch", "package")
    values = {name: payload.get(name) for name in required}
    if not all(isinstance(value, str) and value for value in values.values()):
        raise ValueError("Packaged release metadata is missing required string fields")

    release = parse_fork_tag(values["release"])
    target = PlatformTarget(
        os=values["platform"],
        arch=values["arch"],
        install_kind=values["package"],
    )
    return BuildInfo(release=release, commit=values["commit"], target=target)


def _asset_suffix(target: PlatformTarget) -> str:
    mapping = {
        ("windows", "x86_64", "installer"): "-amd64.exe",
        ("windows", "x86_64", "standalone"): "-windows-standalone.zip",
        ("macos", "arm64", "app"): "-arm64.dmg",
        ("macos", "x86_64", "app"): "-x86_64.dmg",
        ("linux", "x86_64", "standalone"): "-linux-x86_64.tar.gz",
    }
    try:
        return mapping[(target.os, target.arch, target.install_kind)]
    except KeyError as exc:
        raise UnsupportedTargetError(
            "Unsupported self-update target: "
            f"{target.os}/{target.arch}/{target.install_kind}"
        ) from exc


def select_release_asset(
    assets: Sequence[ReleaseAsset], target: PlatformTarget
) -> ReleaseAsset:
    """Select exactly one release asset for *target*."""

    suffix = _asset_suffix(target)
    matches = [asset for asset in assets if asset.name.endswith(suffix)]
    if len(matches) != 1:
        raise NoMatchingAssetError(
            f"Expected exactly one release asset ending in {suffix!r}, found {len(matches)}"
        )
    return matches[0]
