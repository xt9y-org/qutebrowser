# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for workspace tab hosting."""

from pathlib import Path
from types import SimpleNamespace

from qutebrowser.browser import workspace
from qutebrowser.mainwindow import tabbedbrowser, workspacehost
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
    assert tab.data.input_mode is usertypes.KeyMode.normal


def test_workspace_tab_can_be_resolved_as_current_tab(qtbot, tab_registry):
    tab = workspacehost.WorkspaceTab(
        FakeTerminalContent(),
        win_id=0,
        private=False,
    )
    qtbot.addWidget(tab)

    browser = SimpleNamespace(
        widget=SimpleNamespace(currentWidget=lambda: tab),
    )
    objreg.register('tabbed-browser', browser, scope='window', window=0)
    try:
        assert objreg.get(
            'tab', scope='tab', window=0, tab='current'
        ) is tab
        assert tab_registry[tab.tab_id] is tab
    finally:
        objreg.delete('tabbed-browser', scope='window', window=0)


def test_filesystem_tab_starts_in_normal_mode(qtbot):
    tab = workspacehost.WorkspaceTab(
        FakeContent(),
        win_id=1,
        private=False,
    )
    qtbot.addWidget(tab)

    assert tab.data.input_mode is usertypes.KeyMode.normal


def test_terminal_tab_starts_in_normal_mode(qtbot):
    tab = workspacehost.WorkspaceTab(
        FakeTerminalContent(),
        win_id=1,
        private=False,
    )
    qtbot.addWidget(tab)

    assert tab.data.input_mode is usertypes.KeyMode.normal


def test_workspace_escape_leaves_passthrough(monkeypatch):
    calls = []
    monkeypatch.setattr(
        workspacehost.modeman,
        "leave",
        lambda *args, **kwargs: calls.append((args, kwargs)),
    )

    workspacehost._leave_workspace_input(SimpleNamespace(_win_id=7))

    assert calls == [
        (
            (7, usertypes.KeyMode.passthrough, "workspace escape"),
            {"maybe": True},
        )
    ]


def test_workspace_tab_change_keeps_terminal_in_normal_mode(
    qtbot, config_stub, monkeypatch,
):
    config_stub.val.tabs.mode_on_change = "normal"
    tab = workspacehost.WorkspaceTab(
        FakeTerminalContent(),
        win_id=1,
        private=False,
    )
    qtbot.addWidget(tab)
    entered = []

    monkeypatch.setattr(
        workspacehost.modeman,
        "instance",
        lambda _win_id: SimpleNamespace(mode=usertypes.KeyMode.normal),
    )
    monkeypatch.setattr(
        workspacehost.modeman,
        "enter",
        lambda *args: entered.append(args),
    )
    monkeypatch.setattr(workspacehost.modeman, "leave", lambda *args, **kwargs: None)
    monkeypatch.setattr(workspacehost.QTimer, "singleShot", lambda *_args: None)

    signal = SimpleNamespace(emit=lambda *_args: None)
    browser = SimpleNamespace(
        widget=SimpleNamespace(
            widget=lambda _idx: tab,
            currentIndex=lambda: 0,
        ),
        is_shutting_down=False,
        _win_id=1,
        _now_focused=None,
        tab_deque=SimpleNamespace(on_switch=lambda _tab: None),
        cur_url_changed=signal,
        cur_progress=signal,
        cur_load_status_changed=signal,
        _update_window_title=lambda: None,
        _tab_insert_idx_left=0,
        _tab_insert_idx_right=0,
    )

    tabbedbrowser.TabbedBrowser._on_current_changed(browser, 0)

    assert entered == []


def test_workspace_tab_change_keeps_filesystem_in_normal_mode(
    qtbot, config_stub, monkeypatch,
):
    config_stub.val.tabs.mode_on_change = "normal"
    tab = workspacehost.WorkspaceTab(
        FakeContent(),
        win_id=1,
        private=False,
    )
    qtbot.addWidget(tab)
    entered = []

    monkeypatch.setattr(
        workspacehost.modeman,
        "instance",
        lambda _win_id: SimpleNamespace(mode=usertypes.KeyMode.normal),
    )
    monkeypatch.setattr(
        workspacehost.modeman,
        "enter",
        lambda *args: entered.append(args),
    )
    monkeypatch.setattr(workspacehost.modeman, "leave", lambda *args, **kwargs: None)
    monkeypatch.setattr(workspacehost.QTimer, "singleShot", lambda *_args: None)

    signal = SimpleNamespace(emit=lambda *_args: None)
    browser = SimpleNamespace(
        widget=SimpleNamespace(
            widget=lambda _idx: tab,
            currentIndex=lambda: 0,
        ),
        is_shutting_down=False,
        _win_id=1,
        _now_focused=None,
        tab_deque=SimpleNamespace(on_switch=lambda _tab: None),
        cur_url_changed=signal,
        cur_progress=signal,
        cur_load_status_changed=signal,
        _update_window_title=lambda: None,
        _tab_insert_idx_left=0,
        _tab_insert_idx_right=0,
    )

    tabbedbrowser.TabbedBrowser._on_current_changed(browser, 0)

    assert entered == []


def test_workspace_tab_change_does_not_restore_workspace_input_mode(
    qtbot, config_stub, monkeypatch,
):
    config_stub.val.tabs.mode_on_change = "restore"
    tab = workspacehost.WorkspaceTab(
        FakeContent(),
        win_id=1,
        private=False,
    )
    tab.data.input_mode = usertypes.KeyMode.passthrough
    qtbot.addWidget(tab)
    entered = []

    monkeypatch.setattr(
        workspacehost.modeman,
        "instance",
        lambda _win_id: SimpleNamespace(mode=usertypes.KeyMode.normal),
    )
    monkeypatch.setattr(
        workspacehost.modeman,
        "enter",
        lambda *args: entered.append(args),
    )
    monkeypatch.setattr(workspacehost.modeman, "leave", lambda *args, **kwargs: None)
    monkeypatch.setattr(workspacehost.QTimer, "singleShot", lambda *_args: None)

    signal = SimpleNamespace(emit=lambda *_args: None)
    browser = SimpleNamespace(
        widget=SimpleNamespace(
            widget=lambda _idx: tab,
            currentIndex=lambda: 0,
        ),
        is_shutting_down=False,
        _win_id=1,
        _now_focused=None,
        tab_deque=SimpleNamespace(on_switch=lambda _tab: None),
        cur_url_changed=signal,
        cur_progress=signal,
        cur_load_status_changed=signal,
        _update_window_title=lambda: None,
        _tab_insert_idx_left=0,
        _tab_insert_idx_right=0,
    )

    tabbedbrowser.TabbedBrowser._on_current_changed(browser, 0)

    assert entered == []


def test_workspace_tab_mode_restore_survives_tab_switch(
    qtbot, config_stub,
):
    config_stub.val.tabs.mode_on_change = "restore"
    tab = workspacehost.WorkspaceTab(
        FakeTerminalContent(),
        win_id=1,
        private=False,
    )
    qtbot.addWidget(tab)
    browser = SimpleNamespace(
        widget=SimpleNamespace(currentWidget=lambda: tab),
    )

    tabbedbrowser.TabbedBrowser.on_mode_entered(
        browser,
        usertypes.KeyMode.passthrough,
    )
    assert tab.data.input_mode is usertypes.KeyMode.passthrough

    tabbedbrowser.TabbedBrowser.on_mode_left(browser)
    assert tab.data.input_mode is usertypes.KeyMode.normal


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
