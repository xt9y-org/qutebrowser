# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Create and serialize native workspace content."""

from __future__ import annotations

from typing import Any

from qutebrowser.browser import filesystemcontent, workspace, workspaceterminal


def serialize_content(content: workspace.WorkspaceContent) -> dict[str, Any]:
    """Serialize one native workspace content adapter."""
    state = content.session_state()
    if state is None:
        raise ValueError("Workspace content is not session-serializable")
    return {
        "kind": state.kind.value,
        "state": dict(state.state or {}),
    }


def create_content(data: dict[str, Any]) -> workspace.WorkspaceContent:
    """Restore a native workspace content adapter from session data."""
    try:
        kind = workspace.ContentKind(data["kind"])
    except (KeyError, ValueError, TypeError) as error:
        raise ValueError("Invalid workspace content kind") from error

    state = data.get("state", {})
    if not isinstance(state, dict):
        raise ValueError("Invalid workspace content state")

    if kind is workspace.ContentKind.FILESYSTEM:
        return filesystemcontent.FilesystemContent(state.get("path"))
    if kind is workspace.ContentKind.TERMINAL:
        return workspaceterminal.TerminalContent(
            cwd=state.get("cwd"),
            shell=state.get("shell"),
        )
    raise ValueError("Browser content is restored by the browser session loader")
