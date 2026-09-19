# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for workspace content session serialization."""

from qutebrowser.browser import workspace, workspacefactory


class FakeContent:
    kind = workspace.ContentKind.FILESYSTEM

    def session_state(self):
        return workspace.ContentSession(self.kind, {"path": "/tmp"})


def test_serialize_content():
    assert workspacefactory.serialize_content(FakeContent()) == {
        "kind": "filesystem",
        "state": {"path": "/tmp"},
    }


def test_restore_filesystem_content(monkeypatch):
    seen = {}

    class FakeFilesystem:
        def __init__(self, path):
            seen["path"] = path

    monkeypatch.setattr(
        workspacefactory.filesystemcontent,
        "FilesystemContent",
        FakeFilesystem,
    )

    content = workspacefactory.create_content({
        "kind": "filesystem",
        "state": {"path": "/tmp/files"},
    })

    assert isinstance(content, FakeFilesystem)
    assert seen == {"path": "/tmp/files"}


def test_restore_terminal_content(monkeypatch):
    seen = {}

    class FakeTerminal:
        def __init__(self, cwd=None, shell=None):
            seen.update(cwd=cwd, shell=shell)

    monkeypatch.setattr(
        workspacefactory.workspaceterminal,
        "TerminalContent",
        FakeTerminal,
    )

    content = workspacefactory.create_content({
        "kind": "terminal",
        "state": {"cwd": "/tmp/project", "shell": "/bin/zsh"},
    })

    assert isinstance(content, FakeTerminal)
    assert seen == {"cwd": "/tmp/project", "shell": "/bin/zsh"}
