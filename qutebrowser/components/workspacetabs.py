# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Workspace-aware tab widget and tabbed-browser integration."""

from __future__ import annotations

import functools
import pathlib

from qutebrowser.browser import browsertab, workspace
from qutebrowser.config import config
from qutebrowser.keyinput import modeman
from qutebrowser.mainwindow import mainwindow, tabbedbrowser, tabwidget
from qutebrowser.qt.core import QTimer, QUrl, pyqtSignal, pyqtSlot
from qutebrowser.qt.gui import QIcon
from qutebrowser.qt.widgets import QApplication, QWidget
from qutebrowser.utils import log, usertypes


class WorkspaceTabWidget(tabwidget.TabWidget):
    """TabWidget which accepts browser and native workspace tabs."""

    def _tab_by_idx(
        self,
        idx: int,
    ) -> browsertab.AbstractTab | workspace.WorkspaceTab | None:
        tab = self.widget(idx)
        if tab is not None:
            assert isinstance(
                tab,
                (browsertab.AbstractTab, workspace.WorkspaceTab),
            ), tab
        return tab

    def get_tab_fields(self, idx):
        tab = self._tab_by_idx(idx)
        if not isinstance(tab, workspace.WorkspaceTab):
            return super().get_tab_fields(idx)

        page_title = self.page_title(idx)
        url = tab.location()
        return {
            "id": tab.tab_id,
            "current_title": page_title,
            "title_sep": " - " if page_title else "",
            "perc_raw": 0,
            "backend": tab.kind.value,
            "private": " [Private Mode] " if tab.is_private else "",
            "audio": "",
            "perc": "",
            "host": url.host(),
            "current_url": url.toDisplayString(),
            "protocol": url.scheme(),
            "scroll_pos": "",
        }

    def tab_url(self, idx):
        tab = self._tab_by_idx(idx)
        if isinstance(tab, workspace.WorkspaceTab):
            return tab.location()
        return super().tab_url(idx)

    def update_tab_favicon(self, tab) -> None:
        if isinstance(tab, workspace.WorkspaceTab):
            self.setTabIcon(self.indexOf(tab), QIcon())
            return
        super().update_tab_favicon(tab)


