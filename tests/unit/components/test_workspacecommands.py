# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for workspace-aware command helpers."""

import inspect
from types import SimpleNamespace

import pytest

from qutebrowser.api import cmdutils
from qutebrowser.browser import workspace
from qutebrowser.components import workspacecommands, workspacepanes
from qutebrowser.qt.core import Qt


class FakeTabWidget:
    """Small tab-widget stand-in for destination routing tests."""

    def __init__(self, tabs=None, current=0):
        self.tabs = list(tabs or [])
        self.current = current

    def currentIndex(self):  # noqa: N802 - Qt API shape
        return self.current

    def count(self):
        return len(self.tabs)

    def widget(self, index):
        return self.tabs[index]

    def currentWidget(self):  # noqa: N802 - Qt API shape
        if not self.tabs:
            return None
        return self.tabs[self.current]


class FakeTabbedBrowser:
    """Record workspace tab opens/removals without constructing Qt tabs."""

    def __init__(self, tabs=None, current=0):
        self.widget = FakeTabWidget(tabs, current)
        self.workspace_opens = []
        self.removals = []
        self._window = object()

    def tabopen_workspace(
        self,
        content,
        *,
        background,
        related,
        idx=None,
    ):
        tab = SimpleNamespace(content=content)
        self.workspace_opens.append(
            {
                "content": content,
                "background": background,
                "related": related,
                "idx": idx,
                "tab": tab,
            }
        )
        return tab

    def _remove_tab(self, tab, *, add_undo):
        self.removals.append((tab, add_undo))

    def window(self):
        return self._window


class FakeDispatcher:
    """Command-dispatcher stand-in recording browser opens."""

    def __init__(self, tabbed_browser):
        self._tabbed_browser = tabbed_browser
        self.browser_opens = []

    def openurl(self, **kwargs):
        self.browser_opens.append(kwargs)
        return "browser-result"


def test_workspace_commands_register_without_replacing_open(monkeypatch):
    stock_open = object()
    commands = {"open": stock_open}
    monkeypatch.setattr(workspacecommands.objects, "commands", commands)

    workspacecommands._register_workspace_commands()

    assert commands["open"] is stock_open
    for name in ["browser", "terminal", "filesystem"]:
        registered = commands[name]
        handler = getattr(registered, "handler")
        parser = getattr(registered, "parser")
        assert next(iter(inspect.signature(handler).parameters)) == "self"
        assert parser.parse_args([]).tab is False
        assert parser.parse_args([]).bg is False
        assert parser.parse_args([]).vertical is False
        assert parser.parse_args([]).horizontal is False

        assert parser.parse_args(["-t"]).tab
        assert parser.parse_args(["-b"]).bg
        assert parser.parse_args(["-t", "-v"]).vertical
        assert parser.parse_args(["-t", "-h"]).horizontal

        parsed = vars(parser.parse_args([]))
        assert "application_terminal" not in parsed
        assert "application_browser" not in parsed
        assert "application_filesystem" not in parsed


@pytest.mark.parametrize(
    "kwargs,match",
    [
        (
            {"tab": False, "bg": False, "vertical": True, "horizontal": False},
            "require -t",
        ),
        (
            {"tab": False, "bg": False, "vertical": False, "horizontal": True},
            "require -t",
        ),
        (
            {"tab": True, "bg": False, "vertical": True, "horizontal": True},
            "-v/-h",
        ),
        (
            {"tab": False, "bg": True, "vertical": True, "horizontal": False},
            "require -t|Background",
        ),
        (
            {"tab": False, "bg": True, "vertical": False, "horizontal": True},
            "require -t|Background",
        ),
        (
            {"tab": True, "bg": True, "vertical": False, "horizontal": False},
            "-t/-b",
        ),
    ],
)
def test_validate_destination_rejects_invalid_combinations(kwargs, match):
    with pytest.raises(cmdutils.CommandError, match=match):
        workspacecommands._validate_destination(**kwargs)


def test_validate_destination_maps_visual_split_orientation():
    assert (
        workspacecommands._validate_destination(
            tab=True,
            bg=False,
            vertical=True,
            horizontal=False,
        )
        is Qt.Orientation.Horizontal
    )
    assert (
        workspacecommands._validate_destination(
            tab=True,
            bg=False,
            vertical=False,
            horizontal=True,
        )
        is Qt.Orientation.Vertical
    )


