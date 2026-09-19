# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for workspace pane splitting."""

from qutebrowser.qt.core import Qt
from qutebrowser.qt.widgets import QLabel, QSplitter
from qutebrowser.mainwindow import workspacesplit


def test_split_layout_starts_with_primary(qtbot):
    primary = QLabel("primary")
    layout = workspacesplit.SplitLayout(primary)
    qtbot.addWidget(layout)

    assert layout.pane_widgets() == [primary]


def test_horizontal_split_is_side_by_side(qtbot):
    primary = QLabel("primary")
    secondary = QLabel("secondary")
    layout = workspacesplit.SplitLayout(primary)
    qtbot.addWidget(layout)

    layout.split(primary, secondary, Qt.Orientation.Horizontal)

    assert layout.root.orientation() is Qt.Orientation.Horizontal
    assert layout.pane_widgets() == [primary, secondary]


def test_vertical_split_is_stacked(qtbot):
    primary = QLabel("primary")
    secondary = QLabel("secondary")
    layout = workspacesplit.SplitLayout(primary)
    qtbot.addWidget(layout)

    layout.split(primary, secondary, Qt.Orientation.Vertical)

    assert layout.root.orientation() is Qt.Orientation.Vertical
    assert layout.pane_widgets() == [primary, secondary]


def test_mixed_orientation_creates_nested_splitter(qtbot):
    first = QLabel("first")
    second = QLabel("second")
    third = QLabel("third")
    layout = workspacesplit.SplitLayout(first)
    qtbot.addWidget(layout)

    layout.split(first, second, Qt.Orientation.Horizontal)
    layout.split(second, third, Qt.Orientation.Vertical)

    assert layout.root.orientation() is Qt.Orientation.Horizontal
    nested = layout.root.widget(1)
    assert isinstance(nested, QSplitter)
    assert nested.orientation() is Qt.Orientation.Vertical
    assert layout.pane_widgets() == [first, second, third]


def test_close_collapses_nested_splitter(qtbot):
    first = QLabel("first")
    second = QLabel("second")
    third = QLabel("third")
    layout = workspacesplit.SplitLayout(first)
    qtbot.addWidget(layout)
    layout.split(first, second, Qt.Orientation.Horizontal)
    layout.split(second, third, Qt.Orientation.Vertical)

    layout.close(third)

    assert layout.pane_widgets() == [first, second]
    assert layout.root.widget(1) is second


def test_cannot_close_last_pane(qtbot):
    primary = QLabel("primary")
    layout = workspacesplit.SplitLayout(primary)
    qtbot.addWidget(layout)

    assert not layout.close(primary)
    assert layout.pane_widgets() == [primary]


def test_swap_simple_panes(qtbot):
    first = QLabel("first")
    second = QLabel("second")
    layout = workspacesplit.SplitLayout(first)
    qtbot.addWidget(layout)
    layout.split(first, second, Qt.Orientation.Horizontal)

    layout.swap(first, second)

    assert layout.pane_widgets() == [second, first]


def test_swap_across_nested_splitters(qtbot):
    first = QLabel("first")
    second = QLabel("second")
    third = QLabel("third")
    layout = workspacesplit.SplitLayout(first)
    qtbot.addWidget(layout)
    layout.split(first, second, Qt.Orientation.Horizontal)
    layout.split(second, third, Qt.Orientation.Vertical)

    layout.swap(first, third)

    assert layout.pane_widgets() == [third, second, first]


def test_serialize_nested_split_tree(qtbot):
    first = QLabel("first")
    second = QLabel("second")
    third = QLabel("third")
    layout = workspacesplit.SplitLayout(first)
    qtbot.addWidget(layout)
    layout.split(first, second, Qt.Orientation.Horizontal)
    layout.split(second, third, Qt.Orientation.Vertical)

    state = layout.serialize(lambda widget: widget.text())

    assert state["type"] == "split"
    assert state["orientation"] == "horizontal"
    assert state["children"][0] == {"type": "pane", "value": "first"}
    assert state["children"][1]["orientation"] == "vertical"
    assert state["children"][1]["children"] == [
        {"type": "pane", "value": "second"},
        {"type": "pane", "value": "third"},
    ]
    assert len(state["sizes"]) == 2


def test_restore_split_tree(qtbot):
    primary = QLabel("primary")
    layout = workspacesplit.SplitLayout(primary)
    qtbot.addWidget(layout)
    state = {
        "type": "split",
        "orientation": "horizontal",
        "sizes": [300, 500],
        "children": [
            {"type": "pane", "value": "one"},
            {
                "type": "split",
                "orientation": "vertical",
                "sizes": [200, 600],
                "children": [
                    {"type": "pane", "value": "two"},
                    {"type": "pane", "value": "three"},
                ],
            },
        ],
    }

    created = layout.restore(state, lambda value: QLabel(value))

    assert [widget.text() for widget in layout.pane_widgets()] == [
        "one", "two", "three"
    ]
    assert [widget.text() for widget in created] == ["one", "two", "three"]
    assert layout.root.orientation() is Qt.Orientation.Horizontal
    nested = layout.root.widget(1)
    assert isinstance(nested, QSplitter)
    assert nested.orientation() is Qt.Orientation.Vertical
