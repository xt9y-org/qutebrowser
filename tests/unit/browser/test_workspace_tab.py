# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for generic non-web workspace tabs."""

from qutebrowser.browser import workspace
from qutebrowser.qt.core import QUrl


def test_workspace_tab_wraps_filesystem_content(qtbot, tmp_path):
    content = workspace.FilesystemContent(tmp_path)
    tab = workspace.WorkspaceTab(
        content,
        win_id=7,
        private=False,
    )
    qtbot.addWidget(tab)

    assert tab.kind is workspace.ContentKind.FILESYSTEM
    assert tab.content is content
    assert tab.session_state() == content.session_state()
    assert tab.location() == QUrl.fromLocalFile(str(tmp_path.resolve()))
    assert tab.data.pinned is False


def test_workspace_tab_tracks_filesystem_path(qtbot, tmp_path):
    child = tmp_path / "child"
    child.mkdir()
    content = workspace.FilesystemContent(tmp_path)
    tab = workspace.WorkspaceTab(
        content,
        win_id=7,
        private=False,
    )
    qtbot.addWidget(tab)

    with qtbot.waitSignal(tab.title_changed) as blocker:
        content.set_path(child)

    assert blocker.args == [str(child.resolve())]
    assert tab.title() == str(child.resolve())
    assert tab.location() == QUrl.fromLocalFile(str(child.resolve()))


def test_workspace_tab_focuses_content(qtbot, tmp_path):
    content = workspace.FilesystemContent(tmp_path)
    tab = workspace.WorkspaceTab(
        content,
        win_id=7,
        private=False,
    )
    qtbot.addWidget(tab)
    tab.show()

    tab.focus_content()

    assert content.view.hasFocus()
