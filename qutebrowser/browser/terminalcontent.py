# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Native terminal workspace content and PTY-backed terminal surface."""

from __future__ import annotations

import codecs
import os
import signal
import struct
import subprocess
from pathlib import Path

from qutebrowser.qt.core import QObject, QSocketNotifier, QTimer, Qt, pyqtSignal
from qutebrowser.qt.gui import QFontDatabase
from qutebrowser.qt.widgets import QApplication, QPlainTextEdit, QWidget

from qutebrowser.browser import workspace


class TerminalScreen:
    """Small VT-style character grid suitable for shells and TUIs."""

    def __init__(self, *, rows: int = 24, columns: int = 80) -> None:
        self.rows = max(1, rows)
        self.columns = max(1, columns)
        self._grid = self._blank_grid()
        self._row = 0
        self._column = 0
        self._saved_cursor = (0, 0)
        self._state = "normal"
        self._sequence = ""
        self._wrap_pending = False
        self._scroll_top = 0
        self._scroll_bottom = self.rows - 1
        self._main_state = None

    @property
    def cursor(self) -> tuple[int, int]:
        return self._row, self._column

    def _blank_line(self) -> list[str]:
        return [" "] * self.columns

    def _blank_grid(self) -> list[list[str]]:
        return [[" "] * self.columns for _ in range(self.rows)]

    def lines(self) -> list[str]:
        return ["".join(line) for line in self._grid]

    def resize(self, *, rows: int, columns: int) -> None:
        rows = max(1, rows)
        columns = max(1, columns)
        new_grid = [[" "] * columns for _ in range(rows)]
        for row in range(min(rows, self.rows)):
            for column in range(min(columns, self.columns)):
                new_grid[row][column] = self._grid[row][column]
        self.rows = rows
        self.columns = columns
        self._grid = new_grid
        self._row = min(self._row, rows - 1)
        self._column = min(self._column, columns - 1)
        self._scroll_top = 0
        self._scroll_bottom = rows - 1
        self._wrap_pending = False

    def feed(self, text: str) -> None:
        for char in text:
            self._feed_char(char)

    def _feed_char(self, char: str) -> None:
        if self._state == "osc":
            if char == "\a":
                self._state = "normal"
            elif char == "\x1b":
                self._state = "osc-escape"
            return
        if self._state == "osc-escape":
            self._state = "normal" if char == "\\" else "osc"
            return
        if self._state == "charset":
            self._state = "normal"
            return
        if self._state == "csi":
            if "@" <= char <= "~":
                self._dispatch_csi(self._sequence, char)
                self._sequence = ""
                self._state = "normal"
            else:
                self._sequence += char
            return
        if self._state == "escape":
            self._dispatch_escape(char)
            return

        if char == "\x1b":
            self._state = "escape"
        elif char == "\r":
            self._column = 0
            self._wrap_pending = False
        elif char == "\n":
            self._linefeed()
        elif char == "\b":
            self._column = max(0, self._column - 1)
            self._wrap_pending = False
        elif char == "\t":
            next_stop = min(self.columns - 1, ((self._column // 8) + 1) * 8)
            self._column = next_stop
            self._wrap_pending = False
        elif char in {"\x00", "\x07"}:
            return
        elif ord(char) < 32:
            return
        else:
            self._put(char)

    def _put(self, char: str) -> None:
        if self._wrap_pending:
            self._column = 0
            self._linefeed()
            self._wrap_pending = False
        self._grid[self._row][self._column] = char
        if self._column == self.columns - 1:
            self._wrap_pending = True
        else:
            self._column += 1

    def _linefeed(self) -> None:
        self._wrap_pending = False
        if self._row == self._scroll_bottom:
            self._scroll_up(1)
        else:
            self._row = min(self.rows - 1, self._row + 1)

    def _scroll_up(self, count: int) -> None:
        for _ in range(max(1, count)):
            del self._grid[self._scroll_top]
            self._grid.insert(self._scroll_bottom, self._blank_line())

    def _scroll_down(self, count: int) -> None:
        for _ in range(max(1, count)):
            del self._grid[self._scroll_bottom]
            self._grid.insert(self._scroll_top, self._blank_line())

    def _dispatch_escape(self, char: str) -> None:
        self._state = "normal"
        if char == "[":
            self._sequence = ""
            self._state = "csi"
        elif char == "]":
            self._state = "osc"
        elif char in "()#%":
            self._state = "charset"
        elif char == "7":
            self._saved_cursor = self.cursor
        elif char == "8":
            self._row, self._column = self._saved_cursor
        elif char == "D":
            self._linefeed()
        elif char == "E":
            self._column = 0
            self._linefeed()
        elif char == "M":
            if self._row == self._scroll_top:
                self._scroll_down(1)
            else:
                self._row = max(self._scroll_top, self._row - 1)
        elif char == "c":
            self._grid = self._blank_grid()
            self._row = 0
            self._column = 0
            self._wrap_pending = False

    @staticmethod
    def _params(sequence: str) -> tuple[bool, list[int]]:
        private = sequence.startswith("?")
        if private:
            sequence = sequence[1:]
        sequence = sequence.lstrip(">!")
        if not sequence:
            return private, []
        values = []
        for part in sequence.split(";"):
            try:
                values.append(int(part) if part else 0)
            except ValueError:
                values.append(0)
        return private, values

    @staticmethod
    def _param(params: list[int], index: int, default: int = 1) -> int:
        if index >= len(params) or params[index] == 0:
            return default
        return params[index]

    def _dispatch_csi(self, sequence: str, final: str) -> None:
        private, params = self._params(sequence)
        self._wrap_pending = False

        if final in {"H", "f"}:
            row = self._param(params, 0) - 1
            column = self._param(params, 1) - 1
            self._row = min(max(0, row), self.rows - 1)
            self._column = min(max(0, column), self.columns - 1)
        elif final == "A":
            self._row = max(self._scroll_top, self._row - self._param(params, 0))
        elif final == "B":
            self._row = min(self._scroll_bottom, self._row + self._param(params, 0))
        elif final == "C":
            self._column = min(self.columns - 1, self._column + self._param(params, 0))
        elif final == "D":
            self._column = max(0, self._column - self._param(params, 0))
        elif final == "E":
            self._row = min(self._scroll_bottom, self._row + self._param(params, 0))
            self._column = 0
        elif final == "F":
            self._row = max(self._scroll_top, self._row - self._param(params, 0))
            self._column = 0
        elif final == "G":
            self._column = min(self.columns - 1, self._param(params, 0) - 1)
        elif final == "d":
            self._row = min(self.rows - 1, self._param(params, 0) - 1)
        elif final == "J":
            self._erase_display(params[0] if params else 0)
        elif final == "K":
            self._erase_line(params[0] if params else 0)
        elif final == "s":
            self._saved_cursor = self.cursor
        elif final == "u":
            self._row, self._column = self._saved_cursor
        elif final == "r":
            top = self._param(params, 0) - 1
            bottom = self._param(params, 1, self.rows) - 1
            if 0 <= top < bottom < self.rows:
                self._scroll_top = top
                self._scroll_bottom = bottom
                self._row = top
                self._column = 0
        elif final == "S":
            self._scroll_up(self._param(params, 0))
        elif final == "T":
            self._scroll_down(self._param(params, 0))
        elif final == "P":
            self._delete_chars(self._param(params, 0))
        elif final == "@":
            self._insert_chars(self._param(params, 0))
        elif final == "X":
            self._erase_chars(self._param(params, 0))
        elif final == "L":
            self._insert_lines(self._param(params, 0))
        elif final == "M":
            self._delete_lines(self._param(params, 0))
        elif final in {"h", "l"} and private:
            self._set_private_modes(params, enabled=(final == "h"))
        elif final == "m":
            return

    def _erase_display(self, mode: int) -> None:
        if mode in {2, 3}:
            self._grid = self._blank_grid()
        elif mode == 0:
            self._grid[self._row][self._column:] = [" "] * (
                self.columns - self._column
            )
            for row in range(self._row + 1, self.rows):
                self._grid[row] = self._blank_line()
        elif mode == 1:
            for row in range(self._row):
                self._grid[row] = self._blank_line()
            self._grid[self._row][: self._column + 1] = [" "] * (
                self._column + 1
            )

    def _erase_line(self, mode: int) -> None:
        if mode == 0:
            self._grid[self._row][self._column:] = [" "] * (
                self.columns - self._column
            )
        elif mode == 1:
            self._grid[self._row][: self._column + 1] = [" "] * (
                self._column + 1
            )
        elif mode == 2:
            self._grid[self._row] = self._blank_line()

    def _delete_chars(self, count: int) -> None:
        count = min(count, self.columns - self._column)
        line = self._grid[self._row]
        del line[self._column:self._column + count]
        line.extend([" "] * count)

    def _insert_chars(self, count: int) -> None:
        count = min(count, self.columns - self._column)
        line = self._grid[self._row]
        for _ in range(count):
            line.insert(self._column, " ")
            line.pop()

    def _erase_chars(self, count: int) -> None:
        end = min(self.columns, self._column + count)
        self._grid[self._row][self._column:end] = [" "] * (end - self._column)

    def _insert_lines(self, count: int) -> None:
        if not self._scroll_top <= self._row <= self._scroll_bottom:
            return
        for _ in range(count):
            self._grid.insert(self._row, self._blank_line())
            del self._grid[self._scroll_bottom + 1]

    def _delete_lines(self, count: int) -> None:
        if not self._scroll_top <= self._row <= self._scroll_bottom:
            return
        for _ in range(count):
            del self._grid[self._row]
            self._grid.insert(self._scroll_bottom, self._blank_line())

    def _set_private_modes(self, params: list[int], *, enabled: bool) -> None:
        if not any(mode in {47, 1047, 1049} for mode in params):
            return
        if enabled and self._main_state is None:
            self._main_state = (
                [line[:] for line in self._grid],
                self.cursor,
            )
            self._grid = self._blank_grid()
            self._row = 0
            self._column = 0
        elif not enabled and self._main_state is not None:
            self._grid, (self._row, self._column) = self._main_state
            self._main_state = None


class TerminalBackend(QObject):
    """Process/PTY transport used by a terminal surface."""

    data_received = pyqtSignal(bytes)
    process_exited = pyqtSignal(int)

    def start(self) -> None:
        raise NotImplementedError

    def write(self, data: bytes) -> None:
        raise NotImplementedError

    def resize(self, rows: int, columns: int) -> None:
        raise NotImplementedError

    def shutdown(self) -> None:
        raise NotImplementedError


class UnixPtyBackend(TerminalBackend):
    """Linux/macOS/BSD PTY transport."""

    def __init__(self, *, cwd: Path, shell: str, parent=None) -> None:
        super().__init__(parent)
        self.cwd = cwd
        self.shell = shell
        self._master_fd = None
        self._process = None
        self._notifier = None
        self._poll_timer = QTimer(self)
        self._poll_timer.setInterval(100)
        self._poll_timer.timeout.connect(self._poll_process)

    def start(self) -> None:
        import pty

        master_fd, slave_fd = pty.openpty()
        env = os.environ.copy()
        env.setdefault("TERM", "xterm-256color")
        env.setdefault("COLORTERM", "truecolor")
        try:
            self._process = subprocess.Popen(
                [self.shell],
                stdin=slave_fd,
                stdout=slave_fd,
                stderr=slave_fd,
                cwd=str(self.cwd),
                env=env,
                start_new_session=True,
                close_fds=True,
            )
        finally:
            os.close(slave_fd)

        self._master_fd = master_fd
        os.set_blocking(master_fd, False)
        self._notifier = QSocketNotifier(
            master_fd,
            QSocketNotifier.Type.Read,
            self,
        )
        self._notifier.activated.connect(self._read_ready)
        self._poll_timer.start()

    def _read_ready(self, _fd=None) -> None:
        if self._master_fd is None:
            return
        try:
            data = os.read(self._master_fd, 65536)
        except BlockingIOError:
            return
        except OSError:
            data = b""
        if data:
            self.data_received.emit(data)
        else:
            if self._notifier is not None:
                self._notifier.setEnabled(False)

    def _poll_process(self) -> None:
        if self._process is None:
            return
        code = self._process.poll()
        if code is not None:
            self._poll_timer.stop()
            self.process_exited.emit(code)

    def write(self, data: bytes) -> None:
        if self._master_fd is None:
            return
        try:
            os.write(self._master_fd, data)
        except (BlockingIOError, OSError):
            return

    def resize(self, rows: int, columns: int) -> None:
        if self._master_fd is None:
            return
        import fcntl
        import termios

        size = struct.pack("HHHH", rows, columns, 0, 0)
        fcntl.ioctl(self._master_fd, termios.TIOCSWINSZ, size)
        if self._process is not None and self._process.poll() is None:
            try:
                os.killpg(self._process.pid, signal.SIGWINCH)
            except ProcessLookupError:
                pass

    def shutdown(self) -> None:
        self._poll_timer.stop()
        if self._notifier is not None:
            self._notifier.setEnabled(False)
            self._notifier.deleteLater()
            self._notifier = None
        if self._process is not None and self._process.poll() is None:
            self._process.terminate()
        if self._master_fd is not None:
            try:
                os.close(self._master_fd)
            except OSError:
                pass
            self._master_fd = None


class WindowsConPtyBackend(TerminalBackend):
    """Windows ConPTY transport placeholder for the native Windows backend."""

    def __init__(self, *, cwd: Path, shell: str, parent=None) -> None:
        super().__init__(parent)
        self.cwd = cwd
        self.shell = shell

    def start(self) -> None:
        raise RuntimeError("Windows ConPTY backend is not implemented yet")

    def write(self, data: bytes) -> None:
        del data

    def resize(self, rows: int, columns: int) -> None:
        del rows, columns

    def shutdown(self) -> None:
        return


def default_shell() -> str:
    if os.name == "nt":
        return os.environ.get("COMSPEC", "cmd.exe")
    return os.environ.get("SHELL", "/bin/sh")


def create_backend(*, cwd: Path, shell: str | None = None) -> TerminalBackend:
    shell = shell or default_shell()
    if os.name == "nt":
        return WindowsConPtyBackend(cwd=cwd, shell=shell)
    return UnixPtyBackend(cwd=cwd, shell=shell)


class TerminalView(QPlainTextEdit):
    """Keyboard-driven terminal surface backed by a real PTY."""

    _KEYS = {
        Qt.Key.Key_Up: b"\x1b[A",
        Qt.Key.Key_Down: b"\x1b[B",
        Qt.Key.Key_Right: b"\x1b[C",
        Qt.Key.Key_Left: b"\x1b[D",
        Qt.Key.Key_Home: b"\x1b[H",
        Qt.Key.Key_End: b"\x1b[F",
        Qt.Key.Key_Delete: b"\x1b[3~",
        Qt.Key.Key_PageUp: b"\x1b[5~",
        Qt.Key.Key_PageDown: b"\x1b[6~",
        Qt.Key.Key_Insert: b"\x1b[2~",
        Qt.Key.Key_Return: b"\r",
        Qt.Key.Key_Enter: b"\r",
        Qt.Key.Key_Backspace: b"\x7f",
        Qt.Key.Key_Tab: b"\t",
        Qt.Key.Key_Escape: b"\x1b",
    }

    def __init__(self, backend: TerminalBackend, parent=None) -> None:
        super().__init__(parent)
        self.backend = backend
        self.screen = TerminalScreen()
        self._decoder = codecs.getincrementaldecoder("utf-8")("replace")
        self.setReadOnly(True)
        self.setUndoRedoEnabled(False)
        self.setLineWrapMode(QPlainTextEdit.LineWrapMode.NoWrap)
        self.setFont(QFontDatabase.systemFont(QFontDatabase.SystemFont.FixedFont))
        self.backend.data_received.connect(self._on_data)
        self.backend.process_exited.connect(self._on_exit)

    def _on_data(self, data: bytes) -> None:
        text = self._decoder.decode(data)
        self.screen.feed(text)
        self._render()

    def _on_exit(self, code: int) -> None:
        self.screen.feed("\r\n[process exited: {}]".format(code))
        self._render()

    def _render(self) -> None:
        self.setPlainText("\n".join(self.screen.lines()))

    def keyPressEvent(self, event) -> None:  # noqa: N802 - Qt API
        modifiers = event.modifiers()
        control = bool(modifiers & Qt.KeyboardModifier.ControlModifier)
        shift = bool(modifiers & Qt.KeyboardModifier.ShiftModifier)
        alt = bool(modifiers & Qt.KeyboardModifier.AltModifier)

        if control and shift and event.key() == Qt.Key.Key_C:
            self.copy()
            return
        if control and shift and event.key() == Qt.Key.Key_V:
            clipboard = QApplication.clipboard()
            self.backend.write(clipboard.text().encode("utf-8"))
            return

        data = self._KEYS.get(event.key())
        if data is None and control and Qt.Key.Key_A <= event.key() <= Qt.Key.Key_Z:
            data = bytes([event.key() - Qt.Key.Key_A + 1])
        if data is None:
            text = event.text()
            if text:
                data = text.encode("utf-8")

        if data is None:
            return
        if alt and not data.startswith(b"\x1b"):
            data = b"\x1b" + data
        self.backend.write(data)

    def resizeEvent(self, event) -> None:  # noqa: N802 - Qt API
        super().resizeEvent(event)
        metrics = self.fontMetrics()
        cell_width = max(1, metrics.horizontalAdvance("M"))
        cell_height = max(1, metrics.height())
        columns = max(1, self.viewport().width() // cell_width)
        rows = max(1, self.viewport().height() // cell_height)
        if rows != self.screen.rows or columns != self.screen.columns:
            self.screen.resize(rows=rows, columns=columns)
            self.backend.resize(rows, columns)
            self._render()


class TerminalContent:
    """Workspace content adapter for an interactive native terminal."""

    kind = workspace.ContentKind.TERMINAL

    def __init__(
        self,
        cwd: str | Path | None = None,
        *,
        shell: str | None = None,
        parent: QWidget | None = None,
    ) -> None:
        self.cwd = Path(cwd or os.getcwd()).expanduser().resolve()
        if not self.cwd.is_dir():
            raise NotADirectoryError(str(self.cwd))
        self.shell = shell or default_shell()
        self.backend = create_backend(cwd=self.cwd, shell=self.shell)
        self._widget = TerminalView(self.backend, parent)
        self.backend.start()

    @property
    def widget(self) -> QWidget:
        return self._widget

    def title(self) -> str:
        return "Terminal · {}".format(self.cwd)

    def focus(self) -> None:
        self._widget.setFocus()

    def session_state(self) -> workspace.ContentSession:
        return workspace.ContentSession(
            kind=self.kind,
            state={"cwd": str(self.cwd), "shell": self.shell},
        )

    def shutdown(self) -> None:
        self.backend.shutdown()
