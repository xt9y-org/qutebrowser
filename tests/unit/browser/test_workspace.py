# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for qutebrowser.browser.workspace."""

import dataclasses

import pytest

from qutebrowser.browser import workspace


def test_browser_content_adapter_delegates_to_web_tab():
    class FakeTab:
        def __init__(self):
            self.focused = False

        def title(self):
            return "Browser title"

        def setFocus(self):
            self.focused = True

    tab = FakeTab()
    adapter = workspace.BrowserContentAdapter(tab)

    assert adapter.kind is workspace.ContentKind.BROWSER
    assert adapter.widget is tab
    assert adapter.title() == "Browser title"
    assert adapter.session_state() is None

    adapter.focus()
    assert tab.focused


def test_content_session_is_immutable():
    session = workspace.ContentSession(
        workspace.ContentKind.FILESYSTEM,
        {"path": "/tmp"},
    )

    with pytest.raises(dataclasses.FrozenInstanceError):
        session.kind = workspace.ContentKind.BROWSER
