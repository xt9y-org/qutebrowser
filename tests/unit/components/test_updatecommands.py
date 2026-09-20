# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for the xt9y :update command."""

from qutebrowser.components import updatecommands
from qutebrowser.misc import autoupdate, releaseinfo


class Signal:
    def __init__(self):
        self.callbacks = []

    def connect(self, callback):
        self.callbacks.append(callback)

    def emit(self, value):
        for callback in list(self.callbacks):
            callback(value)


class FakeClient:
    instances = []

    def __init__(self):
        self.success = Signal()
        self.error = Signal()
        self.requested = False
        self.__class__.instances.append(self)

    def get_releases(self):
        self.requested = True


def build(tag="v3.7.0-xt9y.7"):
    return releaseinfo.BuildInfo(
        release=releaseinfo.parse_fork_tag(tag),
        commit="abc",
        target=releaseinfo.PlatformTarget("macos", "arm64", "app"),
    )


def release(tag, assets=()):
    return autoupdate.GitHubRelease(
        version=releaseinfo.parse_fork_tag(tag),
        assets=tuple(assets),
    )


def test_update_check_reports_latest(monkeypatch, message_mock):
    FakeClient.instances.clear()
    monkeypatch.setattr(updatecommands.releaseinfo, "current", build)
    monkeypatch.setattr(updatecommands.autoupdate, "GitHubReleaseClient", FakeClient)

    updatecommands.update(check=True)
    client = FakeClient.instances[-1]
    client.success.emit([release("v3.7.0-xt9y.7")])

    assert client.requested
    message_mock.info.assert_called_once()
    assert "up to date" in message_mock.info.call_args.args[0].lower()


def test_update_check_reports_matching_asset(monkeypatch, message_mock):
    FakeClient.instances.clear()
    monkeypatch.setattr(updatecommands.releaseinfo, "current", build)
    monkeypatch.setattr(updatecommands.autoupdate, "GitHubReleaseClient", FakeClient)
    asset = releaseinfo.ReleaseAsset(
        "qutebrowser-3.7.0-arm64.dmg", "https://example/update.dmg")

    updatecommands.update(check=True)
    FakeClient.instances[-1].success.emit([
        release("v3.7.0-xt9y.8", assets=(asset,)),
    ])

    text = message_mock.info.call_args.args[0]
    assert "v3.7.0-xt9y.8" in text
    assert asset.name in text


def test_update_rejects_source_install(monkeypatch):
    monkeypatch.setattr(updatecommands.releaseinfo, "current", lambda: None)

    try:
        updatecommands.update(check=True)
    except Exception as exc:  # CommandError without importing command internals.
        assert "packaged xt9y" in str(exc)
    else:
        raise AssertionError("Expected source install to be rejected")


def test_update_reports_network_error(monkeypatch, message_mock):
    FakeClient.instances.clear()
    monkeypatch.setattr(updatecommands.releaseinfo, "current", build)
    monkeypatch.setattr(updatecommands.autoupdate, "GitHubReleaseClient", FakeClient)

    updatecommands.update(check=True)
    FakeClient.instances[-1].error.emit("network failed")

    message_mock.error.assert_called_once()
    assert "network failed" in message_mock.error.call_args.args[0]
