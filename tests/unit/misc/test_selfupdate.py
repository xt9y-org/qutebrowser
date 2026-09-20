# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for packaged self-update helpers."""

import hashlib
import pathlib

import pytest

from qutebrowser.misc import releaseinfo, selfupdate


def test_parse_checksum_accepts_standard_sha256_line():
    digest = "a" * 64
    assert selfupdate.parse_checksum(
        f"{digest}  qutebrowser-3.7.0-arm64.dmg\n",
        "qutebrowser-3.7.0-arm64.dmg",
    ) == digest


def test_parse_checksum_rejects_wrong_filename():
    with pytest.raises(selfupdate.UpdateError):
        selfupdate.parse_checksum(
            f"{'a' * 64}  other.dmg\n",
            "qutebrowser-3.7.0-arm64.dmg",
        )


def test_verify_checksum(tmp_path):
    path = tmp_path / "asset"
    path.write_bytes(b"update")
    expected = hashlib.sha256(b"update").hexdigest()

    selfupdate.verify_checksum(path, expected)

    with pytest.raises(selfupdate.UpdateError):
        selfupdate.verify_checksum(path, "0" * 64)


@pytest.mark.parametrize(("target", "kind"), [
    (releaseinfo.PlatformTarget("windows", "x86_64", "installer"), "windows-installer"),
    (releaseinfo.PlatformTarget("windows", "x86_64", "standalone"), "windows-standalone"),
    (releaseinfo.PlatformTarget("macos", "arm64", "app"), "macos-app"),
    (releaseinfo.PlatformTarget("macos", "x86_64", "app"), "macos-app"),
    (releaseinfo.PlatformTarget("linux", "x86_64", "standalone"), "linux-standalone"),
])
def test_strategy_for_supported_target(target, kind):
    assert selfupdate.strategy_for(target).kind == kind


def test_strategy_for_unsupported_target():
    target = releaseinfo.PlatformTarget("linux", "aarch64", "standalone")
    with pytest.raises(selfupdate.UpdateError):
        selfupdate.strategy_for(target)


def test_find_checksum_asset():
    asset = releaseinfo.ReleaseAsset("qutebrowser.dmg", "https://example/app")
    checksum = releaseinfo.ReleaseAsset(
        "qutebrowser.dmg.sha256", "https://example/checksum")

    assert selfupdate.find_checksum_asset(asset, [asset, checksum]) == checksum


def test_find_checksum_asset_requires_exact_match():
    asset = releaseinfo.ReleaseAsset("qutebrowser.dmg", "https://example/app")
    with pytest.raises(selfupdate.UpdateError):
        selfupdate.find_checksum_asset(asset, [])


def test_safe_relative_member_rejects_traversal():
    assert selfupdate.safe_relative_member(pathlib.PurePosixPath("qutebrowser/bin"))
    assert not selfupdate.safe_relative_member(pathlib.PurePosixPath("../escape"))
    assert not selfupdate.safe_relative_member(pathlib.PurePosixPath("/absolute"))
