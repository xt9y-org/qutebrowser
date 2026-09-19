# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for native terminal workspace content."""

from qutebrowser.browser import terminalcontent
from qutebrowser.components import terminalcursor  # noqa: F401


class FakeBackend(terminalcontent.TerminalBackend):
    def start(self):
        pass

    def write(self, data):
        pass

    def resize(self, rows, columns):
        pass

    def shutdown(self):
        pass


def test_terminal_screen_writes_text():
    screen = terminalcontent.TerminalScreen(rows=3, columns=8)

    screen.feed("hello")

    assert screen.lines()[0] == "hello   "
    assert screen.cursor == (0, 5)


def test_terminal_screen_newline_and_scroll():
    screen = terminalcontent.TerminalScreen(rows=2, columns=5)

    screen.feed("one\r\ntwo\r\nthree")

    assert screen.lines() == ["two  ", "three"]


def test_terminal_screen_cursor_addressing():
    screen = terminalcontent.TerminalScreen(rows=3, columns=6)

    screen.feed("abc\x1b[2;3HZ")

    assert screen.lines()[0] == "abc   "
    assert screen.lines()[1] == "  Z   "
    assert screen.cursor == (1, 3)


def test_terminal_screen_erase_display():
    screen = terminalcontent.TerminalScreen(rows=2, columns=4)
    screen.feed("abcd\r\nefgh")

    screen.feed("\x1b[2J")

    assert screen.lines() == ["    ", "    "]


def test_terminal_screen_backspace_and_carriage_return():
    screen = terminalcontent.TerminalScreen(rows=2, columns=6)

    screen.feed("abc\bZ\rQ")

    assert screen.lines()[0] == "QbZ   "


def test_terminal_screen_save_restore_cursor():
    screen = terminalcontent.TerminalScreen(rows=3, columns=5)

    screen.feed("a\x1b[s\x1b[3;5HX\x1b[uZ")

    assert screen.lines()[0] == "aZ   "
    assert screen.lines()[2] == "    X"


def test_terminal_screen_resizes_preserving_content():
    screen = terminalcontent.TerminalScreen(rows=2, columns=4)
    screen.feed("abcd")

    screen.resize(rows=3, columns=6)

    assert screen.lines()[0] == "abcd  "
    assert len(screen.lines()) == 3


def test_terminal_view_tracks_terminal_cursor(qtbot):
    backend = FakeBackend()
    view = terminalcontent.TerminalView(backend)
    qtbot.addWidget(view)
    view.screen.resize(rows=3, columns=8)

    view._on_data(b"abc\x1b[2;4HZ")

    row, column = view.screen.cursor
    expected = row * (view.screen.columns + 1) + column
    assert view.textCursor().position() == expected


def test_terminal_content_kind():
    assert terminalcontent.TerminalContent.kind.value == "terminal"
