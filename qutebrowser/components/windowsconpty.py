# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Install the native Windows ConPTY terminal transport."""

import os

from qutebrowser.browser import conpty, terminalcontent


if os.name == "nt":
    terminalcontent.WindowsConPtyBackend = conpty.WindowsConPtyBackend
