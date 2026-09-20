# SPDX-FileCopyrightText: Alexander Cogneau (acogneau) <alexander.cogneau@gmail.com>:
# SPDX-FileCopyrightText: Freya Bruhin (The Compiler) <mail@qutebrowser.org>
# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for qutebrowser.misc.autoupdate."""

import json

import pytest
from qutebrowser.qt.core import QUrl

from qutebrowser.misc import autoupdate, httpclient

INVALID_JSON = ['{"invalid": { "json"}', '{"wrong": "keys"}']


class HTTPGetStub(httpclient.HTTPClient):

    """A stub class for HTTPClient.

    Attributes:
        url: the last url used by get()
        _success: Whether get() will emit a success signal.
    """

    def __init__(self, success=True, json=None):
        super().__init__()
        self.url = None
        self._success = success
        if json:
            self._json = json
        else:
            self._json = '{"info": {"version": "test"}}'

    def get(self, url):
        self.url = url
        if self._success:
            self.success.emit(self._json)
        else:
            self.error.emit("error")


def test_constructor(qapp):
    client = autoupdate.PyPIVersionClient()
    assert isinstance(client._client, httpclient.HTTPClient)


def test_get_version_success(qtbot):
    """Test get_version() when success is emitted."""
    http_stub = HTTPGetStub(success=True)
    client = autoupdate.PyPIVersionClient(client=http_stub)

    with qtbot.assert_not_emitted(client.error):
        with qtbot.wait_signal(client.success):
            client.get_version('test')

    assert http_stub.url == QUrl(client.API_URL.format('test'))


def test_get_version_error(qtbot):
    """Test get_version() when error is emitted."""
    http_stub = HTTPGetStub(success=False)
    client = autoupdate.PyPIVersionClient(client=http_stub)

    with qtbot.assert_not_emitted(client.success):
        with qtbot.wait_signal(client.error):
            client.get_version('test')


@pytest.mark.parametrize('json', INVALID_JSON)
def test_invalid_json(qtbot, json):
    """Test on_client_success() with invalid JSON."""
    http_stub = HTTPGetStub(json=json)
    client = autoupdate.PyPIVersionClient(client=http_stub)
    client.get_version('test')

    with qtbot.assert_not_emitted(client.success):
        with qtbot.wait_signal(client.error):
            client.get_version('test')


def _github_release(tag, *, draft=False, prerelease=False, assets=()):
    return {
        "tag_name": tag,
        "draft": draft,
        "prerelease": prerelease,
        "assets": [
            {"name": name, "browser_download_url": url}
            for name, url in assets
        ],
    }


def test_parse_github_releases_filters_unusable_entries():
    payload = json.dumps([
        _github_release("v3.7.0-xt9y.8", assets=(("qutebrowser-3.7.0-arm64.dmg", "https://example/8"),)),
        _github_release("v3.7.0-xt9y.9", draft=True),
        _github_release("v3.7.0-xt9y.10", prerelease=True),
        _github_release("v3.7.0"),
    ])

    releases = autoupdate.parse_github_releases(payload)

    assert [release.version.tag for release in releases] == ["v3.7.0-xt9y.8"]
    assert releases[0].assets[0].url == "https://example/8"


def test_parse_github_releases_can_include_prereleases():
    payload = json.dumps([
        _github_release("v3.7.0-xt9y.8", prerelease=True),
    ])

    releases = autoupdate.parse_github_releases(payload, include_prerelease=True)

    assert [release.version.tag for release in releases] == ["v3.7.0-xt9y.8"]


def test_newest_release_uses_numeric_revision():
    payload = json.dumps([
        _github_release("v3.7.0-xt9y.9"),
        _github_release("v3.7.0-xt9y.10"),
        _github_release("v3.8.0-xt9y.1"),
    ])
    releases = autoupdate.parse_github_releases(payload)

    newest = autoupdate.newest_release(releases, current_tag="v3.7.0-xt9y.7")

    assert newest is not None
    assert newest.version.tag == "v3.8.0-xt9y.1"


def test_newest_release_returns_none_when_current_is_latest():
    payload = json.dumps([
        _github_release("v3.7.0-xt9y.7"),
        _github_release("v3.7.0-xt9y.6"),
    ])
    releases = autoupdate.parse_github_releases(payload)

    assert autoupdate.newest_release(
        releases, current_tag="v3.7.0-xt9y.7"
    ) is None
