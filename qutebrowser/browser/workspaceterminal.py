# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Native workspace terminal using PTY/ConPTY and VT emulation."""

from __future__ import annotations

import codecs
import os
from pathlib import Path

from qutebrowser.qt.core import Qt
from qutebrowser.qt.gui import QColor, QFontDatabase, QTextCharFormat, QTextCursor
from qutebrowser.qt.widgets import QApplication, QPlainTextEdit, QWidget

from qutebrowser.browser import workspace, workspacevt

Color = workspacevt.Color
TerminalStyle = workspacevt.TerminalStyle
TerminalCell = workspacevt.TerminalCell
TerminalScreen = workspacevt.TerminalScreen


def default_shell() -> str:
    if os.name == "nt":
        return os.environ.get("COMSPEC", "cmd.exe")
    return os.environ.get("SHELL", "/bin/sh")


def create_backend(*, cwd: Path, shell: str | None = None):
    selected = shell or default_shell()
    if os.name == "nt":
        from qutebrowser.browser import conpty
        return conpty.WindowsConPtyBackend(cwd=cwd, shell=selected)
    from qutebrowser.browser import terminalbackend
    return terminalbackend.UnixPtyBackend(cwd=cwd, shell=selected)


def _ansi_color(value: Color) -> QColor | None:
    if value is None:
        return None
    if isinstance(value, tuple):
        return QColor(*value)
    basic = (
        (0, 0, 0), (205, 49, 49), (13, 188, 121), (229, 229, 16),
        (36, 114, 200), (188, 63, 188), (17, 168, 205), (229, 229, 229),
        (102, 102, 102), (241, 76, 76), (35, 209, 139), (245, 245, 67),
        (59, 142, 234), (214, 112, 214), (41, 184, 219), (255, 255, 255),
    )
    if value < 16:
        return QColor(*basic[value])
    if value < 232:
        index = value - 16
        r, g, b = index // 36, (index // 6) % 6, index % 6
        conv = lambda component: 0 if component == 0 else 55 + component * 40
        return QColor(conv(r), conv(g), conv(b))
    shade = 8 + (value - 232) * 10
    return QColor(shade, shade, shade)


