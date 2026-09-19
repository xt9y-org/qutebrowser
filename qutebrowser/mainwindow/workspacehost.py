# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Host native non-web workspace content in qutebrowser tabs.

This module keeps the first workspace integration isolated from the web-tab
implementation. Browser tabs remain untouched; native workspace tabs use a
small QWidget shell and only branch at the tab-management boundaries which
currently assume every tab is a web tab.
"""

from __future__ import annotations

import dataclasses
import itertools

from qutebrowser.qt.core import QTimer, QUrl
from qutebrowser.qt.gui import QIcon
from qutebrowser.qt.widgets import QApplication, QVBoxLayout, QWidget

from qutebrowser.browser import workspace
from qutebrowser.config import config
from qutebrowser.keyinput import modeman
from qutebrowser.mainwindow import mainwindow, tabbedbrowser, tabwidget
from qutebrowser.utils import log, usertypes


_workspace_tab_ids = itertools.count(start=-1, step=-1)
_installed = False


@dataclasses.dataclass
class WorkspaceTabData:
    """Tab-manager state shared with qutebrowser's existing tab UI."""

    pinned: bool = False
    fullscreen: bool = False
    input_mode: usertypes.KeyMode = usertypes.KeyMode.normal


class WorkspaceTab(QWidget):
    """A qutebrowser tab shell containing non-web workspace content."""

    def __init__(
        self,
        content: workspace.WorkspaceContent,
        *,
        win_id: int,
        private: bool,
        parent: QWidget | None = None,
    ) -> None:
        super().__init__(parent)
        self.content = content
        self.kind = content.kind
        self.win_id = win_id
        self.is_private = private
        self.tab_id = next(_workspace_tab_ids)
        self.data = WorkspaceTabData()
        self.pending_removal = False

        layout = QVBoxLayout(self)
        layout.setContentsMargins(0, 0, 0, 0)
        layout.addWidget(content.widget)

    def title(self) -> str:
        return self.content.title()

    def session_state(self) -> workspace.ContentSession | None:
        return self.content.session_state()

    def setFocus(self, *args) -> None:  # noqa: N802 - Qt API
        del args
        self.content.focus()

    def set_pinned(self, pinned: bool) -> None:
        self.data.pinned = pinned
        parent = self.parentWidget()
        if isinstance(parent, tabwidget.TabWidget):
            idx = parent.indexOf(self)
            if idx != -1:
                parent.update_tab_title(idx)

    def shutdown(self) -> None:
        self.pending_removal = True
        shutdown = getattr(self.content, "shutdown", None)
        if shutdown is not None:
            shutdown()


def is_workspace_tab(tab: object) -> bool:
    return isinstance(tab, WorkspaceTab)


def _workspace_fields(
    widget: tabwidget.TabWidget,
    idx: int,
    tab: WorkspaceTab,
) -> dict[str, object]:
    page_title = widget.page_title(idx) or tab.title()
    return {
        "id": tab.tab_id,
        "current_title": page_title,
        "title_sep": " - " if page_title else "",
        "perc_raw": 100,
        "backend": "workspace",
        "private": " [Private Mode] " if tab.is_private else "",
        "audio": "",
        "perc": "",
        "host": "",
        "current_url": "",
        "protocol": "",
        "scroll_pos": "top",
    }


