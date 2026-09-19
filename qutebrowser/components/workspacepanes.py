# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Workspace pane integration and split commands."""

from __future__ import annotations

import functools

from qutebrowser.qt.core import Qt
from qutebrowser.qt.widgets import QApplication, QWidget

from qutebrowser.api import cmdutils
from qutebrowser.browser import filesystemcontent, terminalcontent, workspace
from qutebrowser.config import config
from qutebrowser.keyinput import keyutils
from qutebrowser.mainwindow import (
    mainwindow,
    tabbedbrowser,
    workspacehost,  # imported for tabopen_workspace installation
    workspacesplit,
)
from qutebrowser.utils import objreg, urlutils


_ORIENTATIONS = {
    "horizontal": Qt.Orientation.Horizontal,
    "vertical": Qt.Orientation.Vertical,
}
_APPLICATIONS = ["browser", "filesystem", "terminal"]
_installed = False


class PaneManager(workspacesplit.SplitLayout):
    """Own all TabbedBrowser instances belonging to one qutebrowser window."""

    def __init__(
        self,
        window: mainwindow.MainWindow,
        primary: tabbedbrowser.TabbedBrowser,
    ) -> None:
        super().__init__(primary.widget, parent=window)
        self.window = window
        self.primary = primary
        self.active = primary
        self._browsers: dict[QWidget, tabbedbrowser.TabbedBrowser] = {
            primary.widget: primary,
        }
        app = QApplication.instance()
        if app is not None:
            app.focusChanged.connect(self._on_focus_changed)

    def browser_for_widget(self, widget: QWidget) -> tabbedbrowser.TabbedBrowser | None:
        """Return the pane browser which contains ``widget``."""
        for pane_widget, browser in self._browsers.items():
            if widget is pane_widget or pane_widget.isAncestorOf(widget):
                return browser
        return None

    def _on_focus_changed(self, _old, new) -> None:
        if new is None:
            return
        browser = self.browser_for_widget(new)
        if browser is not None and browser is not self.active:
            self.activate(browser)

    def activate(self, browser: tabbedbrowser.TabbedBrowser) -> None:
        """Make ``browser`` the command/status target for this window."""
        self.active = browser
        self.window._command_dispatcher._tabbed_browser = browser
        objreg.register(
            "tabbed-browser",
            browser,
            update=True,
            scope="window",
            window=self.window.win_id,
        )
        current = browser.widget.currentWidget()
        if current is not None:
            current.setFocus()

    def _connect_secondary_status(self, browser: tabbedbrowser.TabbedBrowser) -> None:
        """Route secondary-pane signals to the existing window status bar."""
        status = self.window.status
        browser.current_tab_changed.connect(status.on_tab_changed)
        browser.cur_progress.connect(status.prog.on_load_progress)
        browser.cur_load_started.connect(status.prog.on_load_started)
        browser.cur_scroll_perc_changed.connect(status.percentage.set_perc)
        browser.widget.tab_index_changed.connect(status.tabindex.on_tab_index_changed)
        browser.cur_url_changed.connect(status.url.set_url)
        browser.cur_url_changed.connect(
            functools.partial(
                status.backforward.on_tab_cur_url_changed,
                tabs=browser,
            )
        )
        browser.cur_link_hovered.connect(status.url.set_hover_url)
        browser.cur_load_status_changed.connect(status.url.on_load_status_changed)
        browser.cur_search_match_changed.connect(status.search_match.set_match)
        browser.cur_caret_selection_toggled.connect(status.on_caret_selection_toggled)
        browser.cur_fullscreen_requested.connect(self.window._on_fullscreen_requested)
        browser.cur_fullscreen_requested.connect(status.maybe_hide)
        browser.cur_fullscreen_requested.connect(
            self.window._downloadview.on_fullscreen_requested
        )

    def _new_browser(self) -> tabbedbrowser.TabbedBrowser:
        browser = tabbedbrowser.TabbedBrowser(
            win_id=self.window.win_id,
            private=self.window.is_private,
            parent=self.window,
        )
        self._browsers[browser.widget] = browser
        self._connect_secondary_status(browser)
        browser.close_window.connect(
            lambda browser=browser: self.close_browser(browser)
        )
        return browser

    def split_active(
        self,
        *,
        orientation: Qt.Orientation,
        application: str,
        target: str | None = None,
    ) -> tabbedbrowser.TabbedBrowser:
        """Split the active pane and populate the new pane."""
        source = self.active
        current_widget = source.widget
        browser = self._new_browser()
        self.split(current_widget, browser.widget, orientation)
        self.activate(browser)

        try:
            self._populate(
                browser,
                source=source,
                application=application,
                target=target,
            )
        except Exception:
            self.close_browser(browser)
            raise
        return browser

    def _populate(
        self,
        browser: tabbedbrowser.TabbedBrowser,
        *,
        source: tabbedbrowser.TabbedBrowser,
        application: str,
        target: str | None,
    ) -> None:
        if application == "browser":
            if target is None:
                url = config.val.url.default_page
            else:
                try:
                    url = objreg.get("quickmark-manager").get(target)
                except Exception:
                    url = urlutils.fuzzy_url(target)
            browser.tabopen(url, background=False, related=False)
            return

        if application == "filesystem":
            content = filesystemcontent.FilesystemContent(target)
            browser.tabopen_workspace(content, background=False, related=False)
            return

        if application == "terminal":
            cwd = target
            source_tab = source.widget.currentWidget()
            if cwd is None and isinstance(source_tab, workspacehost.WorkspaceTab):
                source_content = source_tab.content
                if source_content.kind is workspace.ContentKind.FILESYSTEM:
                    cwd = str(source_content.path)
            content = terminalcontent.TerminalContent(cwd=cwd)
            browser.tabopen_workspace(content, background=False, related=False)
            return

        raise cmdutils.CommandError(
            "Unknown workspace application: {}".format(application)
        )

    def close_browser(self, browser: tabbedbrowser.TabbedBrowser) -> bool:
        """Close a pane, preserving at least one pane in the window."""
        if len(self._browsers) <= 1:
            return False

        widget = browser.widget
        leaves = self.pane_widgets()
        try:
            index = leaves.index(widget)
        except ValueError:
            return False

        if not self.close(widget):
            return False
        self._browsers.pop(widget, None)
        browser.shutdown()
        browser.deleteLater()
        widget.deleteLater()

        remaining = self.pane_widgets()
        if remaining:
            next_widget = remaining[min(index, len(remaining) - 1)]
            next_browser = self._browsers[next_widget]
            self.activate(next_browser)
        return True

    def focus_relative(self, offset: int) -> None:
        """Focus another pane in visual order."""
        leaves = self.pane_widgets()
        if len(leaves) < 2:
            return
        current = leaves.index(self.active.widget)
        widget = leaves[(current + offset) % len(leaves)]
        self.activate(self._browsers[widget])


