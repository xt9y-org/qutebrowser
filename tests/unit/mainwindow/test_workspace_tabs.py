# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for native workspace content in qutebrowser's tab bar."""

from qutebrowser.browser import workspace
from qutebrowser.components import workspacetabs
from qutebrowser.mainwindow import tabwidget
from qutebrowser.qt.core import QUrl
from qutebrowser.utils import usertypes


def test_tabwidget_accepts_filesystem_workspace(
    qtbot,
    monkeypatch,
    config_stub,
    tmp_path,
):
    monkeypatch.setattr(
        tabwidget.objects,
        "backend",
        usertypes.Backend.QtWebKit,
    )
    widget = workspacetabs.WorkspaceTabWidget(0)
    qtbot.addWidget(widget)

    content = workspace.FilesystemContent(tmp_path)
    tab = workspace.WorkspaceTab(
        content,
        win_id=0,
        private=False,
        parent=widget,
    )

    idx = widget.addTab(tab, tab.title())

    assert idx == 0
    assert widget.widget(0) is tab
    assert widget.page_title(0) == str(tmp_path.resolve())
    assert widget.tab_url(0) == QUrl.fromLocalFile(str(tmp_path.resolve()))

    fields = widget.get_tab_fields(0)
    assert fields["current_title"] == str(tmp_path.resolve())
    assert fields["current_url"] == QUrl.fromLocalFile(
        str(tmp_path.resolve())
    ).toDisplayString()
    assert fields["audio"] == ""
    assert fields["perc"] == ""
    assert fields["scroll_pos"] == ""


def test_workspace_title_updates_with_path(
    qtbot,
    monkeypatch,
    config_stub,
    tmp_path,
):
    monkeypatch.setattr(
        tabwidget.objects,
        "backend",
        usertypes.Backend.QtWebKit,
    )
    widget = workspacetabs.WorkspaceTabWidget(0)
    qtbot.addWidget(widget)

    child = tmp_path / "child"
    child.mkdir()
    content = workspace.FilesystemContent(tmp_path)
    tab = workspace.WorkspaceTab(
        content,
        win_id=0,
        private=False,
        parent=widget,
    )
    idx = widget.addTab(tab, tab.title())
    tab.title_changed.connect(lambda title: widget.set_page_title(idx, title))

    content.set_path(child)

    assert widget.page_title(idx) == str(child.resolve())