def install() -> None:
    """Install native workspace branches into qutebrowser tab management."""
    global _installed
    if _installed:
        return
    _installed = True

    original_tw_tab_by_idx = tabwidget.TabWidget._tab_by_idx
    original_tw_update_title = tabwidget.TabWidget.update_tab_title
    original_tw_get_fields = tabwidget.TabWidget.get_tab_fields
    original_tw_tab_url = tabwidget.TabWidget.tab_url
    original_tw_update_favicon = tabwidget.TabWidget.update_tab_favicon

    def tw_tab_by_idx(self, idx):
        tab = self.widget(idx)
        if isinstance(tab, WorkspaceTab):
            return tab
        return original_tw_tab_by_idx(self, idx)

    def tw_update_title(self, idx, field=None):
        tab = self.widget(idx)
        if not isinstance(tab, WorkspaceTab):
            return original_tw_update_title(self, idx, field)
        if field is not None and field not in {"current_title", "title"}:
            return

        title = tab.title()
        bar = self.tab_bar()
        bar.set_tab_data(idx, "page-title", title)
        if config.cache["tabs.tooltips"]:
            bar.setTabToolTip(idx, title)
        if bar.tabText(idx) != title:
            bar.setTabText(idx, title)

    def tw_get_fields(self, idx):
        tab = self.widget(idx)
        if isinstance(tab, WorkspaceTab):
            return _workspace_fields(self, idx, tab)
        return original_tw_get_fields(self, idx)

    def tw_tab_url(self, idx):
        tab = self.widget(idx)
        if isinstance(tab, WorkspaceTab):
            return QUrl()
        return original_tw_tab_url(self, idx)

    def tw_update_favicon(self, tab):
        if isinstance(tab, WorkspaceTab):
            idx = self.indexOf(tab)
            if idx != -1:
                self.setTabIcon(idx, QIcon())
            return
        return original_tw_update_favicon(self, tab)

    tabwidget.TabWidget._tab_by_idx = tw_tab_by_idx
    tabwidget.TabWidget.update_tab_title = tw_update_title
    tabwidget.TabWidget.get_tab_fields = tw_get_fields
    tabwidget.TabWidget.tab_url = tw_tab_url
    tabwidget.TabWidget.update_tab_favicon = tw_update_favicon

    original_tb_tab_by_idx = tabbedbrowser.TabbedBrowser._tab_by_idx
    original_tb_current_url = tabbedbrowser.TabbedBrowser.current_url
    original_tb_current_changed = tabbedbrowser.TabbedBrowser._on_current_changed
    original_tb_remove_tab = tabbedbrowser.TabbedBrowser._remove_tab
    original_tb_tabopen = tabbedbrowser.TabbedBrowser.tabopen
    original_tb_load_url = tabbedbrowser.TabbedBrowser.load_url

    def tb_tab_by_idx(self, idx):
        tab = self.widget.widget(idx)
        if isinstance(tab, WorkspaceTab):
            return tab
        return original_tb_tab_by_idx(self, idx)

    def tb_current_url(self):
        if isinstance(self.widget.currentWidget(), WorkspaceTab):
            return QUrl()
        return original_tb_current_url(self)

    def tb_current_changed(self, idx):
        tab = self.widget.widget(idx) if idx != -1 else None
        if not isinstance(tab, WorkspaceTab):
            return original_tb_current_changed(self, idx)
        if self.is_shutting_down:
            return

        log.modes.debug("Current workspace tab changed, focusing {!r}".format(tab))
        tab.setFocus()

        modes_to_leave = [usertypes.KeyMode.hint, usertypes.KeyMode.caret]
        if config.val.tabs.mode_on_change == "normal":
            modes_to_leave += modeman.INPUT_MODES
        for mode in modes_to_leave:
            modeman.leave(self._win_id, mode, "workspace tab changed", maybe=True)

        mm = modeman.instance(self._win_id)
        if (
            config.val.tabs.mode_on_change == "restore"
            and mm.mode not in modeman.PROMPT_MODES
        ):
            modeman.enter(
                self._win_id,
                tab.data.input_mode,
                "restore workspace tab",
            )

        if self._now_focused is not None:
            self.tab_deque.on_switch(self._now_focused)
        self._now_focused = tab
        self.cur_url_changed.emit(QUrl())
        self.cur_progress.emit(0)
        self.cur_load_status_changed.emit(usertypes.LoadStatus.none)
        QTimer.singleShot(0, self._update_window_title)
        self._tab_insert_idx_left = self.widget.currentIndex()
        self._tab_insert_idx_right = self.widget.currentIndex() + 1

    def tb_remove_tab(
        self,
        tab,
        *,
        add_undo=True,
        new_undo=True,
        crashed=False,
    ):
        if not isinstance(tab, WorkspaceTab):
            return original_tb_remove_tab(
                self,
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
                "workspace tab is not contained in TabWidget"
            )
        if tab is self._now_focused:
            self._now_focused = None
        tab.shutdown()
        self.widget.removeTab(idx)
        tab.deleteLater()

    def tb_tabopen(self, url=None, background=None, related=True, idx=None):
        current = self.widget.currentWidget()
        effective_background = (
            config.val.tabs.background if background is None else background
        )
        if (
            isinstance(current, WorkspaceTab)
            and effective_background
            and not config.val.tabs.tabs_are_windows
        ):
            tab = original_tb_tabopen(
                self,
                url=url,
                background=False,
                related=related,
                idx=idx,
            )
            self.widget.setCurrentWidget(current)
            current.setFocus()
            return tab
        return original_tb_tabopen(
            self,
            url=url,
            background=background,
            related=related,
            idx=idx,
        )

    def tb_load_url(self, url, newtab):
        if not newtab and isinstance(self.widget.currentWidget(), WorkspaceTab):
            self.tabopen(url, background=False, related=False)
            return
        return original_tb_load_url(self, url, newtab)

    def tabopen_workspace(
        self,
        content,
        background=False,
        related=False,
        idx=None,
    ):
        prev_focus = QApplication.focusWidget()

        if config.val.tabs.tabs_are_windows and self.widget.count() > 0:
            window = mainwindow.MainWindow(private=self.is_private)
            tab = window.tabbed_browser.tabopen_workspace(
                content,
                background=background,
                related=related,
                idx=idx,
            )
            window.show()
            return tab

        tab = WorkspaceTab(
            content,
            win_id=self._win_id,
            private=self.is_private,
            parent=self.widget,
        )
        if idx is None:
            idx = self._get_new_tab_idx(related)
        idx = self.widget.insertTab(idx, tab, tab.title())

        if background:
            current = self.widget.currentWidget()
            if current is not None and current is not tab:
                tab.resize(current.size())
                self.widget.tab_index_changed.emit(
                    self.widget.currentIndex(),
                    self.widget.count(),
                )
                current.setFocus()
        else:
            self.widget.setCurrentWidget(tab)

        mode = modeman.instance(self._win_id).mode
        if (
            mode
            in {
                usertypes.KeyMode.command,
                usertypes.KeyMode.prompt,
                usertypes.KeyMode.yesno,
            }
            and prev_focus is not None
        ):
            prev_focus.setFocus()

        tab.show()
        return tab

    tabbedbrowser.TabbedBrowser._tab_by_idx = tb_tab_by_idx
    tabbedbrowser.TabbedBrowser.current_url = tb_current_url
    tabbedbrowser.TabbedBrowser._on_current_changed = tb_current_changed
    tabbedbrowser.TabbedBrowser._remove_tab = tb_remove_tab
    tabbedbrowser.TabbedBrowser.tabopen = tb_tabopen
    tabbedbrowser.TabbedBrowser.load_url = tb_load_url
    tabbedbrowser.TabbedBrowser.tabopen_workspace = tabopen_workspace


install()
