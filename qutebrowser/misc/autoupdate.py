# SPDX-FileCopyrightText: Freya Bruhin (The Compiler) <mail@qutebrowser.org>
# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Classes and helpers related to qutebrowser updates."""

from __future__ import annotations

import dataclasses
import json

from qutebrowser.qt.core import pyqtSignal, pyqtSlot, QObject, QUrl

from qutebrowser.misc import httpclient, releaseinfo


@dataclasses.dataclass(frozen=True)
class GitHubRelease:
    """A usable xt9y GitHub release."""

    version: releaseinfo.ForkRelease
    assets: tuple[releaseinfo.ReleaseAsset, ...]


def parse_github_releases(
        data: str, *, include_prerelease: bool = False) -> list[GitHubRelease]:
    """Parse usable xt9y releases from a GitHub releases API response."""

    try:
        payload = json.loads(data)
    except ValueError as exc:
        raise ValueError(f"Invalid GitHub release JSON: {exc}") from exc

    if not isinstance(payload, list):
        raise ValueError("GitHub releases response must be a list")

    releases: list[GitHubRelease] = []
    for item in payload:
        if not isinstance(item, dict):
            continue
        if item.get("draft"):
            continue
        if item.get("prerelease") and not include_prerelease:
            continue

        tag = item.get("tag_name")
        if not isinstance(tag, str):
            continue
        try:
            parsed = releaseinfo.parse_fork_tag(tag)
        except ValueError:
            continue

        assets: list[releaseinfo.ReleaseAsset] = []
        raw_assets = item.get("assets", [])
        if isinstance(raw_assets, list):
            for asset in raw_assets:
                if not isinstance(asset, dict):
                    continue
                name = asset.get("name")
                url = asset.get("browser_download_url")
                if isinstance(name, str) and isinstance(url, str):
                    assets.append(releaseinfo.ReleaseAsset(name=name, url=url))

        releases.append(GitHubRelease(version=parsed, assets=tuple(assets)))

    return releases


def newest_release(
        releases: list[GitHubRelease], *, current_tag: str) -> GitHubRelease | None:
    """Return the newest release newer than *current_tag*, if any."""

    current = releaseinfo.parse_fork_tag(current_tag)
    newer = [release for release in releases if release.version > current]
    if not newer:
        return None
    return max(newer, key=lambda release: release.version)


class PyPIVersionClient(QObject):

    """A client for the PyPI API using HTTPClient.

    It gets the latest version of qutebrowser from PyPI.

    Attributes:
        _client: The HTTPClient used.

    Class attributes:
        API_URL: The base API URL.

    Signals:
        success: Emitted when getting the version info succeeded.
                 arg: The newest version.
        error: Emitted when getting the version info failed.
               arg: The error message, as string.
    """

    API_URL = 'https://pypi.org/pypi/{}/json'
    success = pyqtSignal(str)
    error = pyqtSignal(str)

    def __init__(self, parent=None, client=None):
        super().__init__(parent)
        if client is None:
            self._client = httpclient.HTTPClient(self)
        else:
            self._client = client
        self._client.error.connect(self.error)
        self._client.success.connect(self.on_client_success)

    def get_version(self, package='qutebrowser'):
        """Get the newest version of a given package.

        Emits success/error when done.

        Args:
            package: The name of the package to check.
        """
        url = QUrl(self.API_URL.format(package))
        self._client.get(url)

    @pyqtSlot(str)
    def on_client_success(self, data):
        """Process the data and finish when the client finished.

        Args:
            data: A string with the received data.
        """
        try:
            json_data = json.loads(data)
        except ValueError as e:
            self.error.emit("Invalid JSON received in reply: {}!".format(e))
            return
        try:
            self.success.emit(json_data['info']['version'])
        except KeyError as e:
            self.error.emit("Malformed data received in reply "
                            "({!r} not found)!".format(e))
            return
