# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for workspace-specific command flag support."""

import pytest

from qutebrowser.api import cmdutils
from qutebrowser.misc import objects


@pytest.fixture(autouse=True)
def clear_commands(monkeypatch):
    monkeypatch.setattr(objects, "commands", {})


def test_multi_character_short_flag():
    @cmdutils.register()
    @cmdutils.argument("application_terminal", flag="at")
    def command(application_terminal=False):
        """Test command."""

    cmd = objects.commands["command"]
    cmd.namespace = cmd.parser.parse_args(["-at"])

    assert cmd.namespace.application_terminal is True
    assert cmd.opt_args["application_terminal"] == (
        "--application-terminal",
        "-at",
    )