def _pane_manager(window: mainwindow.MainWindow) -> PaneManager:
    manager = getattr(window, "_workspace_pane_manager", None)
    if manager is None:
        raise cmdutils.CommandError("Workspace pane manager is unavailable")
    return manager


@cmdutils.register(instance="main-window", scope="window", maxsplit=2)
@cmdutils.argument("orientation", choices=list(_ORIENTATIONS))
@cmdutils.argument("application", choices=_APPLICATIONS)
def workspace_split(self, orientation, application=None, target=None):
    """Split the current pane and open browser/filesystem/terminal content.

    Args:
        orientation: horizontal for side-by-side, vertical for stacked panes.
        application: browser, filesystem, or terminal.
        target: Optional URL/path/cwd for the selected application.
    """
    if application is None:
        raise cmdutils.CommandError(
            "Choose an application: browser, filesystem, or terminal"
        )
    manager = _pane_manager(self)
    try:
        manager.split_active(
            orientation=_ORIENTATIONS[orientation],
            application=application,
            target=target,
        )
    except (OSError, RuntimeError, ValueError) as error:
        raise cmdutils.CommandError(str(error))


@cmdutils.register(instance="main-window", scope="window")
def workspace_pane_close(self):
    """Close the active split pane."""
    manager = _pane_manager(self)
    if not manager.close_browser(manager.active):
        raise cmdutils.CommandError("Cannot close the last workspace pane")


@cmdutils.register(instance="main-window", scope="window")
def workspace_pane_next(self):
    """Focus the next split pane."""
    _pane_manager(self).focus_relative(1)


@cmdutils.register(instance="main-window", scope="window")
def workspace_pane_prev(self):
    """Focus the previous split pane."""
    _pane_manager(self).focus_relative(-1)


def _install_layout() -> None:
    global _installed
    if _installed:
        return
    _installed = True

    def add_widgets(window: mainwindow.MainWindow) -> None:
        manager = getattr(window, "_workspace_pane_manager", None)
        if manager is None:
            manager = PaneManager(window, window.tabbed_browser)
            window._workspace_pane_manager = manager

        for widget in [
            window.tabbed_browser.widget,
            manager,
            window._downloadview,
            window.status,
        ]:
            window._vbox.removeWidget(widget)

        widgets = [manager]
        downloads_position = config.val.downloads.position
        if downloads_position == "top":
            widgets.insert(0, window._downloadview)
        elif downloads_position == "bottom":
            widgets.append(window._downloadview)
        else:
            raise ValueError(
                "Invalid downloads position {}!".format(downloads_position)
            )

        status_position = config.val.statusbar.position
        if status_position == "top":
            widgets.insert(0, window.status)
        elif status_position == "bottom":
            widgets.append(window.status)
        else:
            raise ValueError("Invalid status position {}!".format(status_position))

        for widget in widgets:
            window._vbox.addWidget(widget)

    mainwindow.MainWindow._add_widgets = add_widgets


def _install_default_bindings() -> None:
    """Add split selectors without overriding explicit user bindings."""
    if config.key_instance is None:
        return

    commands = config.val.bindings.commands.get("normal", {})
    defaults = config.val.bindings.default["normal"]
    bindings = {
        "hh": "cmd-set-text -s :workspace-split horizontal ",
        "vv": "cmd-set-text -s :workspace-split vertical ",
    }
    for key, command in bindings.items():
        sequence = keyutils.KeySequence.parse(key)
        if sequence in commands or sequence in defaults:
            continue
        config.key_instance.bind(
            sequence,
            command,
            mode="normal",
            save_yaml=False,
        )


_install_layout()
_install_default_bindings()
