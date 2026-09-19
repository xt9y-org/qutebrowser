# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for workspace tab hosting."""

from qutebrowser.browser import workspace
from qutebrowser.mainwindow import workspacehost
from qutebrowser.qt.widgets import QLabel


class FakeContent:
    kind = workspace.ContentKind.FILESYSTEM

    def __init__(self):
        self._widget = QLabel("content")
        self.focused = False
        self.path = "/tmp"

    @property
    def widget(self):
        return self._widget

    def title(self):
        return "Files · {}".format(self.path)

    def focus(self):
        self.focused = True
        self._widget.setFocus()

    def session_state(self):
        return workspace.ContentSession(self.kind, {"path": self.path})


def test_workspace_tab_wraps_native_content(qtbot):
    content = FakeContent()
    tab = workspacehost.WorkspaceTab(
        content,
        win_id=1,
        private=False,
    )
    qtbot.addWidget(tab)

    assert tab.kind is workspace.ContentKind.FILESYSTEM
    assert tab.title() == "Files · /tmp"
    assert tab.session_state() == workspace.ContentSession(
        workspace.ContentKind.FILESYSTEM,
        {"path": "/tmp"},
    )
    assert not tab.pending_removal
    assert not tab.data.pinned


def test_workspace_tab_focus_delegates(qtbot):
    content = FakeContent()
    tab = workspacehost.WorkspaceTab(content, win_id=1, private=False)
    qtbot.addWidget(tab)
    tab.show()

    tab.setFocus()

    assert content.focused


def test_workspace_tab_pin_state(qtbot):
    content = FakeContent()
    tab = workspacehost.WorkspaceTab(content, win_id=1, private=False)
    qtbot.addWidget(tab)

    tab.set_pinned(True)

    assert tab.data.pinned
