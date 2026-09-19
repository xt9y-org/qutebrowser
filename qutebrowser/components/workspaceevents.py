# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Route native workspace-content events into qutebrowser tab behavior."""

from pathlib import Path

from qutebrowser.qt.core import QUrl

from qutebrowser.mainwindow import tabbedbrowser, workspacehost


_installed = False


def refresh_title(browser, tab) -> None:
    """Refresh a workspace tab title after its native content changes."""
    index = browser.widget.indexOf(tab)
    if index < 0:
        return
    browser.widget.set_page_title(index, tab.title())
    browser._update_window_title()


def open_file(browser, path: str) -> None:
    """Open an activated filesystem file as a related browser tab."""
    resolved = Path(path).expanduser().resolve()
    browser.tabopen(
        QUrl.fromLocalFile(str(resolved)),
        background=False,
        related=True,
    )


def install() -> None:
    """Attach filesystem signals whenever a workspace tab is created."""
    global _installed
    if _installed:
        return
    _installed = True

    original = tabbedbrowser.TabbedBrowser.tabopen_workspace

    def tabopen_workspace(browser, content, background=False, related=False, idx=None):
        tab = original(
            browser,
            content,
            background=background,
            related=related,
            idx=idx,
        )
        if not isinstance(tab, workspacehost.WorkspaceTab):
            return tab

        widget = content.widget
        directory_changed = getattr(widget, "directory_changed", None)
        if directory_changed is not None:
            directory_changed.connect(
                lambda _path, browser=browser, tab=tab: refresh_title(browser, tab)
            )

        file_activated = getattr(widget, "file_activated", None)
        if file_activated is not None:
            file_activated.connect(
                lambda path, browser=browser: open_file(browser, path)
            )
        return tab

    tabbedbrowser.TabbedBrowser.tabopen_workspace = tabopen_workspace


install()
