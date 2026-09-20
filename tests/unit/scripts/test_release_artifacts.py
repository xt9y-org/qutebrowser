# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for xt9y packaged release metadata/checksum helpers."""

import hashlib
import json

import pytest

from scripts.dev import release_artifacts


def test_release_info_for_macos_arm64():
    info = release_artifacts.release_info(
        tag="v3.7.0-xt9y.8",
        commit="abc123",
        platform_name="darwin",
        machine="arm64",
    )

    assert info == {
        "release": "v3.7.0-xt9y.8",
        "commit": "abc123",
        "platform": "macos",
        "arch": "arm64",
        "package": "app",
    }


def test_release_info_for_windows_uses_runtime_package_detection():
    info = release_artifacts.release_info(
        tag="v3.7.0-xt9y.8",
        commit="abc123",
        platform_name="win32",
        machine="AMD64",
    )

    assert info["platform"] == "windows"
    assert info["arch"] == "x86_64"
    assert info["package"] == "auto"


def test_release_info_for_linux():
    info = release_artifacts.release_info(
        tag="v3.7.0-xt9y.8",
        commit="abc123",
        platform_name="linux",
        machine="x86_64",
    )

    assert info["platform"] == "linux"
    assert info["package"] == "standalone"


@pytest.mark.parametrize("tag", ["main", "v3.7.0", "v3.7.0-xt9y.foo"])
def test_release_info_rejects_non_fork_tag(tag):
    with pytest.raises(ValueError):
        release_artifacts.release_info(
            tag=tag,
            commit="abc123",
            platform_name="linux",
            machine="x86_64",
        )


def test_write_release_info(tmp_path):
    target = tmp_path / "release-info.json"
    release_artifacts.write_release_info(
        target,
        tag="v3.7.0-xt9y.8",
        commit="abc123",
        platform_name="linux",
        machine="x86_64",
    )

    assert json.loads(target.read_text(encoding="utf-8"))["release"] == (
        "v3.7.0-xt9y.8")


def test_write_checksums(tmp_path):
    dmg = tmp_path / "qutebrowser-3.7.0-arm64.dmg"
    dmg.write_bytes(b"dmg")
    exe = tmp_path / "qutebrowser-3.7.0-amd64.exe"
    exe.write_bytes(b"exe")
    ignored = tmp_path / "not-an-artifact.txt"
    ignored.write_text("ignored", encoding="utf-8")

    written = release_artifacts.write_checksums(tmp_path)

    assert written == [
        tmp_path / "qutebrowser-3.7.0-amd64.exe.sha256",
        tmp_path / "qutebrowser-3.7.0-arm64.dmg.sha256",
    ]
    assert written[0].read_text(encoding="ascii") == (
        f"{hashlib.sha256(b'exe').hexdigest()}  {exe.name}\n")
    assert not (tmp_path / "not-an-artifact.txt.sha256").exists()
