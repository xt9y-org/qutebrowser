# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for workspace-aware command helpers."""

from types import SimpleNamespace

from qutebrowser.browser import workspace
from qutebrowser.components import workspacecommands


def test_workspace_open_keeps_legacy_flags_with_application_selector(monkeypatch):
    commands = {"open": object()}
    monkeypatch.setattr(workspacecommands.objects, "commands", commands)

    workspacecommands._register_workspace_open()

    command = commands["open"]
    namespace = command.parser.parse_args(
        ["-t", "-at", "--secure", "--related", "example.org"]
    )
    assert namespace.tab
    assert namespace.application_terminal
    assert namespace.secure
    assert namespace.related
    assert namespace.url == "example.org"

    for flag, attribute in [
        ("-b", "bg"),
        ("-w", "window"),
        ("-p", "private"),
        ("-s", "secure"),
        ("-r", "related"),
    ]:
        parsed = command.parser.parse_args([flag])
        assert getattr(parsed, attribute)


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
