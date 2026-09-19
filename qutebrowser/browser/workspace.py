# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Generic workspace content shared by browser, terminal and filesystem tabs."""

from __future__ import annotations

import dataclasses
import enum
from typing import TYPE_CHECKING, Protocol

from qutebrowser.api import cmdutils

if TYPE_CHECKING:
    from qutebrowser.qt.widgets import QWidget


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
        """Return the Qt widget rendered for this content."""
        ...

    def title(self) -> str:
        """Return the title displayed by the containing tab/pane."""
        ...

    def focus(self) -> None:
        """Move keyboard focus into the content."""
        ...

    def session_state(self) -> ContentSession | None:
        """Return adapter-owned restorable state, if any."""
        ...


class BrowserContentAdapter:
    """Expose an existing qutebrowser web tab through WorkspaceContent.

    Browser history/session state remains owned by qutebrowser's existing
    browser session machinery; this adapter only normalizes the content-facing
    interface used by panes and workspace code.
    """

    kind = ContentKind.BROWSER

    def __init__(self, tab: QWidget) -> None:
        self._tab = tab

    @property
    def widget(self) -> QWidget:
        return self._tab

    def title(self) -> str:
        return self._tab.title()

    def focus(self) -> None:
        self._tab.setFocus()

    def session_state(self) -> None:
        return None


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
