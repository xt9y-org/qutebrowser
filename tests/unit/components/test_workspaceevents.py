# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for workspace-content event routing."""

from pathlib import Path

from qutebrowser.qt.core import QUrl
from qutebrowser.components import workspaceevents


class FakeTabWidget:
    def __init__(self):
        self.title = None

    def indexOf(self, _tab):
        return 2

    def set_page_title(self, index, title):
        self.title = (index, title)


class FakeBrowser:
    def __init__(self):
        self.widget = FakeTabWidget()
        self.window_title_updates = 0
        self.opened = None

    def _update_window_title(self):
        self.window_title_updates += 1

    def tabopen(self, url, background=False, related=False):
        self.opened = (url, background, related)


class FakeTab:
    def title(self):
        return "Files · /tmp/child"


def test_refresh_title_updates_tab_and_window():
    browser = FakeBrowser()

    workspaceevents.refresh_title(browser, FakeTab())

    assert browser.widget.title == (2, "Files · /tmp/child")
    assert browser.window_title_updates == 1


def test_open_file_uses_local_file_url(tmp_path):
    browser = FakeBrowser()
    path = tmp_path / "page.html"
    path.write_text("<p>test</p>", encoding="utf-8")

    workspaceevents.open_file(browser, str(path))

    url, background, related = browser.opened
    assert url == QUrl.fromLocalFile(str(Path(path).resolve()))
    assert not background
    assert related
