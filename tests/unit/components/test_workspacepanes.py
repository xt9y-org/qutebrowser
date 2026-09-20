# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for workspace pane command integration."""

from types import SimpleNamespace

from qutebrowser.components import workspacepanes  # noqa: F401
from qutebrowser.misc import objects


def test_legacy_workspace_split_is_not_registered():
    legacy_name = "workspace" + "-split"
    assert legacy_name not in objects.commands


class FakePaneManager:
    def __init__(self, pane_count):
        self._panes = [object() for _ in range(pane_count)]
        self.focus_offsets = []

    def pane_widgets(self):
        return self._panes

    def focus_relative(self, offset):
        self.focus_offsets.append(offset)


class FakeDispatcher:
    def __init__(self):
        self.next_calls = 0
        self.prev_calls = 0

    def tab_next(self):
        self.next_calls += 1

    def tab_prev(self):
        self.prev_calls += 1


class FakeWindow:
    def __init__(self, pane_count):
        self._workspace_pane_manager = FakePaneManager(pane_count)
        self._command_dispatcher = FakeDispatcher()


def test_workspace_pane_next_cycles_splits_when_split_exists():
    window = FakeWindow(2)

    workspacepanes.workspace_pane_next(window)

    assert window._workspace_pane_manager.focus_offsets == [1]
    assert window._command_dispatcher.next_calls == 0


def test_workspace_pane_next_falls_back_to_tab_navigation_without_split():
    window = FakeWindow(1)

    workspacepanes.workspace_pane_next(window)

    assert window._workspace_pane_manager.focus_offsets == []
    assert window._command_dispatcher.next_calls == 1


def test_workspace_pane_prev_cycles_splits_when_split_exists():
    window = FakeWindow(2)

    workspacepanes.workspace_pane_prev(window)

    assert window._workspace_pane_manager.focus_offsets == [-1]
    assert window._command_dispatcher.prev_calls == 0


def test_workspace_pane_prev_falls_back_to_tab_navigation_without_split():
    window = FakeWindow(1)

    workspacepanes.workspace_pane_prev(window)

    assert window._workspace_pane_manager.focus_offsets == []
    assert window._command_dispatcher.prev_calls == 1


def test_activate_marks_only_target_pane_active(monkeypatch):
    class FakeTabBar:
        def __init__(self):
            self.states = []

        def set_workspace_pane_active(self, active):
            self.states.append(active)

    class FakePaneWidget:
        def __init__(self):
            self.bar = FakeTabBar()
            self.focused = False

        def tab_bar(self):
            return self.bar

        def currentWidget(self):
            return SimpleNamespace(setFocus=lambda: setattr(self, "focused", True))

    first = SimpleNamespace(widget=FakePaneWidget())
    second = SimpleNamespace(widget=FakePaneWidget())
    window = SimpleNamespace(
        win_id=4,
        _command_dispatcher=SimpleNamespace(_tabbed_browser=first),
    )
    manager = SimpleNamespace(
        active=first,
        window=window,
        _browsers={first.widget: first, second.widget: second},
    )
    monkeypatch.setattr(workspacepanes.objreg, "register", lambda *_a, **_kw: None)

    workspacepanes.PaneManager.activate(manager, second)

    assert first.widget.bar.states == [False]
    assert second.widget.bar.states == [True]
    assert manager.active is second
    assert second.widget.focused


def test_release_focus_target_uses_active_secondary_pane():
    primary = SimpleNamespace()
    secondary = SimpleNamespace()
    manager = SimpleNamespace(primary=primary, active=secondary)
    window = SimpleNamespace(_workspace_pane_manager=manager)

    assert workspacepanes._release_focus_target(primary, window) is secondary


def test_release_focus_target_keeps_browser_without_workspace_manager():
    browser = SimpleNamespace()
    window = SimpleNamespace()

    assert workspacepanes._release_focus_target(browser, window) is browser


def test_primary_release_focus_routes_to_active_secondary_pane():
    focused = []
    tab = SimpleNamespace(setFocus=lambda: focused.append(True))
    secondary = SimpleNamespace(
        widget=SimpleNamespace(currentWidget=lambda: tab),
    )
    window = SimpleNamespace()
    primary = SimpleNamespace(window=lambda: window)
    window._workspace_pane_manager = SimpleNamespace(
        primary=primary,
        active=secondary,
    )

    workspacepanes.tabbedbrowser.TabbedBrowser.on_release_focus(primary)

    assert focused == [True]
