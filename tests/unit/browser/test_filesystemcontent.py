# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for native filesystem workspace content."""

from pathlib import Path

from qutebrowser.browser import filesystemcontent, workspace


def test_filesystem_content_defaults_to_home(qtbot, monkeypatch, tmp_path):
    monkeypatch.setattr(Path, "home", classmethod(lambda cls: tmp_path))

    content = filesystemcontent.FilesystemContent()
    qtbot.addWidget(content.widget)

    assert content.kind is workspace.ContentKind.FILESYSTEM
    assert content.path == tmp_path.resolve()
    assert content.title() == "Files · {}".format(tmp_path.resolve())


def test_filesystem_content_changes_directory(qtbot, tmp_path):
    child = tmp_path / "child"
    child.mkdir()
    content = filesystemcontent.FilesystemContent(tmp_path)
    qtbot.addWidget(content.widget)

    content.set_path(child)

    assert content.path == child.resolve()
    assert content.session_state() == workspace.ContentSession(
        kind=workspace.ContentKind.FILESYSTEM,
        state={"path": str(child.resolve())},
    )


def test_filesystem_content_rejects_files(qtbot, tmp_path):
    file_path = tmp_path / "not-a-directory.txt"
    file_path.write_text("x", encoding="utf-8")
    content = filesystemcontent.FilesystemContent(tmp_path)
    qtbot.addWidget(content.widget)

    try:
        content.set_path(file_path)
    except NotADirectoryError:
        pass
    else:
        raise AssertionError("set_path accepted a file")


def test_filesystem_content_focuses_tree(qtbot, tmp_path):
    content = filesystemcontent.FilesystemContent(tmp_path)
    qtbot.addWidget(content.widget)
    content.widget.show()

    content.focus()

    assert content.tree.hasFocus()
