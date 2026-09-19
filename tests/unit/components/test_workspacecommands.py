# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for workspace-aware command helpers."""

from types import SimpleNamespace

from qutebrowser.browser import workspace
from qutebrowser.components import workspacecommands


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
