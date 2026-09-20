# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for xt9y fork release identity and asset matching."""

import json

import pytest

from qutebrowser.misc import releaseinfo


def test_parse_fork_tag():
    parsed = releaseinfo.parse_fork_tag("v3.7.0-xt9y.12")

    assert parsed.upstream == (3, 7, 0)
    assert parsed.revision == 12
    assert parsed.tag == "v3.7.0-xt9y.12"


@pytest.mark.parametrize("tag", [
    "3.7.0",
    "v3.7.0",
    "v3.7.0-xt9y",
    "v3.7.0-xt9y.foo",
    "v3.7-xt9y.1",
    "v3.7.0-other.1",
])
def test_parse_fork_tag_rejects_foreign_or_malformed(tag):
    with pytest.raises(ValueError):
        releaseinfo.parse_fork_tag(tag)


def test_release_order_uses_upstream_then_fork_revision():
    releases = [
        releaseinfo.parse_fork_tag("v3.7.0-xt9y.11"),
        releaseinfo.parse_fork_tag("v3.8.0-xt9y.1"),
        releaseinfo.parse_fork_tag("v3.7.0-xt9y.12"),
    ]

    assert max(releases).tag == "v3.8.0-xt9y.1"


@pytest.mark.parametrize(("target", "expected"), [
    (
        releaseinfo.PlatformTarget("windows", "x86_64", "installer"),
        "qutebrowser-3.7.0-amd64.exe",
    ),
    (
        releaseinfo.PlatformTarget("windows", "x86_64", "standalone"),
        "qutebrowser-3.7.0-windows-standalone.zip",
    ),
    (
        releaseinfo.PlatformTarget("macos", "arm64", "app"),
        "qutebrowser-3.7.0-arm64.dmg",
    ),
    (
        releaseinfo.PlatformTarget("macos", "x86_64", "app"),
        "qutebrowser-3.7.0-x86_64.dmg",
    ),
    (
        releaseinfo.PlatformTarget("linux", "x86_64", "standalone"),
        "qutebrowser-3.7.0-linux-x86_64.tar.gz",
    ),
])
def test_select_asset_exact_platform_match(target, expected):
    assets = [
        releaseinfo.ReleaseAsset("qutebrowser-3.7.0-amd64.exe", "https://example/installer"),
        releaseinfo.ReleaseAsset("qutebrowser-3.7.0-windows-standalone.zip", "https://example/zip"),
        releaseinfo.ReleaseAsset("qutebrowser-3.7.0-arm64.dmg", "https://example/arm"),
        releaseinfo.ReleaseAsset("qutebrowser-3.7.0-x86_64.dmg", "https://example/intel"),
        releaseinfo.ReleaseAsset("qutebrowser-3.7.0-linux-x86_64.tar.gz", "https://example/linux"),
    ]

    assert releaseinfo.select_release_asset(assets, target).name == expected


def test_select_asset_rejects_unsupported_target():
    assets = [
        releaseinfo.ReleaseAsset("qutebrowser-3.7.0-linux-x86_64.tar.gz", "https://example/linux"),
    ]
    target = releaseinfo.PlatformTarget("linux", "aarch64", "standalone")

    with pytest.raises(releaseinfo.UnsupportedTargetError):
        releaseinfo.select_release_asset(assets, target)


def test_select_asset_rejects_missing_exact_asset():
    assets = [
        releaseinfo.ReleaseAsset("qutebrowser-3.7.0-x86_64.dmg", "https://example/intel"),
    ]
    target = releaseinfo.PlatformTarget("macos", "arm64", "app")

    with pytest.raises(releaseinfo.NoMatchingAssetError):
        releaseinfo.select_release_asset(assets, target)


def test_current_loads_packaged_release_metadata(monkeypatch):
    payload = {
        "release": "v3.7.0-xt9y.8",
        "commit": "abc123",
        "platform": "macos",
        "arch": "arm64",
        "package": "app",
    }
    monkeypatch.setattr(
        releaseinfo.resources, "read_file",
        lambda name: json.dumps(payload),
    )

    current = releaseinfo.current()

    assert current is not None
    assert current.release.tag == "v3.7.0-xt9y.8"
    assert current.commit == "abc123"
    assert current.target == releaseinfo.PlatformTarget("macos", "arm64", "app")


def test_current_returns_none_without_packaged_metadata(monkeypatch):
    def missing(_name):
        raise FileNotFoundError

    monkeypatch.setattr(releaseinfo.resources, "read_file", missing)

    assert releaseinfo.current() is None


def test_current_rejects_malformed_packaged_metadata(monkeypatch):
    monkeypatch.setattr(
        releaseinfo.resources, "read_file",
        lambda name: '{"release": "v3.7.0"}',
    )

    with pytest.raises(ValueError):
        releaseinfo.current()


def test_resolve_windows_auto_package_installer(tmp_path):
    executable = tmp_path / "qutebrowser.exe"
    executable.touch()
    (tmp_path / "uninst.exe").touch()

    target = releaseinfo.resolve_target(
        "windows", "x86_64", "auto", executable=executable)

    assert target.install_kind == "installer"


def test_resolve_windows_auto_package_standalone(tmp_path):
    executable = tmp_path / "qutebrowser.exe"
    executable.touch()

    target = releaseinfo.resolve_target(
        "windows", "x86_64", "auto", executable=executable)

    assert target.install_kind == "standalone"
