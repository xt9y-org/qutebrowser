# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for xt9y fork release identity and asset matching."""

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
