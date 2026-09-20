# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for the native workspace terminal."""

import logging
from pathlib import Path
from types import SimpleNamespace

from qutebrowser.browser import conpty, terminalbackend, terminalcontent, workspaceterminal
from qutebrowser.qt.core import QEvent, Qt
from qutebrowser.qt.gui import QKeyEvent


class FakeBackend(terminalcontent.TerminalBackend):
    def start(self):
        pass

    def shutdown(self):
        pass

    def write(self, _data):
        pass

    def resize(self, _rows, _columns):
        pass


def test_sgr_style_is_stored_per_cell():
    screen = workspaceterminal.TerminalScreen(rows=2, columns=8)

    screen.feed("\x1b[1;31mR\x1b[0mN")

    red = screen.cell(0, 0)
    normal = screen.cell(0, 1)
    assert red.char == "R"
    assert red.style.foreground == 1
    assert red.style.bold
    assert normal.char == "N"
    assert normal.style == workspaceterminal.TerminalStyle()


def test_truecolor_and_256_color_sgr():
    screen = workspaceterminal.TerminalScreen(rows=1, columns=4)

    screen.feed("\x1b[38;2;1;2;3mT\x1b[48;5;196mB")

    assert screen.cell(0, 0).style.foreground == (1, 2, 3)
    assert screen.cell(0, 1).style.foreground == (1, 2, 3)
    assert screen.cell(0, 1).style.background == 196


def test_private_terminal_modes():
    screen = workspaceterminal.TerminalScreen()

    screen.feed("\x1b[?1h\x1b[?1002h\x1b[?1006h\x1b[?2004h")

    assert screen.application_cursor
    assert screen.mouse_mode == 1002
    assert screen.sgr_mouse
    assert screen.bracketed_paste

    screen.feed("\x1b[?1l\x1b[?1002l\x1b[?1006l\x1b[?2004l")
    assert not screen.application_cursor
    assert screen.mouse_mode == 0
    assert not screen.sgr_mouse
    assert not screen.bracketed_paste


def test_device_status_response():
    screen = workspaceterminal.TerminalScreen(rows=4, columns=8)
    screen.feed("\x1b[3;4H\x1b[6n")

    assert screen.take_responses() == b"\x1b[3;4R"


def test_alternate_screen_restores_main_screen():
    screen = workspaceterminal.TerminalScreen(rows=2, columns=8)
    screen.feed("main")

    screen.feed("\x1b[?1049halt")
    assert screen.lines()[0].startswith("alt")

    screen.feed("\x1b[?1049l")
    assert screen.lines()[0].startswith("main")


def test_plain_escape_requests_workspace_leave(qtbot):
    class EscapeBackend(terminalcontent.TerminalBackend):
        def __init__(self):
            super().__init__()
            self.writes = []

        def start(self):
            pass

        def shutdown(self):
            pass

        def write(self, data):
            self.writes.append(data)

        def resize(self, _rows, _columns):
            pass

    backend = EscapeBackend()
    view = workspaceterminal.TerminalView(backend)
    qtbot.addWidget(view)

    with qtbot.waitSignal(view.escape_requested):
        qtbot.keyClick(view, Qt.Key.Key_Escape)

    assert backend.writes == []


def test_terminal_input_transport_failure_does_not_escape_qt_event(qtbot, caplog):
    class FailingBackend(FakeBackend):
        def write(self, _data):
            raise OSError("ConPTY input failed")

    view = workspaceterminal.TerminalView(FailingBackend())
    qtbot.addWidget(view)
    event = QKeyEvent(
        QEvent.Type.KeyPress,
        Qt.Key.Key_A,
        Qt.KeyboardModifier.NoModifier,
        "a",
    )

    with caplog.at_level(logging.ERROR, logger="misc"):
        view.keyPressEvent(event)


def test_terminal_resize_transport_failure_does_not_escape_qt_event(qtbot, caplog):
    class FailingBackend(FakeBackend):
        def resize(self, _rows, _columns):
            raise OSError("ConPTY resize failed")

    view = workspaceterminal.TerminalView(FailingBackend())
    qtbot.addWidget(view)
    view.term_screen.resize(rows=1, columns=1)

    with caplog.at_level(logging.ERROR, logger="misc"):
        view.resize(640, 480)
        view.show()
        qtbot.wait(1)


def test_unix_backend_selection(monkeypatch, tmp_path):
    monkeypatch.setattr(
        workspaceterminal,
        "os",
        SimpleNamespace(name="posix"),
    )

    backend = workspaceterminal.create_backend(
        cwd=tmp_path,
        shell="/bin/sh",
    )

    assert isinstance(backend, terminalbackend.UnixPtyBackend)


def test_windows_backend_selection(monkeypatch, tmp_path):
    monkeypatch.setattr(
        workspaceterminal,
        "os",
        SimpleNamespace(name="nt"),
    )

    backend = workspaceterminal.create_backend(
        cwd=tmp_path,
        shell="cmd.exe",
    )

    assert isinstance(backend, conpty.WindowsConPtyBackend)


def test_terminal_session_state_keeps_cwd_and_shell(tmp_path, monkeypatch, qtbot):
    monkeypatch.setattr(
        workspaceterminal,
        "create_backend",
        lambda **_kwargs: FakeBackend(),
    )
    content = workspaceterminal.TerminalContent(tmp_path, shell="test-shell")
    qtbot.addWidget(content.widget)

    state = content.session_state()

    assert state.kind is workspaceterminal.workspace.ContentKind.TERMINAL
    assert state.state == {"cwd": str(tmp_path.resolve()), "shell": "test-shell"}


def test_terminal_defaults_to_home(tmp_path, monkeypatch, qtbot):
    monkeypatch.setattr(Path, "home", classmethod(lambda cls: tmp_path))
    monkeypatch.setattr(
        workspaceterminal,
        "create_backend",
        lambda **_kwargs: FakeBackend(),
    )

    content = workspaceterminal.TerminalContent(shell="test-shell")
    qtbot.addWidget(content.widget)

    assert content.cwd == tmp_path.resolve()
