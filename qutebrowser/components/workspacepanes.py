# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Workspace pane integration."""

from __future__ import annotations

import functools
from collections.abc import Callable
from typing import Any

from qutebrowser.qt.core import Qt
from qutebrowser.qt.widgets import QApplication, QWidget

from qutebrowser.api import cmdutils
from qutebrowser.browser import (
    filesystemcontent,
    workspace,
    workspacefactory,
    workspaceterminal,
)
from qutebrowser.config import config
from qutebrowser.mainwindow import (
    mainwindow,
    tabbedbrowser,
    workspacehost,  # imported for tabopen_workspace installation
    workspacesplit,
)
from qutebrowser.utils import objreg, urlutils


_installed = False


def _release_focus_target(
    browser: tabbedbrowser.TabbedBrowser,
    window: mainwindow.MainWindow,
) -> tabbedbrowser.TabbedBrowser:
    """Return the pane which should receive focus after an overlay closes."""
    manager = getattr(window, "_workspace_pane_manager", None)
    if manager is not None and browser is manager.primary:
        return manager.active
    return browser


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
        for pane_browser in self._browsers.values():
            pane_browser.widget.tab_bar().set_workspace_pane_active(
                pane_browser is browser
            )
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
        browser.widget.tab_bar().set_workspace_pane_active(False)
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
            content = workspaceterminal.TerminalContent(cwd=cwd)
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

    def has_workspace_state(self) -> bool:
        """Whether this window needs the extended workspace session format."""
        if len(self._browsers) > 1:
            return True
        for browser in self._browsers.values():
            if any(isinstance(tab, workspacehost.WorkspaceTab)
                   for tab in browser.widgets()):
                return True
        return False

    def _pane_session(
        self,
        browser: tabbedbrowser.TabbedBrowser,
        save_browser_tab: Callable[[Any, bool], dict[str, Any]],
    ) -> dict[str, Any]:
        current = browser.widget.currentIndex()
        tabs: list[dict[str, Any]] = []
        for index, tab in enumerate(browser.widgets()):
            active = index == current
            if isinstance(tab, workspacehost.WorkspaceTab):
                entry: dict[str, Any] = {
                    "type": "workspace",
                    "content": workspacefactory.serialize_content(tab.content),
                }
                if active:
                    entry["active"] = True
                if tab.data.pinned:
                    entry["pinned"] = True
            else:
                entry = {
                    "type": "browser",
                    "data": save_browser_tab(tab, active),
                }
            tabs.append(entry)
        return {"tabs": tabs}

    def session_state(
        self,
        save_browser_tab: Callable[[Any, bool], dict[str, Any]],
    ) -> dict[str, Any]:
        """Serialize all panes/tabs plus the currently active pane."""
        leaves = self.pane_widgets()
        active_index = leaves.index(self.active.widget)
        layout = self.serialize(
            lambda widget: self._pane_session(
                self._browsers[widget], save_browser_tab
            )
        )
        return {"layout": layout, "active-pane": active_index}

    def _clear_browser(self, browser: tabbedbrowser.TabbedBrowser) -> None:
        for tab in list(browser.widgets()):
            browser.close_tab(tab, add_undo=False)

    def _restore_pane(
        self,
        browser: tabbedbrowser.TabbedBrowser,
        pane_state: dict[str, Any],
        load_browser_tab: Callable[[Any, dict[str, Any]], None],
    ) -> None:
        active_index = None
        for index, entry in enumerate(pane_state.get("tabs", [])):
            entry_type = entry.get("type")
            if entry_type == "browser":
                tab = browser.tabopen(background=False, related=False)
                load_browser_tab(tab, entry["data"])
                if entry["data"].get("active", False):
                    active_index = index
                continue
            if entry_type == "workspace":
                content = workspacefactory.create_content(entry["content"])
                tab = browser.tabopen_workspace(
                    content,
                    background=False,
                    related=False,
                )
                if entry.get("pinned", False):
                    tab.set_pinned(True)
                if entry.get("active", False):
                    active_index = index
                continue
            raise ValueError("Invalid workspace session tab type")

        if active_index is not None and active_index < browser.widget.count():
            browser.widget.setCurrentIndex(active_index)

    def restore_session(
        self,
        state: dict[str, Any],
        load_browser_tab: Callable[[Any, dict[str, Any]], None],
    ) -> None:
        """Restore all mixed panes/tabs from session data."""
        for browser in list(self._browsers.values()):
            if browser is not self.primary:
                browser.shutdown()
                browser.deleteLater()
        self._browsers = {self.primary.widget: self.primary}
        self._clear_browser(self.primary)

        first = True

        def make_pane(pane_state):
            nonlocal first
            if first:
                browser = self.primary
                first = False
            else:
                browser = self._new_browser()
            self._restore_pane(browser, pane_state, load_browser_tab)
            return browser.widget

        self.restore(state["layout"], make_pane)
        leaves = self.pane_widgets()
        active_index = int(state.get("active-pane", 0))
        if not 0 <= active_index < len(leaves):
            active_index = 0
        self.activate(self._browsers[leaves[active_index]])


def _pane_manager(window: mainwindow.MainWindow) -> PaneManager:
    manager = getattr(window, "_workspace_pane_manager", None)
    if manager is None:
        raise cmdutils.CommandError("Workspace pane manager is unavailable")
    return manager


@cmdutils.register(instance="main-window", scope="window")
def workspace_pane_close(self):
    """Close the active split pane."""
    manager = _pane_manager(self)
    if not manager.close_browser(manager.active):
        raise cmdutils.CommandError("Cannot close the last workspace pane")


@cmdutils.register(instance="main-window", scope="window")
def workspace_pane_next(self):
    """Focus the next split pane."""
    manager = _pane_manager(self)
    if len(manager.pane_widgets()) > 1:
        manager.focus_relative(1)
    else:
        self._command_dispatcher.tab_next()


@cmdutils.register(instance="main-window", scope="window")
def workspace_pane_prev(self):
    """Focus the previous split pane."""
    manager = _pane_manager(self)
    if len(manager.pane_widgets()) > 1:
        manager.focus_relative(-1)
    else:
        self._command_dispatcher.tab_prev()


def _install_layout() -> None:
    global _installed
    if _installed:
        return
    _installed = True

    original_release_focus = tabbedbrowser.TabbedBrowser.on_release_focus

    def release_focus(browser: tabbedbrowser.TabbedBrowser) -> None:
        target = _release_focus_target(browser, browser.window())
        original_release_focus(target)

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

    tabbedbrowser.TabbedBrowser.on_release_focus = release_focus
    mainwindow.MainWindow._add_widgets = add_widgets


_install_layout()
