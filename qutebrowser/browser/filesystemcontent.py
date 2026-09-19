# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Native filesystem-manager workspace content."""

from __future__ import annotations

import os
from pathlib import Path

from qutebrowser.qt.core import Qt, pyqtSignal, QModelIndex, QStorageInfo
from qutebrowser.qt.gui import QFileSystemModel
from qutebrowser.qt.widgets import QWidget, QTreeView, QVBoxLayout

from qutebrowser.browser import workspace


def _mounted_root_paths() -> list[Path]:
    """Return ready mounted filesystem roots using Qt's platform abstraction."""
    roots: list[Path] = []
    for storage in QStorageInfo.mountedVolumes():
        if not storage.isValid() or not storage.isReady():
            continue
        root = storage.rootPath()
        if root:
            roots.append(Path(root))
    return roots


def filesystem_roots() -> list[Path]:
    """Return mounted roots/drives in stable order without duplicates."""
    roots: list[Path] = []
    seen: set[str] = set()
    for path in _mounted_root_paths():
        normalized = path.expanduser().absolute()
        key = os.path.normcase(str(normalized))
        if key in seen:
            continue
        seen.add(key)
        roots.append(normalized)
    return roots


class _FilesystemTree(QTreeView):
    """Keyboard-first filesystem tree."""

    parent_requested = pyqtSignal()
    root_requested = pyqtSignal()
    activate_requested = pyqtSignal(QModelIndex)

    def keyPressEvent(self, event) -> None:  # noqa: N802 - Qt API
        if event.key() in {Qt.Key.Key_Return, Qt.Key.Key_Enter}:
            index = self.currentIndex()
            if index.isValid():
                self.activate_requested.emit(index)
            return
        if event.key() == Qt.Key.Key_Backspace:
            self.parent_requested.emit()
            return
        if event.key() == Qt.Key.Key_Home and (
            event.modifiers() & Qt.KeyboardModifier.ControlModifier
        ):
            self.root_requested.emit()
            return
        super().keyPressEvent(event)


class _FilesystemWidget(QWidget):
    """Qt widget backing a filesystem workspace tab."""

    file_activated = pyqtSignal(str)
    directory_changed = pyqtSignal(str)
    parent_requested = pyqtSignal()
    root_requested = pyqtSignal()

    def __init__(self, parent=None):
        super().__init__(parent)
        self.model = QFileSystemModel(self)
        self.model.setRootPath("")

        self.tree = _FilesystemTree(self)
        self.tree.setModel(self.model)
        self.tree.setUniformRowHeights(True)
        self.tree.setSortingEnabled(True)
        self.tree.doubleClicked.connect(self._on_activated)
        self.tree.activate_requested.connect(self._on_activated)
        self.tree.parent_requested.connect(self.parent_requested)
        self.tree.root_requested.connect(self.root_requested)

        layout = QVBoxLayout(self)
        layout.setContentsMargins(0, 0, 0, 0)
        layout.addWidget(self.tree)

    def set_path(self, path: Path) -> None:
        index = self.model.setRootPath(str(path))
        self.tree.setRootIndex(index)
        self.directory_changed.emit(str(path))

    def _on_activated(self, index: QModelIndex) -> None:
        path = Path(self.model.filePath(index)).expanduser().absolute()
        if path.is_dir():
            self.set_path(path)
        else:
            self.file_activated.emit(str(path))


class FilesystemContent:
    """Workspace content adapter for a native filesystem tree."""

    kind = workspace.ContentKind.FILESYSTEM

    def __init__(self, path: str | Path | None = None, parent=None):
        self._widget = _FilesystemWidget(parent)
        self.tree = self._widget.tree
        self._path = Path.home().absolute()
        self._widget.directory_changed.connect(self._sync_path)
        self._widget.parent_requested.connect(self.go_parent)
        self._widget.root_requested.connect(self.go_root)
        self.set_path(self._path if path is None else path)

    @property
    def widget(self) -> QWidget:
        return self._widget

    @property
    def path(self) -> Path:
        return self._path

    @property
    def roots(self) -> list[Path]:
        return filesystem_roots()

    def set_path(self, path: str | Path) -> None:
        visible_path = Path(path).expanduser().absolute()
        if not visible_path.is_dir():
            raise NotADirectoryError(str(visible_path))
        if not os.access(visible_path, os.R_OK | os.X_OK):
            raise PermissionError(str(visible_path))
        self._path = visible_path
        self._widget.set_path(visible_path)

    def _sync_path(self, path: str) -> None:
        self._path = Path(path).expanduser().absolute()

    def go_parent(self) -> None:
        parent = self._path.parent
        if parent != self._path:
            self.set_path(parent)

    def go_root(self) -> None:
        roots = self.roots
        if not roots:
            return
        current = os.path.normcase(str(self._path))
        containing = [
            root
            for root in roots
            if current == os.path.normcase(str(root))
            or current.startswith(os.path.normcase(str(root)) + os.sep)
        ]
        if containing:
            self.set_path(max(containing, key=lambda path: len(str(path))))
        else:
            self.set_path(roots[0])

    def title(self) -> str:
        return "Files · {}".format(self._path)

    def focus(self) -> None:
        self.tree.setFocus()

    def session_state(self) -> workspace.ContentSession:
        return workspace.ContentSession(
            kind=self.kind,
            state={"path": str(self._path)},
        )
