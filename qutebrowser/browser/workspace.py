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
