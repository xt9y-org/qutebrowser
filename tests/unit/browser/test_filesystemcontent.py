# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for native filesystem workspace content."""

import os
from pathlib import Path

import pytest

from qutebrowser.browser import filesystemcontent, workspace


def test_filesystem_content_defaults_to_home(qtbot, monkeypatch, tmp_path):
    monkeypatch.setattr(Path, "home", classmethod(lambda cls: tmp_path))

    content = filesystemcontent.FilesystemContent()
    qtbot.addWidget(content.widget)

    assert content.kind is workspace.ContentKind.FILESYSTEM
    assert content.path == tmp_path.absolute()
    assert content.title() == "Files · {}".format(tmp_path.absolute())


def test_filesystem_content_changes_directory(qtbot, tmp_path):
    child = tmp_path / "child"
    child.mkdir()
    content = filesystemcontent.FilesystemContent(tmp_path)
    qtbot.addWidget(content.widget)

    content.set_path(child)

    assert content.path == child.absolute()
    assert content.session_state() == workspace.ContentSession(
        kind=workspace.ContentKind.FILESYSTEM,
        state={"path": str(child.absolute())},
    )


def test_filesystem_content_preserves_symlink_path(qtbot, tmp_path):
    target = tmp_path / "target"
    target.mkdir()
    link = tmp_path / "link"
    try:
        link.symlink_to(target, target_is_directory=True)
    except OSError as error:
        pytest.skip("symlinks unavailable: {}".format(error))

    content = filesystemcontent.FilesystemContent(link)
    qtbot.addWidget(content.widget)

    assert content.path == link.absolute()


def test_filesystem_content_rejects_files(qtbot, tmp_path):
    file_path = tmp_path / "not-a-directory.txt"
    file_path.write_text("x", encoding="utf-8")
    content = filesystemcontent.FilesystemContent(tmp_path)
    qtbot.addWidget(content.widget)

    with pytest.raises(NotADirectoryError):
        content.set_path(file_path)


def test_filesystem_content_rejects_inaccessible_directory(
    qtbot, tmp_path, monkeypatch
):
    content = filesystemcontent.FilesystemContent(tmp_path)
    qtbot.addWidget(content.widget)
    child = tmp_path / "child"
    child.mkdir()
    original_access = os.access

    def fake_access(path, mode):
        if Path(path) == child.absolute():
            return False
        return original_access(path, mode)

    monkeypatch.setattr(os, "access", fake_access)

    with pytest.raises(PermissionError):
        content.set_path(child)


def test_filesystem_roots_are_deduplicated(monkeypatch):
    monkeypatch.setattr(
        filesystemcontent,
        "_mounted_root_paths",
        lambda: [Path("/mnt/a"), Path("/mnt/a"), Path("/mnt/b")],
    )

    assert filesystemcontent.filesystem_roots() == [
        Path("/mnt/a"),
        Path("/mnt/b"),
    ]


def test_parent_navigation(qtbot, tmp_path):
    child = tmp_path / "child"
    child.mkdir()
    content = filesystemcontent.FilesystemContent(child)
    qtbot.addWidget(content.widget)

    content.go_parent()

    assert content.path == tmp_path.absolute()


def test_filesystem_content_focuses_tree(qtbot, tmp_path):
    content = filesystemcontent.FilesystemContent(tmp_path)
    qtbot.addWidget(content.widget)
    content.widget.show()

    content.focus()

    assert content.tree.hasFocus()
