# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Commands for updating packaged xt9y qutebrowser builds."""

from __future__ import annotations

from qutebrowser.api import cmdutils, message
from qutebrowser.misc import autoupdate, releaseinfo


_active_clients: set[object] = set()


def _release_error(client, error: str) -> None:
    _active_clients.discard(client)
    message.error(f"Update check failed: {error}")


def _release_success(
        client, build: releaseinfo.BuildInfo,
        releases: list[autoupdate.GitHubRelease], *, check: bool) -> None:
    _active_clients.discard(client)
    newest = autoupdate.newest_release(
        releases, current_tag=build.release.tag)
    if newest is None:
        message.info(f"qutebrowser {build.release.tag} is up to date.")
        return

    try:
        asset = releaseinfo.select_release_asset(newest.assets, build.target)
    except (releaseinfo.UnsupportedTargetError,
            releaseinfo.NoMatchingAssetError) as exc:
        message.error(
            f"Update {newest.version.tag} exists, but no compatible package "
            f"is available: {exc}")
        return

    if check:
        message.info(
            f"Update {newest.version.tag} is available: {asset.name}")
        return

    from qutebrowser.misc import selfupdate
    try:
        selfupdate.start_update(
            build=build, release=newest.version, asset=asset)
    except selfupdate.UpdateError as exc:
        message.error(f"Could not start update: {exc}")


@cmdutils.register()
def update(check: bool = False) -> None:
    """Check for or install the newest compatible xt9y release.

    Packaged builds are matched by operating system, CPU architecture and
    package kind. Source, pip, distribution-package and Flatpak installs are
    intentionally not replaced by this command.

    Args:
        check: Only check for a newer release; do not install it.
    """
    try:
        build = releaseinfo.current()
    except ValueError as exc:
        raise cmdutils.CommandError(
            f"Invalid packaged xt9y release metadata: {exc}") from exc

    if build is None:
        raise cmdutils.CommandError(
            "Self-update is only available for packaged xt9y qutebrowser "
            "builds. Update this source/package-manager installation with "
            "the mechanism which installed it.")

    client = autoupdate.GitHubReleaseClient()
    _active_clients.add(client)
    client.error.connect(lambda error: _release_error(client, error))
    client.success.connect(
        lambda releases: _release_success(
            client, build, releases, check=check))
    client.get_releases()
