# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for workspace pane movement and resizing."""

from qutebrowser.qt.core import Qt
from qutebrowser.qt.widgets import QLabel
from qutebrowser.mainwindow import workspacesplit
from qutebrowser.components import workspacepaneops


def test_move_relative_swaps_visual_order(qtbot):
    first = QLabel("first")
    second = QLabel("second")
    layout = workspacesplit.SplitLayout(first)
    qtbot.addWidget(layout)
    layout.split(first, second, Qt.Orientation.Horizontal)

    workspacepaneops.move_relative(layout, first, 1)

    assert layout.pane_widgets() == [second, first]


def test_resize_pane_grows_active_leaf(qtbot):
    first = QLabel("first")
    second = QLabel("second")
    layout = workspacesplit.SplitLayout(first)
    qtbot.addWidget(layout)
    layout.resize(500, 200)
    layout.show()
    layout.split(first, second, Qt.Orientation.Horizontal)
    layout.root.setSizes([250, 250])
    qtbot.wait(1)
    before = layout.root.sizes()

    workspacepaneops.resize_pane(first, 50)

    after = layout.root.sizes()
    assert after[0] > before[0]
    assert after[1] < before[1]
