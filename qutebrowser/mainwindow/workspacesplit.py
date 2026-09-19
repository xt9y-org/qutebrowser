# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Nested split layout for qutebrowser workspace panes."""

from __future__ import annotations

from qutebrowser.qt.core import Qt
from qutebrowser.qt.widgets import QSplitter, QVBoxLayout, QWidget


class SplitLayout(QWidget):
    """A recursively nestable splitter tree with QWidget leaves."""

    def __init__(self, primary: QWidget, parent: QWidget | None = None) -> None:
        super().__init__(parent)
        self.root = QSplitter(Qt.Orientation.Horizontal, self)
        self.root.setChildrenCollapsible(False)
        self.root.addWidget(primary)

        layout = QVBoxLayout(self)
        layout.setContentsMargins(0, 0, 0, 0)
        layout.setSpacing(0)
        layout.addWidget(self.root)

    def pane_widgets(self) -> list[QWidget]:
        """Return pane leaves in visual tree order."""
        result: list[QWidget] = []

        def walk(widget: QWidget) -> None:
            if isinstance(widget, QSplitter):
                for index in range(widget.count()):
                    child = widget.widget(index)
                    if child is not None:
                        walk(child)
            else:
                result.append(widget)

        walk(self.root)
        return result

    def split(
        self,
        current: QWidget,
        new_pane: QWidget,
        orientation: Qt.Orientation,
    ) -> None:
        """Insert ``new_pane`` directly after ``current``."""
        parent = current.parentWidget()
        if not isinstance(parent, QSplitter):
            raise ValueError("Current pane is not attached to a splitter")

        current_index = parent.indexOf(current)
        if current_index < 0:
            raise ValueError("Current pane is not contained in its splitter")

        if parent.count() == 1:
            parent.setOrientation(orientation)
            parent.addWidget(new_pane)
            return

        if parent.orientation() == orientation:
            parent.insertWidget(current_index + 1, new_pane)
            return

        nested = QSplitter(orientation, parent)
        nested.setChildrenCollapsible(False)
        replaced = parent.replaceWidget(current_index, nested)
        if replaced is None:
            raise RuntimeError("Could not replace split pane")
        nested.addWidget(replaced)
        nested.addWidget(new_pane)

    def close(self, pane: QWidget) -> bool:
        """Remove a pane and collapse redundant nested splitters.

        Returns False when ``pane`` is the final remaining leaf.
        """
        if len(self.pane_widgets()) <= 1:
            return False

        parent = pane.parentWidget()
        if not isinstance(parent, QSplitter):
            raise ValueError("Pane is not attached to a splitter")

        pane.setParent(None)

        if parent is not self.root and parent.count() == 1:
            remaining = parent.widget(0)
            grandparent = parent.parentWidget()
            if not isinstance(grandparent, QSplitter):
                raise RuntimeError("Nested splitter has no splitter parent")
            index = grandparent.indexOf(parent)
            replaced = grandparent.replaceWidget(index, remaining)
            if replaced is not None:
                replaced.deleteLater()

        return True

    def swap(self, first: QWidget, second: QWidget) -> None:
        """Swap two pane leaves without changing the splitter tree."""
        if first is second:
            return

        first_parent = first.parentWidget()
        second_parent = second.parentWidget()
        if not isinstance(first_parent, QSplitter):
            raise ValueError("First pane is not attached to a splitter")
        if not isinstance(second_parent, QSplitter):
            raise ValueError("Second pane is not attached to a splitter")

        first_index = first_parent.indexOf(first)
        second_index = second_parent.indexOf(second)
        if first_index < 0 or second_index < 0:
            raise ValueError("Pane is not contained in its splitter")

        first_placeholder = QWidget()
        second_placeholder = QWidget()
        replaced_first = first_parent.replaceWidget(
            first_index,
            first_placeholder,
        )
        replaced_second = second_parent.replaceWidget(
            second_index,
            second_placeholder,
        )
        if replaced_first is not first or replaced_second is not second:
            raise RuntimeError("Could not detach panes for movement")

        first_parent.replaceWidget(first_index, second)
        second_parent.replaceWidget(second_index, first)
        first_placeholder.deleteLater()
        second_placeholder.deleteLater()
