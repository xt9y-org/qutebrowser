# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for qutebrowser.browser.workspace."""

import dataclasses

import pytest

from qutebrowser.api import cmdutils
from qutebrowser.browser import workspace


@pytest.mark.parametrize(
    ("kwargs", "expected"),
    [
        ({}, workspace.ContentKind.BROWSER),
        ({"application_browser": True}, workspace.ContentKind.BROWSER),
        ({"application_terminal": True}, workspace.ContentKind.TERMINAL),
        ({"application_filesystem": True}, workspace.ContentKind.FILESYSTEM),
    ],
)
def test_resolve_content_kind(kwargs, expected):
    assert workspace.resolve_content_kind(**kwargs) is expected


@pytest.mark.parametrize(
    "kwargs",
    [
        {"application_terminal": True, "application_browser": True},
        {"application_terminal": True, "application_filesystem": True},
        {"application_browser": True, "application_filesystem": True},
        {
            "application_terminal": True,
            "application_browser": True,
            "application_filesystem": True,
        },
    ],
)
def test_resolve_content_kind_rejects_conflicts(kwargs):
    with pytest.raises(
        cmdutils.CommandError,
        match=r"Only one of -at/-ab/-af can be given!",
    ):
        workspace.resolve_content_kind(**kwargs)


def test_content_session_is_immutable():
    session = workspace.ContentSession(
        workspace.ContentKind.FILESYSTEM,
        {"path": "/tmp"},
    )

    with pytest.raises(dataclasses.FrozenInstanceError):
        session.kind = workspace.ContentKind.BROWSER
