# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for the Windows ConPTY terminal backend."""

from qutebrowser.browser import conpty, terminalcontent


def test_conpty_backend_matches_terminal_transport(tmp_path):
    backend = conpty.WindowsConPtyBackend(
        cwd=tmp_path,
        shell="cmd.exe",
    )

    assert isinstance(backend, terminalcontent.TerminalBackend)
    assert backend.cwd == tmp_path
    assert backend.shell == "cmd.exe"


def test_conpty_coord_uses_columns_then_rows():
    coord = conpty._coord(rows=24, columns=80)

    assert coord.X == 80
    assert coord.Y == 24
