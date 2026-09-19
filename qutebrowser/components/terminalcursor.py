# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Render the native terminal's VT cursor at the correct grid cell."""

from qutebrowser.browser import terminalcontent


_installed = False


def install() -> None:
    global _installed
    if _installed:
        return
    _installed = True

    original_render = terminalcontent.TerminalView._render

    def render(view):
        original_render(view)
        row, column = view.screen.cursor
        position = row * (view.screen.columns + 1) + column
        cursor = view.textCursor()
        cursor.setPosition(min(position, len(view.toPlainText())))
        view.setTextCursor(cursor)

    terminalcontent.TerminalView._render = render


install()
