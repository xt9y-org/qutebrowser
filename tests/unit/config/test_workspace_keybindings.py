# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Regression tests for workspace-mode keybindings."""

from qutebrowser.keyinput import keyutils


def test_passthrough_escape_leaves_mode(key_config_stub):
    escape = keyutils.KeySequence.parse("<Escape>")
    shifted_escape = keyutils.KeySequence.parse("<Shift-Escape>")

    assert key_config_stub.get_command(
        escape,
        "passthrough",
        default=True,
    ) == "mode-leave"
    assert key_config_stub.get_command(
        shifted_escape,
        "passthrough",
        default=True,
    ) is None
