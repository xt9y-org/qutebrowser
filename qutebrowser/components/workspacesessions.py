# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Persist mixed browser/filesystem/terminal workspace layouts in sessions."""

from __future__ import annotations

from collections.abc import Iterable
from typing import Any

from qutebrowser.qt.core import QTimer

from qutebrowser.misc import objects, sessions
from qutebrowser.qt import sip
from qutebrowser.utils import objreg


_installed = False


def _window_data(
    manager: sessions.SessionManager,
    *,
    win_id: str | int,
    with_history: bool,
) -> dict[str, Any] | None:
    """Serialize one window, using workspace state when it is needed."""
    main_window = objreg.get(
        "main-window",
        scope="window",
        window=win_id,
    )
    if sip.isdeleted(main_window):
        return None

    pane_manager = getattr(main_window, "_workspace_pane_manager", None)
    primary = main_window.tabbed_browser
    if primary.is_private:
        private = True
    else:
        private = False

    data: dict[str, Any] = {
        "geometry": bytes(main_window.saveGeometry()),
    }
    active_window = objects.qapp.activeWindow()
    if getattr(active_window, "win_id", None) == win_id:
        data["active"] = True
    if private:
        data["private"] = True

    if pane_manager is not None and pane_manager.has_workspace_state():
        data["workspace"] = pane_manager.session_state(
            lambda tab, active: manager._save_tab(
                tab,
                active,
                with_history=with_history,
            )
        )
        return data

    data["tabs"] = []
    for index, tab in enumerate(primary.widgets()):
        active = index == primary.widget.currentIndex()
        data["tabs"].append(
            manager._save_tab(tab, active, with_history=with_history)
        )
    return data


def _save_all(
    manager: sessions.SessionManager,
    *,
    only_window=None,
    with_private=False,
    with_history=True,
):
    """Workspace-aware equivalent of SessionManager._save_all."""
    data: dict[str, Any] = {"windows": []}
    if only_window is not None:
        winlist: Iterable[str | int] = [only_window]
    else:
        winlist = objreg.window_registry

    for win_id in sorted(winlist):
        main_window = objreg.get(
            "main-window",
            scope="window",
            window=win_id,
        )
        if sip.isdeleted(main_window):
            continue
        if main_window.tabbed_browser.is_private and not with_private:
            continue
        window_data = _window_data(
            manager,
            win_id=win_id,
            with_history=with_history,
        )
        if window_data is not None:
            data["windows"].append(window_data)
    return data


def _load_workspace_window(
    manager: sessions.SessionManager,
    data: dict[str, Any],
):
    """Restore a window containing native tabs and/or split panes."""
    from qutebrowser.mainwindow import mainwindow

    window = mainwindow.MainWindow(
        geometry=data["geometry"],
        private=data.get("private", None),
    )
    pane_manager = getattr(window, "_workspace_pane_manager", None)
    if pane_manager is None:
        raise sessions.SessionError("Workspace pane manager is unavailable")

    try:
        pane_manager.restore_session(data["workspace"], manager._load_tab)
    except (KeyError, TypeError, ValueError, OSError, RuntimeError) as error:
        window.close()
        raise sessions.SessionError(
            "Could not restore workspace session: {}".format(error)
        ) from error

    window.show()
    if data.get("active", False):
        QTimer.singleShot(0, pane_manager.active.widget.activateWindow)
    return window


def install() -> None:
    """Install workspace-aware session save/load while preserving stock data."""
    global _installed
    if _installed:
        return
    _installed = True

    original_load_window = sessions.SessionManager._load_window

    def save_all(
        manager,
        *,
        only_window=None,
        with_private=False,
        with_history=True,
    ):
        return _save_all(
            manager,
            only_window=only_window,
            with_private=with_private,
            with_history=with_history,
        )

    def load_window(manager, data):
        if "workspace" not in data:
            return original_load_window(manager, data)
        return _load_workspace_window(manager, data)

    sessions.SessionManager._save_all = save_all
    sessions.SessionManager._load_window = load_window


install()
