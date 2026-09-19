# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Process transports for native workspace terminal tabs."""

from __future__ import annotations

import os
import signal
import struct
import subprocess
from pathlib import Path

from qutebrowser.qt.core import QObject, QSocketNotifier, QTimer, pyqtSignal


class TerminalBackend(QObject):
    """Abstract byte transport between a terminal view and a shell process."""

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
    """Linux/macOS/BSD pseudoterminal transport."""

    def __init__(self, *, cwd: Path, shell: str, parent=None) -> None:
        super().__init__(parent)
        self.cwd = Path(cwd)
        self.shell = shell
        self._master_fd: int | None = None
        self._process: subprocess.Popen[bytes] | None = None
        self._notifier: QSocketNotifier | None = None
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
        elif self._notifier is not None:
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
        view = memoryview(data)
        while view:
            try:
                written = os.write(self._master_fd, view)
            except BlockingIOError:
                return
            except OSError:
                return
            view = view[written:]

    def resize(self, rows: int, columns: int) -> None:
        if self._master_fd is None:
            return
        import fcntl
        import termios

        size = struct.pack("HHHH", max(1, rows), max(1, columns), 0, 0)
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

        process = self._process
        self._process = None
        if process is not None and process.poll() is None:
            try:
                os.killpg(process.pid, signal.SIGHUP)
            except ProcessLookupError:
                pass
            try:
                process.terminate()
            except ProcessLookupError:
                pass

        if self._master_fd is not None:
            try:
                os.close(self._master_fd)
            except OSError:
                pass
            self._master_fd = None
