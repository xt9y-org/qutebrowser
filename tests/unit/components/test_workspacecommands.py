# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for workspace-aware command helpers."""

import inspect
from types import SimpleNamespace

import pytest

from qutebrowser.api import cmdutils
from qutebrowser.browser import workspace
from qutebrowser.components import workspacecommands
from qutebrowser.qt.core import Qt


def test_workspace_commands_register_without_replacing_open(monkeypatch):
    stock_open = object()
    commands = {"open": stock_open}
    monkeypatch.setattr(workspacecommands.objects, "commands", commands)

    workspacecommands._register_workspace_commands()

    assert commands["open"] is stock_open
    for name in ["browser", "terminal", "filesystem"]:
        command = commands[name]
        assert next(iter(inspect.signature(command.handler).parameters)) == "self"
        assert command.parser.parse_args([]).tab is False
        assert command.parser.parse_args([]).bg is False
        assert command.parser.parse_args([]).vertical is False
        assert command.parser.parse_args([]).horizontal is False

        assert command.parser.parse_args(["-t"]).tab
        assert command.parser.parse_args(["-b"]).bg
        assert command.parser.parse_args(["-t", "-v"]).vertical
        assert command.parser.parse_args(["-t", "-h"]).horizontal

        parsed = vars(command.parser.parse_args([]))
        assert "application_terminal" not in parsed
        assert "application_browser" not in parsed
        assert "application_filesystem" not in parsed


@pytest.mark.parametrize(
    "kwargs,match",
    [
        ({"tab": False, "bg": False, "vertical": True, "horizontal": False}, "require -t"),
        ({"tab": False, "bg": False, "vertical": False, "horizontal": True}, "require -t"),
        ({"tab": True, "bg": False, "vertical": True, "horizontal": True}, "-v/-h"),
        ({"tab": False, "bg": True, "vertical": True, "horizontal": False}, "require -t|Background"),
        ({"tab": False, "bg": True, "vertical": False, "horizontal": True}, "require -t|Background"),
        ({"tab": True, "bg": True, "vertical": False, "horizontal": False}, "-t/-b"),
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


def test_workspace_tab_clone_registers_instance_handler(monkeypatch):
    commands = {"tab-clone": object()}
    monkeypatch.setattr(workspacecommands.objects, "commands", commands)

    workspacecommands._register_workspace_tab_clone()

    command = commands["tab-clone"]
    assert next(iter(inspect.signature(command.handler).parameters)) == "self"


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
