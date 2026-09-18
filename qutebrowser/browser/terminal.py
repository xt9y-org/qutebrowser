# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Native terminal process transports for workspace terminal tabs."""

from __future__ import annotations

import dataclasses
import os
import pathlib
import subprocess
from collections.abc import Mapping, Sequence

from qutebrowser.qt.core import QObject, QSocketNotifier, QTimer, pyqtSignal


def default_shell(*, platform_name: str | None = None) -> list[str]:
    """Return the platform's default interactive shell command."""
    platform_name = os.name if platform_name is None else platform_name
    if platform_name == "posix":
        return [os.environ.get("SHELL") or "/bin/sh"]
    if platform_name == "nt":
        return [os.environ.get("COMSPEC") or "cmd.exe"]
    raise ValueError("Unsupported terminal platform: {}".format(platform_name))


@dataclasses.dataclass
class TerminalSpec:
    """Description of one terminal process."""

    cwd: pathlib.Path
    command: Sequence[str] | None = None
    columns: int = 80
    rows: int = 24
    env: Mapping[str, str] | None = None

    def __post_init__(self) -> None:
        self.cwd = pathlib.Path(self.cwd).expanduser().resolve()
        self.command = list(default_shell() if self.command is None else self.command)
        if not self.command:
            raise ValueError("Terminal command must not be empty")
        if self.columns <= 0 or self.rows <= 0:
            raise ValueError("Terminal rows and columns must be positive")
        if self.env is not None:
            self.env = dict(self.env)

    def environment(self) -> dict[str, str]:
        """Build the child environment without mutating os.environ."""
        env = dict(os.environ)
        if self.env is not None:
            env.update(self.env)
        env.setdefault("TERM", "xterm-256color")
        env.setdefault("COLORTERM", "truecolor")
        env.setdefault("TERM_PROGRAM", "qutebrowser")
        return env


class TerminalBackend(QObject):
    """Common signal surface for platform terminal transports."""

    output = pyqtSignal(bytes)
    exited = pyqtSignal(int)

    def start(self, spec: TerminalSpec) -> None:
        raise NotImplementedError

    def write(self, data: bytes) -> None:
        raise NotImplementedError

    def resize(self, columns: int, rows: int) -> None:
        raise NotImplementedError

    def close(self) -> None:
        raise NotImplementedError

    def is_running(self) -> bool:
        raise NotImplementedError


class UnixPtyBackend(TerminalBackend):
    """POSIX PTY transport used on Linux and macOS."""

    def __init__(self, parent: QObject | None = None) -> None:
        super().__init__(parent)
        self._master_fd: int | None = None
        self._process: subprocess.Popen[bytes] | None = None
        self._notifier: QSocketNotifier | None = None
        self._poll_timer = QTimer(self)
        self._poll_timer.setInterval(100)
        self._poll_timer.timeout.connect(self._poll_process)

    @staticmethod
    def _set_size(fd: int, columns: int, rows: int) -> None:
        import fcntl
        import struct
        import termios

        size = struct.pack("HHHH", rows, columns, 0, 0)
        fcntl.ioctl(fd, termios.TIOCSWINSZ, size)

    def start(self, spec: TerminalSpec) -> None:
        if os.name != "posix":
            raise RuntimeError("Unix PTY backend is only available on POSIX")
        if self.is_running():
            raise RuntimeError("Terminal process is already running")

        import pty

        master_fd, slave_fd = pty.openpty()
        try:
            self._set_size(slave_fd, spec.columns, spec.rows)
            process = subprocess.Popen(
                list(spec.command),
                cwd=str(spec.cwd),
                env=spec.environment(),
                stdin=slave_fd,
                stdout=slave_fd,
                stderr=slave_fd,
                start_new_session=True,
                close_fds=True,
            )
        except Exception:
            os.close(master_fd)
            os.close(slave_fd)
            raise
        finally:
            if "process" in locals():
                os.close(slave_fd)

        os.set_blocking(master_fd, False)
        self._master_fd = master_fd
        self._process = process
        self._notifier = QSocketNotifier(
            master_fd,
            QSocketNotifier.Type.Read,
            self,
        )
        self._notifier.activated.connect(self._read_ready)
        self._poll_timer.start()

    def _read_ready(self, _fd: int) -> None:
        if self._master_fd is None:
            return
        while True:
            try:
                data = os.read(self._master_fd, 65536)
            except BlockingIOError:
                return
            except OSError:
                self._poll_process()
                return
            if not data:
                self._poll_process()
                return
            self.output.emit(data)
            if len(data) < 65536:
                return

    def _poll_process(self) -> None:
        if self._process is None:
            return
        code = self._process.poll()
        if code is None:
            return
        self._poll_timer.stop()
        self._disable_notifier()
        self._close_master()
        self._process = None
        self.exited.emit(code)

    def _disable_notifier(self) -> None:
        if self._notifier is not None:
            self._notifier.setEnabled(False)
            self._notifier.deleteLater()
            self._notifier = None

    def _close_master(self) -> None:
        if self._master_fd is not None:
            try:
                os.close(self._master_fd)
            except OSError:
                pass
            self._master_fd = None

    def write(self, data: bytes) -> None:
        if self._master_fd is None:
            raise RuntimeError("Terminal process is not running")
        view = memoryview(data)
        while view:
            written = os.write(self._master_fd, view)
            view = view[written:]

    def resize(self, columns: int, rows: int) -> None:
        if columns <= 0 or rows <= 0:
            raise ValueError("Terminal rows and columns must be positive")
        if self._master_fd is None:
            return
        self._set_size(self._master_fd, columns, rows)

    def close(self) -> None:
        process = self._process
        self._poll_timer.stop()
        self._disable_notifier()
        self._close_master()
        self._process = None
        if process is not None and process.poll() is None:
            process.terminate()

    def is_running(self) -> bool:
        return self._process is not None and self._process.poll() is None


