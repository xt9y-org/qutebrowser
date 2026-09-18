# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Generic workspace content shared by browser, terminal and filesystem tabs."""

from __future__ import annotations

import argparse
import dataclasses
import enum
import pathlib
from typing import Protocol

from qutebrowser.api import cmdutils
from qutebrowser.qt.core import QModelIndex, QUrl, pyqtSignal
from qutebrowser.qt.gui import QFileSystemModel
from qutebrowser.qt.widgets import QTreeView, QVBoxLayout, QWidget


class ContentKind(enum.Enum):
    """The kind of content hosted by a qutebrowser workspace tab/pane."""

    BROWSER = "browser"
    TERMINAL = "terminal"
    FILESYSTEM = "filesystem"


@dataclasses.dataclass(frozen=True)
class ContentSession:
    """Serializable state owned by one workspace content instance."""

    kind: ContentKind
    state: dict[str, object] | None = None


class WorkspaceContent(Protocol):
    """Minimal contract implemented by every workspace content adapter."""

    kind: ContentKind

    @property
    def widget(self) -> QWidget:
        """Return the native Qt widget rendered for this content."""
        ...

    def title(self) -> str:
        """Return the title displayed by the containing tab/pane."""
        ...

    def focus(self) -> None:
        """Move keyboard focus into the content."""
        ...

    def session_state(self) -> ContentSession | None:
        """Return restorable state, or None when the content is ephemeral."""
        ...


class FilesystemContent(QWidget):
    """Native Qt filesystem manager content.

    This deliberately uses QFileSystemModel/QTreeView rather than rendering a
    file browser inside a web page. It is small for now, but already provides
    the native model needed for keyboard navigation and future workspace panes.
    """

    kind = ContentKind.FILESYSTEM

    path_changed = pyqtSignal(str)
    file_activated = pyqtSignal(QUrl)

    def __init__(
        self,
        path: str | pathlib.Path | None = None,
        parent: QWidget | None = None,
    ) -> None:
        super().__init__(parent)

        self.model = QFileSystemModel(self)
        self.view = QTreeView(self)
        self.view.setModel(self.model)
        self.view.doubleClicked.connect(self._activate_index)

        layout = QVBoxLayout(self)
        layout.setContentsMargins(0, 0, 0, 0)
        layout.addWidget(self.view)

        self._current_path = pathlib.Path()
        self.set_path(pathlib.Path.home() if path is None else path)

    @property
    def widget(self) -> QWidget:
        return self

    @property
    def current_path(self) -> pathlib.Path:
        return self._current_path

    def set_path(self, path: str | pathlib.Path) -> None:
        resolved = pathlib.Path(path).expanduser().resolve()
        if not resolved.is_dir():
            raise ValueError("Filesystem workspace path is not a directory: {}".format(resolved))

        root_path = str(resolved)
        self.model.setRootPath(root_path)
        self.view.setRootIndex(self.model.index(root_path))
        self._current_path = resolved
        self.path_changed.emit(root_path)

    def _activate_index(self, index: QModelIndex) -> None:
        path = pathlib.Path(self.model.filePath(index))
        if path.is_dir():
            self.set_path(path)
        else:
            self.file_activated.emit(QUrl.fromLocalFile(str(path)))

    def title(self) -> str:
        return str(self._current_path)

    def focus(self) -> None:
        self.view.setFocus()

    def session_state(self) -> ContentSession:
        return ContentSession(
            ContentKind.FILESYSTEM,
            {"path": str(self._current_path)},
        )


_SELECTOR_DEST = "workspace_application"
_SELECTOR_FLAGS = (
    ("-at", "--application-terminal", ContentKind.TERMINAL),
    ("-ab", "--application-browser", ContentKind.BROWSER),
    ("-af", "--application-filesystem", ContentKind.FILESYSTEM),
)


class _ApplicationSelectorAction(argparse.Action):
    """Store one application selector while rejecting conflicting selectors."""

    def __init__(self, option_strings, dest, *, content_kind, **kwargs):
        self._content_kind = content_kind
        super().__init__(option_strings, dest, nargs=0, **kwargs)

    def __call__(self, parser, namespace, _values, option_string=None):
        previous = getattr(namespace, self.dest, None)
        if previous is not None and previous is not self._content_kind:
            parser.error("Only one of -at/-ab/-af can be given!")
        setattr(namespace, self.dest, self._content_kind)


def add_application_selector_arguments(parser: argparse.ArgumentParser) -> None:
    """Add -at/-ab/-af selectors to a command parser."""
    parser.set_defaults(**{_SELECTOR_DEST: None})
    for short_flag, long_flag, content_kind in _SELECTOR_FLAGS:
        parser.add_argument(
            short_flag,
            long_flag,
            dest=_SELECTOR_DEST,
            action=_ApplicationSelectorAction,
            content_kind=content_kind,
            help="Open {} workspace content.".format(content_kind.value),
        )


def selected_content_kind(namespace: argparse.Namespace) -> ContentKind:
    """Return the application selected in a parsed command namespace."""
    selected = getattr(namespace, _SELECTOR_DEST, None)
    if selected is None:
        return ContentKind.BROWSER
    return selected


def resolve_content_kind(
    *,
    application_terminal: bool = False,
    application_browser: bool = False,
    application_filesystem: bool = False,
) -> ContentKind:
    """Resolve application selector booleans to a workspace content kind.

    Browser content remains the default when no selector is supplied.
    """
    cmdutils.check_exclusive(
        (application_terminal, application_browser, application_filesystem),
        ("at", "ab", "af"),
    )

    if application_terminal:
        return ContentKind.TERMINAL
    if application_filesystem:
        return ContentKind.FILESYSTEM
    return ContentKind.BROWSER
