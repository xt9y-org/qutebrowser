# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for workspace pane command integration."""

from qutebrowser.components import workspacepanes  # noqa: F401
from qutebrowser.misc import objects


def test_legacy_workspace_split_is_not_registered():
    assert "workspace-split" not in objects.commands