def test_replace_native_content_keeps_tab_index_and_removes_old_tab():
    old = object()
    browser = FakeTabbedBrowser([object(), old, object()], current=1)
    content = object()

    result = workspacecommands._replace_with_workspace(browser, content)

    assert result is browser.workspace_opens[0]["tab"]
    assert browser.workspace_opens == [
        {
            "content": content,
            "background": False,
            "related": False,
            "idx": 1,
            "tab": result,
        }
    ]
    assert browser.removals == [(old, False)]


@pytest.mark.parametrize(
    "tab,bg,expected_background",
    [(True, False, False), (False, True, True)],
)
def test_open_native_content_foreground_and_background_tabs(
    tab, bg, expected_background
):
    browser = FakeTabbedBrowser([object()])
    dispatcher = FakeDispatcher(browser)
    content = object()

    result = workspacecommands._open_native_content(
        dispatcher,
        content,
        tab=tab,
        bg=bg,
    )

    assert result is browser.workspace_opens[0]["tab"]
    assert browser.workspace_opens[0] == {
        "content": content,
        "background": expected_background,
        "related": False,
        "idx": None,
        "tab": result,
    }
    assert browser.removals == []


@pytest.mark.parametrize(
    "tab,bg",
    [(False, False), (True, False), (False, True)],
)
def test_open_browser_content_uses_stock_openurl_for_web_tabs(tab, bg):
    browser = FakeTabbedBrowser([object()])
    dispatcher = FakeDispatcher(browser)

    result = workspacecommands._open_browser_content(
        dispatcher,
        "https://example.com",
        tab=tab,
        bg=bg,
    )

    assert result == "browser-result"
    assert dispatcher.browser_opens == [
        {
            "url": "https://example.com",
            "related": False,
            "bg": bg,
            "tab": tab,
            "window": False,
            "count": None,
            "secure": False,
            "private": False,
        }
    ]


def test_open_browser_content_replaces_workspace_tab_without_web_navigation(
    monkeypatch,
):
    class FakeWorkspaceTab:
        pass

    monkeypatch.setattr(
        workspacecommands.workspacehost,
        "WorkspaceTab",
        FakeWorkspaceTab,
    )
    old = FakeWorkspaceTab()
    browser = FakeTabbedBrowser([old])
    dispatcher = FakeDispatcher(browser)

    result = workspacecommands._open_browser_content(
        dispatcher,
        None,
        tab=False,
        bg=False,
    )

    assert result is None
    assert dispatcher.browser_opens == [
        {
            "url": None,
            "related": False,
            "bg": False,
            "tab": True,
            "window": False,
            "count": None,
            "secure": False,
            "private": False,
        }
    ]
    assert browser.removals == [(old, False)]


def _filesystem_workspace_tab(monkeypatch, path):
    class FakeWorkspaceTab:
        pass

    monkeypatch.setattr(
        workspacecommands.workspacehost,
        "WorkspaceTab",
        FakeWorkspaceTab,
    )
    current = FakeWorkspaceTab()
    current.kind = workspace.ContentKind.FILESYSTEM
    current.content = SimpleNamespace(path=path)
    return current


def test_terminal_cwd_explicit_target_wins(monkeypatch):
    current = _filesystem_workspace_tab(monkeypatch, "/inherited")
    dispatcher = FakeDispatcher(FakeTabbedBrowser([current]))

    assert workspacecommands._terminal_cwd(dispatcher, "/explicit") == "/explicit"


def test_terminal_cwd_inherits_filesystem_path(monkeypatch):
    current = _filesystem_workspace_tab(monkeypatch, "/tmp/project")
    dispatcher = FakeDispatcher(FakeTabbedBrowser([current]))

    assert workspacecommands._terminal_cwd(dispatcher, None) == "/tmp/project"


def test_terminal_cwd_without_filesystem_context_is_none():
    dispatcher = FakeDispatcher(FakeTabbedBrowser([object()]))

    assert workspacecommands._terminal_cwd(dispatcher, None) is None


