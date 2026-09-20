# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for the Dawn-enabled QtWebEngine build tooling."""

import json
import pathlib

import pytest

from scripts.dev import webgpu_qt


def test_patch_qtwebengine_enables_dawn(tmp_path):
    cmake = tmp_path / "src" / "core" / "CMakeLists.txt"
    cmake.parent.mkdir(parents=True)
    cmake.write_text(
        "list(APPEND gnArgArg\nuse_dawn=false\nskia_use_dawn=false\n)\n",
        encoding="utf-8",
    )

    webgpu_qt.patch_qtwebengine(tmp_path)

    text = cmake.read_text(encoding="utf-8")
    assert "use_dawn=true" in text
    assert "use_dawn=false" not in text
    assert "skia_use_dawn=false" in text


def test_patch_qtwebengine_fails_if_upstream_shape_changed(tmp_path):
    cmake = tmp_path / "src" / "core" / "CMakeLists.txt"
    cmake.parent.mkdir(parents=True)
    cmake.write_text("use_dawn=true\n", encoding="utf-8")

    with pytest.raises(webgpu_qt.WebGpuQtError):
        webgpu_qt.patch_qtwebengine(tmp_path)


def test_snapshot_and_overlay_include_new_files(tmp_path):
    prefix = tmp_path / "qt"
    prefix.mkdir()
    existing = prefix / "lib" / "Qt6Core.so"
    existing.parent.mkdir()
    existing.write_bytes(b"core")
    snapshot_path = tmp_path / "before.json"
    webgpu_qt.write_snapshot(prefix, snapshot_path)

    new_file = prefix / "lib" / "libQt6WebEngineCore.so.6"
    new_file.write_bytes(b"webengine")
    changed = prefix / "resources" / "qtwebengine_resources.pak"
    changed.parent.mkdir()
    changed.write_bytes(b"pak")

    archive = tmp_path / "overlay.tar.gz"
    webgpu_qt.create_overlay(prefix, snapshot_path, archive)

    extract = tmp_path / "extract"
    webgpu_qt.apply_overlay(archive, extract)
    assert (extract / "lib" / new_file.name).read_bytes() == b"webengine"
    assert (extract / "resources" / changed.name).read_bytes() == b"pak"
    assert not (extract / "lib" / existing.name).exists()


def test_platform_spec_linux():
    spec = webgpu_qt.platform_spec("linux", "x86_64")
    assert spec.host == "linux"
    assert spec.aqt_arch == "linux_gcc_64"


def test_platform_spec_windows():
    spec = webgpu_qt.platform_spec("win32", "AMD64")
    assert spec.host == "windows"
    assert spec.aqt_arch == "win64_msvc2022_64"


def test_platform_spec_macos():
    spec = webgpu_qt.platform_spec("darwin", "arm64")
    assert spec.host == "mac"
    assert spec.aqt_arch == "clang_64"
