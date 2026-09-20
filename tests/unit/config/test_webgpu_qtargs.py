# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for WebGPU Chromium feature argument handling."""

import pytest

from qutebrowser.config import qtargs
from qutebrowser.utils import utils, version


WEBGPU_FEATURE = "WebGPUService"


@pytest.fixture
def versions():
    return version.WebEngineVersions(
        webengine=utils.VersionNumber(6, 11),
        chromium="140.0.7339.225",
        source="test",
    )


@pytest.fixture(autouse=True)
def quiet_unrelated_features(config_stub, monkeypatch):
    config_stub.val.content.headers.referer = "always"
    config_stub.val.scrolling.bar = "never"
    config_stub.val.input.media_keys = True
    monkeypatch.setattr(qtargs.utils, "is_linux", False)
    monkeypatch.setattr(qtargs.utils, "is_mac", True)


@pytest.mark.parametrize(("setting", "enabled", "disabled"), [
    ("auto", False, False),
    ("always", True, False),
    ("never", False, True),
])
def test_webgpu_setting_controls_feature(
        config_stub, versions, setting, enabled, disabled):
    config_stub.val.content.webgpu = setting

    enabled_features, disabled_features = qtargs._qtwebengine_features(versions, [])

    assert (WEBGPU_FEATURE in enabled_features) is enabled
    assert (WEBGPU_FEATURE in disabled_features) is disabled


def test_webgpu_deduplicates_existing_enable(config_stub, versions):
    config_stub.val.content.webgpu = "always"

    enabled, disabled = qtargs._qtwebengine_features(
        versions, [f"--enable-features={WEBGPU_FEATURE},OtherFeature"]
    )

    assert enabled.count(WEBGPU_FEATURE) == 1
    assert "OtherFeature" in enabled
    assert WEBGPU_FEATURE not in disabled


def test_webgpu_always_overrides_existing_disable(config_stub, versions):
    config_stub.val.content.webgpu = "always"

    enabled, disabled = qtargs._qtwebengine_features(
        versions, [f"--disable-features={WEBGPU_FEATURE},OtherDisabled"]
    )

    assert WEBGPU_FEATURE in enabled
    assert WEBGPU_FEATURE not in disabled
    assert "OtherDisabled" in disabled


def test_webgpu_never_overrides_existing_enable(config_stub, versions):
    config_stub.val.content.webgpu = "never"

    enabled, disabled = qtargs._qtwebengine_features(
        versions, [f"--enable-features={WEBGPU_FEATURE},OtherFeature"]
    )

    assert WEBGPU_FEATURE not in enabled
    assert WEBGPU_FEATURE in disabled
    assert "OtherFeature" in enabled