class WorkspaceTabbedBrowser(tabbedbrowser.TabbedBrowser):
    """TabbedBrowser with first-class native workspace tabs."""

    workspace_tab_changed = pyqtSignal(workspace.WorkspaceTab)

    def _tab_by_idx(
        self,
        idx: int,
    ) -> browsertab.AbstractTab | workspace.WorkspaceTab | None:
        tab = self.widget.widget(idx)
        if tab is not None:
            assert isinstance(
                tab,
                (browsertab.AbstractTab, workspace.WorkspaceTab),
            ), tab
        return tab

    def _current_tab(self):
        tab = self.widget.currentWidget()
        assert isinstance(
            tab,
            (browsertab.AbstractTab, workspace.WorkspaceTab),
        ), tab
        return tab

    def _connect_workspace_signals(self, tab: workspace.WorkspaceTab) -> None:
        tab.title_changed.connect(
            functools.partial(self._on_workspace_title_changed, tab)
        )
        tab.location_changed.connect(
            functools.partial(self._on_workspace_location_changed, tab)
        )
        tab.pinned_changed.connect(
            functools.partial(self._on_pinned_changed, tab)
        )

    def workspace_tabopen(
        self,
        kind: workspace.ContentKind,
        *,
        path: str | pathlib.Path | None = None,
        background: bool | None = None,
        related: bool = False,
        idx: int | None = None,
    ) -> workspace.WorkspaceTab:
        """Open native workspace content as a normal qutebrowser tab."""
        if kind is not workspace.ContentKind.FILESYSTEM:
            raise ValueError("Workspace content is not implemented: {}".format(kind.value))

        prev_focus = QApplication.focusWidget()

        if config.val.tabs.tabs_are_windows and self.widget.count() > 0:
            window = mainwindow.MainWindow(private=self.is_private)
            tab = window.tabbed_browser.workspace_tabopen(
                kind,
                path=path,
                background=background,
                related=related,
            )
            window.show()
            return tab

        content = workspace.FilesystemContent(path)
        tab = workspace.WorkspaceTab(
            content,
            win_id=self._win_id,
            private=self.is_private,
            parent=self.widget,
        )
        self._connect_workspace_signals(tab)

        if idx is None:
            idx = self._get_new_tab_idx(related)
        self.widget.insertTab(idx, tab, tab.title())

        if background is None:
            background = config.val.tabs.background
        if background:
            current = self.widget.currentWidget()
            if current is not None and current is not tab:
                tab.resize(current.size())
                current.setFocus()
            self.widget.tab_index_changed.emit(
                self.widget.currentIndex(),
                self.widget.count(),
            )
        else:
            self.widget.setCurrentWidget(tab)

        mode = modeman.instance(self._win_id).mode
        if mode in [
            usertypes.KeyMode.command,
            usertypes.KeyMode.prompt,
            usertypes.KeyMode.yesno,
        ]:
            if prev_focus is not None:
                prev_focus.setFocus()
        else:
            tab.focus_content()

        tab.show()
        return tab

    def _on_workspace_title_changed(
        self,
        tab: workspace.WorkspaceTab,
        title: str,
    ) -> None:
        try:
            idx = self._tab_index(tab)
        except tabbedbrowser.TabDeletedError:
            return
        self.widget.set_page_title(idx, title)
        if idx == self.widget.currentIndex():
            self._update_window_title()

    def _on_workspace_location_changed(
        self,
        tab: workspace.WorkspaceTab,
        url: QUrl,
    ) -> None:
        try:
            idx = self._tab_index(tab)
        except tabbedbrowser.TabDeletedError:
            return
        if idx == self.widget.currentIndex():
            self.cur_url_changed.emit(url)
            self._update_window_title()

    def _remove_tab(
        self,
        tab,
        *,
        add_undo=True,
        new_undo=True,
        crashed=False,
    ):
        if not isinstance(tab, workspace.WorkspaceTab):
            return super()._remove_tab(
                tab,
                add_undo=add_undo,
                new_undo=new_undo,
                crashed=crashed,
            )

        idx = self.widget.indexOf(tab)
        if idx == -1:
            if crashed:
                return
            raise tabbedbrowser.TabDeletedError(
                "tab {} is not contained in TabbedWidget!".format(tab)
            )
        if tab is self._now_focused:
            self._now_focused = None

        tab.shutdown()
        self.widget.removeTab(idx)
        tab.deleteLater()

    @pyqtSlot(int)
    def _on_current_changed(self, idx):
        tab = self._tab_by_idx(idx) if idx != -1 else None
        if not isinstance(tab, workspace.WorkspaceTab):
            return super()._on_current_changed(idx)
        if self.is_shutting_down:
            return

        log.modes.debug("Current workspace tab changed, focusing {!r}".format(tab))
        tab.setFocus()
        tab.focus_content()

        mode_on_change = config.val.tabs.mode_on_change
        modes_to_leave = [usertypes.KeyMode.hint, usertypes.KeyMode.caret]
        mm_instance = modeman.instance(self._win_id)
        current_mode = mm_instance.mode
        if mode_on_change == "normal":
            modes_to_leave += modeman.INPUT_MODES
        for mode in modes_to_leave:
            modeman.leave(self._win_id, mode, "tab changed", maybe=True)
        if (
            mode_on_change == "restore"
            and current_mode not in modeman.PROMPT_MODES
        ):
            modeman.enter(self._win_id, tab.data.input_mode, "restore")

        if self._now_focused is not None:
            self.tab_deque.on_switch(self._now_focused)
        self._now_focused = tab

        self.cur_progress.emit(0)
        self.cur_load_status_changed.emit(usertypes.LoadStatus.none)
        self.cur_url_changed.emit(tab.location())
        self.workspace_tab_changed.emit(tab)
        QTimer.singleShot(0, self._update_window_title)
        self._tab_insert_idx_left = self.widget.currentIndex()
        self._tab_insert_idx_right = self.widget.currentIndex() + 1

    @pyqtSlot(usertypes.KeyMode)
    def on_mode_entered(self, mode):
        tab = self.widget.currentWidget()
        if isinstance(tab, workspace.WorkspaceTab):
            if (
                config.val.tabs.mode_on_change == "restore"
                and mode in modeman.INPUT_MODES
            ):
                tab.data.input_mode = mode
            return
        super().on_mode_entered(mode)

    @pyqtSlot()
    def on_mode_left(self):
        tab = self.widget.currentWidget()
        if isinstance(tab, workspace.WorkspaceTab):
            if config.val.tabs.mode_on_change == "restore":
                tab.data.input_mode = usertypes.KeyMode.normal
            return
        super().on_mode_left()

    @pyqtSlot("QUrl", bool)
    def load_url(self, url, newtab):
        current = self.widget.currentWidget()
        if isinstance(current, workspace.WorkspaceTab):
            self.tabopen(url, background=False, related=False)
            return
        super().load_url(url, newtab)


def install() -> None:
    """Install workspace-aware classes before qutebrowser creates windows."""
    tabwidget.TabWidget = WorkspaceTabWidget  # type: ignore[misc]
    tabbedbrowser.TabbedBrowser = WorkspaceTabbedBrowser  # type: ignore[misc]


install()
