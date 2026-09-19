# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""VT terminal screen model for workspace terminal tabs."""

from __future__ import annotations

import dataclasses

Color = int | tuple[int, int, int] | None


@dataclasses.dataclass(frozen=True)
class TerminalStyle:
    foreground: Color = None
    background: Color = None
    bold: bool = False
    italic: bool = False
    underline: bool = False
    inverse: bool = False


@dataclasses.dataclass
class TerminalCell:
    char: str = " "
    style: TerminalStyle = dataclasses.field(default_factory=TerminalStyle)


class TerminalScreen:
    """VT-compatible character/style grid used by interactive TUIs."""

    def __init__(self, *, rows: int = 24, columns: int = 80) -> None:
        self.rows = max(1, rows)
        self.columns = max(1, columns)
        self._style = TerminalStyle()
        self._grid = self._blank_grid()
        self._row = 0
        self._column = 0
        self._saved_cursor = (0, 0)
        self._saved_style = self._style
        self._state = "normal"
        self._sequence = ""
        self._osc = ""
        self._wrap_pending = False
        self._scroll_top = 0
        self._scroll_bottom = self.rows - 1
        self._main_state = None
        self._responses: list[bytes] = []
        self.title = "Terminal"
        self.mouse_mode = 0
        self.sgr_mouse = False
        self.bracketed_paste = False

    @property
    def cursor(self) -> tuple[int, int]:
        return self._row, self._column

    def cell(self, row: int, column: int) -> TerminalCell:
        return self._grid[row][column]

    def _blank_cell(self) -> TerminalCell:
        return TerminalCell()

    def _blank_line(self) -> list[TerminalCell]:
        return [self._blank_cell() for _ in range(self.columns)]

    def _blank_grid(self) -> list[list[TerminalCell]]:
        return [self._blank_line() for _ in range(self.rows)]

    def lines(self) -> list[str]:
        return ["".join(cell.char for cell in line) for line in self._grid]

    def take_responses(self) -> bytes:
        response = b"".join(self._responses)
        self._responses.clear()
        return response

    def resize(self, *, rows: int, columns: int) -> None:
        rows = max(1, rows)
        columns = max(1, columns)
        old_rows, old_columns = self.rows, self.columns
        old_grid = self._grid
        self.rows = rows
        self.columns = columns
        self._grid = self._blank_grid()
        for row in range(min(rows, old_rows)):
            for column in range(min(columns, old_columns)):
                self._grid[row][column] = old_grid[row][column]
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
                self._finish_osc()
            elif char == "\x1b":
                self._state = "osc-escape"
            else:
                self._osc += char
            return
        if self._state == "osc-escape":
            if char == "\\":
                self._finish_osc()
            else:
                self._osc += "\x1b" + char
                self._state = "osc"
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
            self._column = min(self.columns - 1, ((self._column // 8) + 1) * 8)
            self._wrap_pending = False
        elif char in {"\x00", "\x07"} or ord(char) < 32:
            return
        else:
            self._put(char)

    def _put(self, char: str) -> None:
        if self._wrap_pending:
            self._column = 0
            self._linefeed()
            self._wrap_pending = False
        self._grid[self._row][self._column] = TerminalCell(char, self._style)
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

    def _finish_osc(self) -> None:
        command, sep, value = self._osc.partition(";")
        if sep and command in {"0", "2"}:
            self.title = value
        self._osc = ""
        self._state = "normal"

    def _dispatch_escape(self, char: str) -> None:
        self._state = "normal"
        if char == "[":
            self._sequence = ""
            self._state = "csi"
        elif char == "]":
            self._osc = ""
            self._state = "osc"
        elif char in "()#%":
            self._state = "charset"
        elif char == "7":
            self._saved_cursor = self.cursor
            self._saved_style = self._style
        elif char == "8":
            self._row, self._column = self._saved_cursor
            self._style = self._saved_style
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
            self.__init__(rows=self.rows, columns=self.columns)

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
            self._row = min(max(0, self._param(params, 0) - 1), self.rows - 1)
            self._column = min(max(0, self._param(params, 1) - 1), self.columns - 1)
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
            self._saved_style = self._style
        elif final == "u":
            self._row, self._column = self._saved_cursor
            self._style = self._saved_style
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
            self._set_sgr(params)
        elif final == "n":
            mode = params[0] if params else 0
            if mode == 5:
                self._responses.append(b"\x1b[0n")
            elif mode == 6:
                self._responses.append(
                    "\x1b[{};{}R".format(self._row + 1, self._column + 1).encode()
                )
        elif final == "c":
            self._responses.append(b"\x1b[?1;2c")

    def _erase_display(self, mode: int) -> None:
        if mode in {2, 3}:
            self._grid = self._blank_grid()
        elif mode == 0:
            self._grid[self._row][self._column:] = [
                self._blank_cell() for _ in range(self.columns - self._column)
            ]
            for row in range(self._row + 1, self.rows):
                self._grid[row] = self._blank_line()
        elif mode == 1:
            for row in range(self._row):
                self._grid[row] = self._blank_line()
            self._grid[self._row][: self._column + 1] = [
                self._blank_cell() for _ in range(self._column + 1)
            ]

    def _erase_line(self, mode: int) -> None:
        if mode == 0:
            self._grid[self._row][self._column:] = [
                self._blank_cell() for _ in range(self.columns - self._column)
            ]
        elif mode == 1:
            self._grid[self._row][: self._column + 1] = [
                self._blank_cell() for _ in range(self._column + 1)
            ]
        elif mode == 2:
            self._grid[self._row] = self._blank_line()

    def _delete_chars(self, count: int) -> None:
        count = min(count, self.columns - self._column)
        line = self._grid[self._row]
        del line[self._column:self._column + count]
        line.extend(self._blank_cell() for _ in range(count))

    def _insert_chars(self, count: int) -> None:
        count = min(count, self.columns - self._column)
        line = self._grid[self._row]
        for _ in range(count):
            line.insert(self._column, self._blank_cell())
            line.pop()

    def _erase_chars(self, count: int) -> None:
        end = min(self.columns, self._column + count)
        self._grid[self._row][self._column:end] = [
            self._blank_cell() for _ in range(end - self._column)
        ]

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
        alt_modes = {47, 1047, 1049}
        if any(mode in alt_modes for mode in params):
            if enabled and self._main_state is None:
                self._main_state = (
                    [[dataclasses.replace(cell) for cell in line] for line in self._grid],
                    self.cursor,
                    self._style,
                )
                self._grid = self._blank_grid()
                self._row = 0
                self._column = 0
            elif not enabled and self._main_state is not None:
                self._grid, (self._row, self._column), self._style = self._main_state
                self._main_state = None
        for mode in params:
            if mode in {1000, 1002, 1003}:
                self.mouse_mode = mode if enabled else 0
            elif mode == 1006:
                self.sgr_mouse = enabled
            elif mode == 2004:
                self.bracketed_paste = enabled

    def _set_sgr(self, params: list[int]) -> None:
        if not params:
            params = [0]
        style = self._style
        foreground = style.foreground
        background = style.background
        bold = style.bold
        italic = style.italic
        underline = style.underline
        inverse = style.inverse
        index = 0
        while index < len(params):
            code = params[index]
            if code == 0:
                foreground = background = None
                bold = italic = underline = inverse = False
            elif code == 1:
                bold = True
            elif code == 3:
                italic = True
            elif code == 4:
                underline = True
            elif code == 7:
                inverse = True
            elif code in {21, 22}:
                bold = False
            elif code == 23:
                italic = False
            elif code == 24:
                underline = False
            elif code == 27:
                inverse = False
            elif 30 <= code <= 37:
                foreground = code - 30
            elif code == 39:
                foreground = None
            elif 40 <= code <= 47:
                background = code - 40
            elif code == 49:
                background = None
            elif 90 <= code <= 97:
                foreground = code - 90 + 8
            elif 100 <= code <= 107:
                background = code - 100 + 8
            elif code in {38, 48} and index + 1 < len(params):
                target_foreground = code == 38
                mode = params[index + 1]
                if mode == 5 and index + 2 < len(params):
                    value: Color = max(0, min(255, params[index + 2]))
                    index += 2
                elif mode == 2 and index + 4 < len(params):
                    value = tuple(max(0, min(255, p)) for p in params[index + 2:index + 5])
                    index += 4
                else:
                    value = None
                    index += 1
                if target_foreground:
                    foreground = value
                else:
                    background = value
            index += 1
        self._style = TerminalStyle(
            foreground=foreground,
            background=background,
            bold=bold,
            italic=italic,
            underline=underline,
            inverse=inverse,
        )


