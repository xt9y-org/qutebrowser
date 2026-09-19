# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Native filesystem-manager workspace content."""

from __future__ import annotations

from pathlib import Path

from qutebrowser.qt.core import pyqtSignal, QModelIndex
from qutebrowser.qt.gui import QFileSystemModel
from qutebrowser.qt.widgets import QWidget, QTreeView, QVBoxLayout

from qutebrowser.browser import workspace


class _FilesystemWidget(QWidget):
    """Qt widget backing a filesystem workspace tab."""

    file_activated = pyqtSignal(str)
    directory_changed = pyqtSignal(str)

    def __init__(self, parent=None):
        super().__init__(parent)
        self.model = QFileSystemModel(self)
        self.model.setRootPath("")

        self.tree = QTreeView(self)
        self.tree.setModel(self.model)
        self.tree.setUniformRowHeights(True)
        self.tree.setSortingEnabled(True)
        self.tree.doubleClicked.connect(self._on_activated)

        layout = QVBoxLayout(self)
        layout.setContentsMargins(0, 0, 0, 0)
        layout.addWidget(self.tree)

    def set_path(self, path: Path) -> None:
        index = self.model.setRootPath(str(path))
        self.tree.setRootIndex(index)
        self.directory_changed.emit(str(path))

    def _on_activated(self, index: QModelIndex) -> None:
        path = Path(self.model.filePath(index))
        if path.is_dir():
            self.set_path(path.resolve())
        else:
            self.file_activated.emit(str(path))


class FilesystemContent:
    """Workspace content adapter for a native filesystem tree."""

    kind = workspace.ContentKind.FILESYSTEM

    def __init__(self, path: str | Path | None = None, parent=None):
        self._widget = _FilesystemWidget(parent)
        self.tree = self._widget.tree
        self._path = Path.home().resolve()
        self.set_path(self._path if path is None else path)
        self._widget.directory_changed.connect(self._sync_path)

    @property
    def widget(self) -> QWidget:
        return self._widget

    @property
    def path(self) -> Path:
        return self._path

    def set_path(self, path: str | Path) -> None:
        resolved = Path(path).expanduser().resolve()
        if not resolved.is_dir():
            raise NotADirectoryError(str(resolved))
        self._path = resolved
        self._widget.set_path(resolved)

    def _sync_path(self, path: str) -> None:
        self._path = Path(path)

    def title(self) -> str:
        return "Files · {}".format(self._path)

    def focus(self) -> None:
        self.tree.setFocus()

    def session_state(self) -> workspace.ContentSession:
        return workspace.ContentSession(
            kind=self.kind,
            state={"path": str(self._path)},
        )