@pytest.mark.parametrize(
    "application,target,vertical,horizontal,orientation",
    [
        ("browser", "about:blank", True, False, Qt.Orientation.Horizontal),
        ("filesystem", "/tmp", True, False, Qt.Orientation.Horizontal),
        ("terminal", "/tmp", True, False, Qt.Orientation.Horizontal),
        ("browser", "about:blank", False, True, Qt.Orientation.Vertical),
        ("filesystem", "/tmp", False, True, Qt.Orientation.Vertical),
        ("terminal", "/tmp", False, True, Qt.Orientation.Vertical),
    ],
)
def test_open_application_delegates_splits_to_pane_manager(
    monkeypatch,
    application,
    target,
    vertical,
    horizontal,
    orientation,
):
    browser = FakeTabbedBrowser([object()])
    dispatcher = FakeDispatcher(browser)
    calls = []
    manager = SimpleNamespace(
        split_active=lambda **kwargs: calls.append(kwargs) or "split-result"
    )
    monkeypatch.setattr(
        workspacepanes,
        "_pane_manager",
        lambda window: manager if window is browser._window else None,
    )

    result = workspacecommands._open_application(
        dispatcher,
        application=application,
        target=target,
        tab=True,
        bg=False,
        vertical=vertical,
        horizontal=horizontal,
    )

    assert result == "split-result"
    assert calls == [
        {
            "orientation": orientation,
            "application": application,
            "target": target,
        }
    ]


def test_terminal_failure_does_not_break_browser_or_filesystem(monkeypatch):
    class BrokenTerminal:
        def __init__(self, cwd=None):
            raise RuntimeError("terminal unavailable")

    class FakeFilesystem:
        def __init__(self, path=None):
            self.path = path

    monkeypatch.setattr(
        workspacecommands.workspaceterminal,
        "TerminalContent",
        BrokenTerminal,
    )
    monkeypatch.setattr(
        workspacecommands.filesystemcontent,
        "FilesystemContent",
        FakeFilesystem,
    )
    browser = FakeTabbedBrowser([object()])
    dispatcher = FakeDispatcher(browser)

    terminal = getattr(workspacecommands.objects.commands["terminal"], "handler")
    browser_command = getattr(
        workspacecommands.objects.commands["browser"], "handler"
    )
    filesystem = getattr(
        workspacecommands.objects.commands["filesystem"], "handler"
    )

    with pytest.raises(cmdutils.CommandError, match="terminal unavailable"):
        terminal(dispatcher, target=None, tab=True)

    assert browser_command(dispatcher, target="about:blank", tab=True) == "browser-result"
    filesystem_result = filesystem(dispatcher, target="/tmp", tab=True)

    assert dispatcher.browser_opens[-1]["url"] == "about:blank"
    assert filesystem_result is browser.workspace_opens[-1]["tab"]
    assert browser.workspace_opens[-1]["content"].path == "/tmp"


def test_workspace_tab_clone_registers_instance_handler(monkeypatch):
    commands = {"tab-clone": object()}
    monkeypatch.setattr(workspacecommands.objects, "commands", commands)

    workspacecommands._register_workspace_tab_clone()

    registered = commands["tab-clone"]
    handler = getattr(registered, "handler")
    assert next(iter(inspect.signature(handler).parameters)) == "self"


def test_clone_filesystem_preserves_path(monkeypatch):
    seen = {}

    class FakeFilesystem:
        def __init__(self, path):
            seen["path"] = path

    monkeypatch.setattr(
        workspacecommands.filesystemcontent,
        "FilesystemContent",
        FakeFilesystem,
    )
    tab = SimpleNamespace(
        kind=workspace.ContentKind.FILESYSTEM,
        content=SimpleNamespace(path="/tmp/project"),
    )

    clone = workspacecommands._clone_workspace_content(tab)

    assert isinstance(clone, FakeFilesystem)
    assert seen == {"path": "/tmp/project"}


def test_clone_terminal_preserves_cwd_and_shell(monkeypatch):
    seen = {}

    class FakeTerminal:
        def __init__(self, cwd=None, shell=None):
            seen.update(cwd=cwd, shell=shell)

    monkeypatch.setattr(
        workspacecommands.workspaceterminal,
        "TerminalContent",
        FakeTerminal,
    )
    tab = SimpleNamespace(
        kind=workspace.ContentKind.TERMINAL,
        content=SimpleNamespace(cwd="/tmp/project", shell="/bin/zsh"),
    )

    clone = workspacecommands._clone_workspace_content(tab)

    assert isinstance(clone, FakeTerminal)
    assert seen == {"cwd": "/tmp/project", "shell": "/bin/zsh"}
