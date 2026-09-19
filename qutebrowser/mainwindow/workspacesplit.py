# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Nested split layout for qutebrowser workspace panes."""

from __future__ import annotations

from collections.abc import Callable
from typing import Any

from qutebrowser.qt.core import Qt
from qutebrowser.qt.widgets import QSplitter, QVBoxLayout, QWidget


_ORIENTATION_NAMES = {
    Qt.Orientation.Horizontal: "horizontal",
    Qt.Orientation.Vertical: "vertical",
}
_NAME_ORIENTATIONS = {value: key for key, value in _ORIENTATION_NAMES.items()}


class SplitLayout(QWidget):
    """A recursively nestable splitter tree with QWidget leaves."""

    def __init__(self, primary: QWidget, parent: QWidget | None = None) -> None:
        super().__init__(parent)
        self.root = self._new_splitter(Qt.Orientation.Horizontal, self)
        self.root.addWidget(primary)

        layout = QVBoxLayout(self)
        layout.setContentsMargins(0, 0, 0, 0)
        layout.setSpacing(0)
        layout.addWidget(self.root)

    @staticmethod
    def _new_splitter(
        orientation: Qt.Orientation,
        parent: QWidget | None = None,
    ) -> QSplitter:
        splitter = QSplitter(orientation, parent)
        splitter.setChildrenCollapsible(False)
        return splitter

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

        # Keep the new splitter detached until replaceWidget() adopts it. Giving
        # it ``parent`` here makes it an existing sibling, which Qt refuses to
        # use as a replacement.
        nested = self._new_splitter(orientation)
        replaced = parent.replaceWidget(current_index, nested)
        if replaced is None:
            nested.deleteLater()
            raise RuntimeError("Could not replace split pane")
        nested.addWidget(replaced)
        nested.addWidget(new_pane)

    def close(self, pane: QWidget | None = None) -> bool:
        """Close this widget, or remove ``pane`` when one is supplied.

        QWidget teardown calls ``close()`` without arguments, so keep that
        contract intact while retaining the pane-closing API used by the
        workspace manager.
        """
        if pane is None:
            return super().close()
        return self.close_pane(pane)

    def close_pane(self, pane: QWidget) -> bool:
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
            if remaining is None:
                raise RuntimeError("Nested splitter has no remaining pane")
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
        replaced_first = first_parent.replaceWidget(first_index, first_placeholder)
        replaced_second = second_parent.replaceWidget(second_index, second_placeholder)
        if replaced_first is not first or replaced_second is not second:
            raise RuntimeError("Could not detach panes for movement")

        first_parent.replaceWidget(first_index, second)
        second_parent.replaceWidget(second_index, first)
        first_placeholder.deleteLater()
        second_placeholder.deleteLater()

    def serialize(self, leaf_serializer: Callable[[QWidget], Any]) -> dict[str, Any]:
        """Serialize splitter topology, sizes, and leaves."""
        def encode(widget: QWidget) -> dict[str, Any]:
            if not isinstance(widget, QSplitter):
                return {"type": "pane", "value": leaf_serializer(widget)}

            children: list[dict[str, Any]] = []
            for index in range(widget.count()):
                child = widget.widget(index)
                if child is not None:
                    children.append(encode(child))
            return {
                "type": "split",
                "orientation": _ORIENTATION_NAMES[widget.orientation()],
                "sizes": list(widget.sizes()),
                "children": children,
            }

        return encode(self.root)

    def restore(
        self,
        state: dict[str, Any],
        leaf_factory: Callable[[Any], QWidget],
    ) -> list[QWidget]:
        """Replace the layout tree from serialized state and return leaves."""
        created: list[QWidget] = []

        def build(node: dict[str, Any], parent: QWidget | None = None) -> QWidget:
            node_type = node.get("type")
            if node_type == "pane":
                leaf = leaf_factory(node.get("value"))
                created.append(leaf)
                return leaf
            if node_type != "split":
                raise ValueError("Invalid split session node")

            try:
                orientation = _NAME_ORIENTATIONS[node["orientation"]]
            except (KeyError, TypeError) as error:
                raise ValueError("Invalid split orientation") from error

            splitter = self._new_splitter(orientation, parent)
            children = node.get("children", [])
            if not children:
                raise ValueError("Split session node has no children")
            for child_state in children:
                splitter.addWidget(build(child_state, splitter))
            sizes = node.get("sizes")
            if isinstance(sizes, list) and len(sizes) == splitter.count():
                splitter.setSizes([max(0, int(size)) for size in sizes])
            return splitter

        replacement = build(state, self)
        if not isinstance(replacement, QSplitter):
            wrapper = self._new_splitter(Qt.Orientation.Horizontal, self)
            wrapper.addWidget(replacement)
            replacement = wrapper

        layout = self.layout()
        assert layout is not None
        old_root = self.root
        layout.replaceWidget(old_root, replacement)
        self.root = replacement
        old_root.setParent(None)
        old_root.deleteLater()
        return created
