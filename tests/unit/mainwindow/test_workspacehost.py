# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for workspace tab hosting."""

from pathlib import Path

from qutebrowser.browser import workspace
from qutebrowser.mainwindow import workspacehost
from qutebrowser.qt.core import QUrl
from qutebrowser.qt.widgets import QLabel
from qutebrowser.utils import objreg, usertypes


class FakeContent:
    kind = workspace.ContentKind.FILESYSTEM

    def __init__(self):
        self._widget = QLabel("content")
        self.focused = False
        self.path = "/tmp"

    @property
    def widget(self):
        return self._widget

    def title(self):
        return "Files · {}".format(self.path)

    def focus(self):
        self.focused = True
        self._widget.setFocus()

    def session_state(self):
        return workspace.ContentSession(self.kind, {"path": self.path})


class FakeTerminalContent(FakeContent):
    kind = workspace.ContentKind.TERMINAL

    def title(self):
        return "Terminal"


class FakeTabWidget:
    def __init__(self):
        self.title = None

    def indexOf(self, _tab):
        return 2

    def set_page_title(self, index, title):
        self.title = (index, title)


class FakeBrowser:
    def __init__(self):
        self.widget = FakeTabWidget()
        self.window_title_updates = 0
        self.opened = None

    def _update_window_title(self):
        self.window_title_updates += 1

    def tabopen(self, url, background=False, related=False):
        self.opened = (url, background, related)


class FakeTab:
    def title(self):
        return "Files · /tmp/child"


def test_workspace_tab_wraps_native_content(qtbot):
    content = FakeContent()
    tab = workspacehost.WorkspaceTab(
        content,
        win_id=1,
        private=False,
    )
    qtbot.addWidget(tab)

    assert tab.kind is workspace.ContentKind.FILESYSTEM
    assert tab.title() == "Files · /tmp"
    assert tab.session_state() == workspace.ContentSession(
        workspace.ContentKind.FILESYSTEM,
        {"path": "/tmp"},
    )
    assert not tab.pending_removal
    assert not tab.data.pinned
    assert tab.data.input_mode is usertypes.KeyMode.passthrough


def test_terminal_tab_uses_passthrough_input_mode(qtbot):
    tab = workspacehost.WorkspaceTab(
        FakeTerminalContent(),
        win_id=1,
        private=False,
    )
    qtbot.addWidget(tab)

    assert tab.data.input_mode is usertypes.KeyMode.passthrough


def test_workspace_tab_registers_for_tab_scoped_lookups(qtbot, win_registry):
    win_registry.add_window(1)
    tab_registry = objreg.ObjectRegistry()
    objreg.register("tab-registry", tab_registry, scope="window", window=1)

    tab = workspacehost.WorkspaceTab(FakeContent(), win_id=1, private=False)
    qtbot.addWidget(tab)

    try:
        assert tab_registry[tab.tab_id] is tab
        assert objreg.get(
            "tab",
            scope="tab",
            window=1,
            tab=tab.tab_id,
        ) is tab
    finally:
        objreg.delete("tab-registry", scope="window", window=1)


def test_workspace_tab_focus_delegates(qtbot):
    content = FakeContent()
    tab = workspacehost.WorkspaceTab(content, win_id=1, private=False)
    qtbot.addWidget(tab)
    tab.show()

    tab.setFocus()

    assert content.focused


def test_workspace_tab_pin_state(qtbot):
    content = FakeContent()
    tab = workspacehost.WorkspaceTab(content, win_id=1, private=False)
    qtbot.addWidget(tab)

    tab.set_pinned(True)

    assert tab.data.pinned


def test_refresh_title_updates_tab_and_window():
    browser = FakeBrowser()

    workspacehost._refresh_title(browser, FakeTab())

    assert browser.widget.title == (2, "Files · /tmp/child")
    assert browser.window_title_updates == 1


def test_open_file_uses_local_file_url(tmp_path):
    browser = FakeBrowser()
    path = tmp_path / "page.html"
    path.write_text("<p>test</p>", encoding="utf-8")

    workspacehost._open_file(browser, str(path))

    url, background, related = browser.opened
    assert url == QUrl.fromLocalFile(str(Path(path).absolute()))
    assert not background
    assert related