class WinConPtyBackend(TerminalBackend):
    """Windows ConPTY transport backed by pywinpty when started."""

    def __init__(self, parent: QObject | None = None) -> None:
        super().__init__(parent)
        self._process = None
        self._poll_timer = QTimer(self)
        self._poll_timer.setInterval(10)
        self._poll_timer.timeout.connect(self._read_ready)

    def start(self, spec: TerminalSpec) -> None:
        if os.name != "nt":
            raise RuntimeError("ConPTY backend is only available on Windows")
        if self.is_running():
            raise RuntimeError("Terminal process is already running")
        try:
            from winpty import PtyProcess
        except ImportError as exc:
            raise RuntimeError(
                "Windows terminal tabs require the pywinpty package"
            ) from exc

        self._process = PtyProcess.spawn(
            list(spec.command),
            cwd=str(spec.cwd),
            env=spec.environment(),
            dimensions=(spec.rows, spec.columns),
        )
        self._poll_timer.start()

    def _read_ready(self) -> None:
        process = self._process
        if process is None:
            return
        if not process.isalive():
            self._poll_timer.stop()
            self._process = None
            self.exited.emit(0)
            return
        try:
            data = process.read(65536)
        except EOFError:
            self._poll_timer.stop()
            self._process = None
            self.exited.emit(0)
            return
        if data:
            self.output.emit(data.encode("utf-8", errors="replace"))

    def write(self, data: bytes) -> None:
        if self._process is None:
            raise RuntimeError("Terminal process is not running")
        self._process.write(data.decode("utf-8", errors="replace"))

    def resize(self, columns: int, rows: int) -> None:
        if columns <= 0 or rows <= 0:
            raise ValueError("Terminal rows and columns must be positive")
        if self._process is not None:
            self._process.setwinsize(rows, columns)

    def close(self) -> None:
        process = self._process
        self._poll_timer.stop()
        self._process = None
        if process is not None and process.isalive():
            process.terminate(force=True)

    def is_running(self) -> bool:
        return self._process is not None and self._process.isalive()


def create_backend(
    *,
    platform_name: str | None = None,
    parent: QObject | None = None,
) -> TerminalBackend:
    """Create the terminal transport for the selected operating system."""
    platform_name = os.name if platform_name is None else platform_name
    if platform_name == "posix":
        return UnixPtyBackend(parent)
    if platform_name == "nt":
        return WinConPtyBackend(parent)
    raise ValueError("Unsupported terminal platform: {}".format(platform_name))
