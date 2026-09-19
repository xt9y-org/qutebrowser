# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for workspace-aware session persistence."""

import pytest

from qutebrowser.components import workspacesessions
from qutebrowser.mainwindow import mainwindow as mainwindow_module
from qutebrowser.misc import sessions


class FakeQApplication:
    def __init__(self, window):
        self._window = window

    def activeWindow(self):
        return self._window


class FakeTabWidget:
    def __init__(self, current=0):
        self._current = current

    def currentIndex(self):
        return self._current


class FakeBrowser:
    is_private = False

    def __init__(self, tabs):
        self._tabs = tabs
        self.widget = FakeTabWidget()

    def widgets(self):
        return list(self._tabs)


class FakeWindow:
    win_id = 7

    def __init__(self, browser, pane_manager=None):
        self.tabbed_browser = browser
        self._workspace_pane_manager = pane_manager

    def saveGeometry(self):
        return b"geometry"


class FakeSessionManager:
    def _save_tab(self, tab, active, with_history=True):
        return {
            "tab": tab,
            "active": active,
            "history": with_history,
        }

    def _load_tab(self, tab, data):
        del tab, data


def _install_window(monkeypatch, window):
    monkeypatch.setattr(workspacesessions.sip, "isdeleted", lambda _window: False)
    monkeypatch.setattr(
        workspacesessions.objreg,
        "get",
        lambda *_args, **_kwargs: window,
    )
    monkeypatch.setattr(
        workspacesessions.objects,
        "qapp",
        FakeQApplication(window),
    )


def test_stock_window_keeps_stock_tabs(monkeypatch):
    browser = FakeBrowser(["one", "two"])
    window = FakeWindow(browser)
    _install_window(monkeypatch, window)

    data = workspacesessions._window_data(
        FakeSessionManager(),
        win_id=7,
        with_history=False,
    )

    assert data == {
        "active": True,
        "geometry": b"geometry",
        "tabs": [
            {"tab": "one", "active": True, "history": False},
            {"tab": "two", "active": False, "history": False},
        ],
    }


def test_workspace_window_uses_extended_state(monkeypatch):
    class FakePaneManager:
        def has_workspace_state(self):
            return True

        def session_state(self, save_tab):
            return {
                "layout": {"type": "pane", "data": save_tab("browser", True)},
                "active-pane": 0,
            }

    browser = FakeBrowser(["ignored-stock-tab"])
    window = FakeWindow(browser, FakePaneManager())
    _install_window(monkeypatch, window)

    data = workspacesessions._window_data(
        FakeSessionManager(),
        win_id=7,
        with_history=True,
    )

    assert "tabs" not in data
    assert data["workspace"] == {
        "layout": {
            "type": "pane",
            "data": {"tab": "browser", "active": True, "history": True},
        },
        "active-pane": 0,
    }


def test_load_workspace_window_restores_and_shows(monkeypatch):
    restored = {}

    class FakePaneManager:
        active = type("Active", (), {"widget": object()})()

        def restore_session(self, state, loader):
            restored["state"] = state
            restored["loader"] = loader

    class RestoredWindow:
        def __init__(self, geometry=None, private=None):
            restored["geometry"] = geometry
            restored["private"] = private
            self._workspace_pane_manager = FakePaneManager()
            self.shown = False
            self.closed = False

        def show(self):
            self.shown = True
            restored["shown"] = True

        def close(self):
            self.closed = True
            restored["closed"] = True

    monkeypatch.setattr(mainwindow_module, "MainWindow", RestoredWindow)
    manager = FakeSessionManager()
    workspace_state = {"layout": {"type": "split"}, "active-pane": 0}

    window = workspacesessions._load_workspace_window(
        manager,
        {
            "geometry": b"g",
            "private": True,
            "workspace": workspace_state,
        },
    )

    assert restored["geometry"] == b"g"
    assert restored["private"] is True
    assert restored["state"] == workspace_state
    assert restored["loader"] == manager._load_tab
    assert restored["shown"]
    assert window is not None


def test_load_workspace_window_closes_on_restore_error(monkeypatch):
    state = {}

    class FailingPaneManager:
        def restore_session(self, _state, _loader):
            raise ValueError("bad layout")

    class RestoredWindow:
        def __init__(self, **_kwargs):
            self._workspace_pane_manager = FailingPaneManager()
            state["window"] = self
            self.closed = False

        def close(self):
            self.closed = True

    monkeypatch.setattr(mainwindow_module, "MainWindow", RestoredWindow)

    with pytest.raises(sessions.SessionError, match="bad layout"):
        workspacesessions._load_workspace_window(
            FakeSessionManager(),
            {"geometry": b"g", "workspace": {}},
        )

    assert state["window"].closed
