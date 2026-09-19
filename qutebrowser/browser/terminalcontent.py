# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Compatibility exports for the native workspace terminal.

The implementation is split cleanly across terminalbackend (process transport),
workspacevt (terminal emulation), and workspaceterminal (Qt view/content).
"""

from qutebrowser.browser.terminalbackend import TerminalBackend, UnixPtyBackend
from qutebrowser.browser.workspaceterminal import (
    TerminalCell,
    TerminalContent,
    TerminalScreen,
    TerminalStyle,
    TerminalView,
    create_backend,
    default_shell,
)

__all__ = [
    "TerminalBackend",
    "UnixPtyBackend",
    "TerminalCell",
    "TerminalContent",
    "TerminalScreen",
    "TerminalStyle",
    "TerminalView",
    "create_backend",
    "default_shell",
]