class TerminalView(QPlainTextEdit):
    """Styled interactive terminal surface backed by a real pseudoterminal."""

    _KEYS = {
        Qt.Key.Key_Up: b"\x1b[A", Qt.Key.Key_Down: b"\x1b[B",
        Qt.Key.Key_Right: b"\x1b[C", Qt.Key.Key_Left: b"\x1b[D",
        Qt.Key.Key_Home: b"\x1b[H", Qt.Key.Key_End: b"\x1b[F",
        Qt.Key.Key_Delete: b"\x1b[3~", Qt.Key.Key_PageUp: b"\x1b[5~",
        Qt.Key.Key_PageDown: b"\x1b[6~", Qt.Key.Key_Insert: b"\x1b[2~",
        Qt.Key.Key_Return: b"\r", Qt.Key.Key_Enter: b"\r",
        Qt.Key.Key_Backspace: b"\x7f", Qt.Key.Key_Tab: b"\t",
        Qt.Key.Key_Backtab: b"\x1b[Z", Qt.Key.Key_Escape: b"\x1b",
        Qt.Key.Key_F1: b"\x1bOP", Qt.Key.Key_F2: b"\x1bOQ",
        Qt.Key.Key_F3: b"\x1bOR", Qt.Key.Key_F4: b"\x1bOS",
        Qt.Key.Key_F5: b"\x1b[15~", Qt.Key.Key_F6: b"\x1b[17~",
        Qt.Key.Key_F7: b"\x1b[18~", Qt.Key.Key_F8: b"\x1b[19~",
        Qt.Key.Key_F9: b"\x1b[20~", Qt.Key.Key_F10: b"\x1b[21~",
        Qt.Key.Key_F11: b"\x1b[23~", Qt.Key.Key_F12: b"\x1b[24~",
    }

    def __init__(self, backend, parent=None) -> None:
        super().__init__(parent)
        self.backend = backend
        self.screen = TerminalScreen()
        self._decoder = codecs.getincrementaldecoder("utf-8")("replace")
        self.setReadOnly(True)
        self.setUndoRedoEnabled(False)
        self.setLineWrapMode(QPlainTextEdit.LineWrapMode.NoWrap)
        self.setFont(QFontDatabase.systemFont(QFontDatabase.SystemFont.FixedFont))
        self.setMouseTracking(True)
        self.backend.data_received.connect(self._on_data)
        self.backend.process_exited.connect(self._on_exit)

    def _on_data(self, data: bytes) -> None:
        self.screen.feed(self._decoder.decode(data))
        response = self.screen.take_responses()
        if response:
            self.backend.write(response)
        self._render()

    def _on_exit(self, code: int) -> None:
        self.screen.feed("\r\n[process exited: {}]".format(code))
        self._render()

    def _format(self, style: TerminalStyle) -> QTextCharFormat:
        fmt = QTextCharFormat()
        foreground, background = style.foreground, style.background
        if style.inverse:
            foreground, background = background, foreground
        fg = _ansi_color(foreground)
        bg = _ansi_color(background)
        if fg is not None:
            fmt.setForeground(fg)
        if bg is not None:
            fmt.setBackground(bg)
        fmt.setFontWeight(700 if style.bold else 400)
        fmt.setFontItalic(style.italic)
        fmt.setFontUnderline(style.underline)
        return fmt

    def _render(self) -> None:
        cursor = QTextCursor(self.document())
        cursor.beginEditBlock()
        cursor.select(QTextCursor.SelectionType.Document)
        cursor.removeSelectedText()
        for row in range(self.screen.rows):
            if row:
                cursor.insertText("\n")
            line = [self.screen.cell(row, col) for col in range(self.screen.columns)]
            start = 0
            while start < len(line):
                style = line[start].style
                end = start + 1
                while end < len(line) and line[end].style == style:
                    end += 1
                cursor.insertText(
                    "".join(cell.char for cell in line[start:end]),
                    self._format(style),
                )
                start = end
        cursor.endEditBlock()
        row, column = self.screen.cursor
        pos = row * (self.screen.columns + 1) + column
        visible = QTextCursor(self.document())
        visible.setPosition(
            min(pos, max(0, self.document().characterCount() - 1))
        )
        self.setTextCursor(visible)

    def keyPressEvent(self, event) -> None:  # noqa: N802
        modifiers = event.modifiers()
        control = bool(modifiers & Qt.KeyboardModifier.ControlModifier)
        shift = bool(modifiers & Qt.KeyboardModifier.ShiftModifier)
        alt = bool(modifiers & Qt.KeyboardModifier.AltModifier)
        if control and shift and event.key() == Qt.Key.Key_C:
            self.copy()
            return
        if control and shift and event.key() == Qt.Key.Key_V:
            data = QApplication.clipboard().text().encode("utf-8")
            if self.screen.bracketed_paste:
                data = b"\x1b[200~" + data + b"\x1b[201~"
            self.backend.write(data)
            return
        data = self._KEYS.get(event.key())
        if data is None and control and Qt.Key.Key_A <= event.key() <= Qt.Key.Key_Z:
            data = bytes([event.key() - Qt.Key.Key_A + 1])
        if data is None and event.text():
            data = event.text().encode("utf-8")
        if data is None:
            return
        if alt and not data.startswith(b"\x1b"):
            data = b"\x1b" + data
        self.backend.write(data)

    def _mouse_position(self, event) -> tuple[int, int]:
        pos = event.position() if hasattr(event, "position") else event.pos()
        metrics = self.fontMetrics()
        width = max(1, metrics.horizontalAdvance("M"))
        height = max(1, metrics.height())
        return int(pos.x()) // width + 1, int(pos.y()) // height + 1

    @staticmethod
    def _mouse_button(button) -> int | None:
        mapping = {
            Qt.MouseButton.LeftButton: 0,
            Qt.MouseButton.MiddleButton: 1,
            Qt.MouseButton.RightButton: 2,
        }
        return mapping.get(button)

    def _send_mouse(
        self,
        code: int,
        x: int,
        y: int,
        *,
        release: bool = False,
    ) -> bool:
        if not self.screen.mouse_mode:
            return False
        if self.screen.sgr_mouse:
            suffix = "m" if release else "M"
            data = "\x1b[<{};{};{}{}".format(code, x, y, suffix).encode()
        else:
            data = b"\x1b[M" + bytes(
                (32 + code, min(255, 32 + x), min(255, 32 + y))
            )
        self.backend.write(data)
        return True

    def mousePressEvent(self, event) -> None:  # noqa: N802
        code = self._mouse_button(event.button())
        if code is not None:
            x, y = self._mouse_position(event)
            if self._send_mouse(code, x, y):
                return
        super().mousePressEvent(event)

    def mouseReleaseEvent(self, event) -> None:  # noqa: N802
        code = self._mouse_button(event.button())
        if code is not None:
            x, y = self._mouse_position(event)
            if self._send_mouse(code, x, y, release=True):
                return
        super().mouseReleaseEvent(event)

    def mouseMoveEvent(self, event) -> None:  # noqa: N802
        if self.screen.mouse_mode in {1002, 1003}:
            buttons = event.buttons()
            if buttons & Qt.MouseButton.LeftButton:
                code = 32
            elif buttons & Qt.MouseButton.MiddleButton:
                code = 33
            elif buttons & Qt.MouseButton.RightButton:
                code = 34
            elif self.screen.mouse_mode == 1003:
                code = 35
            else:
                return super().mouseMoveEvent(event)
            x, y = self._mouse_position(event)
            if self._send_mouse(code, x, y):
                return
        super().mouseMoveEvent(event)

    def wheelEvent(self, event) -> None:  # noqa: N802
        if self.screen.mouse_mode:
            delta = event.angleDelta().y()
            code = 64 if delta > 0 else 65
            x, y = self._mouse_position(event)
            if self._send_mouse(code, x, y):
                return
        super().wheelEvent(event)

    def resizeEvent(self, event) -> None:  # noqa: N802
        super().resizeEvent(event)
        metrics = self.fontMetrics()
        columns = max(
            1,
            self.viewport().width() // max(1, metrics.horizontalAdvance("M")),
        )
        rows = max(1, self.viewport().height() // max(1, metrics.height()))
        if rows != self.screen.rows or columns != self.screen.columns:
            self.screen.resize(rows=rows, columns=columns)
            self.backend.resize(rows, columns)
            self._render()


class TerminalContent:
    """Workspace adapter for an interactive PTY/ConPTY terminal."""

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
        title = self._widget.screen.title
        if title and title != "Terminal":
            return "{} · {}".format(title, self.cwd)
        return "Terminal · {}".format(self.cwd)

    def focus(self) -> None:
        self._widget.setFocus()

    def session_state(self) -> workspace.ContentSession:
        return workspace.ContentSession(
            self.kind,
            {"cwd": str(self.cwd), "shell": self.shell},
        )

    def shutdown(self) -> None:
        self.backend.shutdown()
