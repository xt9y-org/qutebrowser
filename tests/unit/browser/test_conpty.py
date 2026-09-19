# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for the Windows ConPTY terminal backend."""

import ctypes

from qutebrowser.browser import conpty, terminalcontent


def test_conpty_backend_matches_terminal_transport(tmp_path):
    backend = conpty.WindowsConPtyBackend(
        cwd=tmp_path,
        shell="cmd.exe",
    )

    assert isinstance(backend, terminalcontent.TerminalBackend)
    assert backend.cwd == tmp_path
    assert backend.shell == "cmd.exe"


def test_conpty_coord_uses_columns_then_rows():
    coord = conpty._coord(rows=24, columns=80)

    assert coord.X == 80
    assert coord.Y == 24


def test_conpty_pipe_handles_live_until_child_process_starts(monkeypatch, tmp_path):
    closed = []
    next_handle = iter([101, 102, 103, 104])

    class FakeKernel32:
        def CreatePipe(self, read_ptr, write_ptr, _security, _size):
            ctypes.cast(read_ptr, ctypes.POINTER(conpty.HANDLE)).contents.value = next(next_handle)
            ctypes.cast(write_ptr, ctypes.POINTER(conpty.HANDLE)).contents.value = next(next_handle)
            return 1

        def SetHandleInformation(self, _handle, _mask, _flags):
            return 1

        def CreatePseudoConsole(self, _size, _input, _output, _flags, hpc_ptr):
            ctypes.cast(hpc_ptr, ctypes.POINTER(conpty.HANDLE)).contents.value = 200
            return 0

    class FakeApi:
        def __init__(self):
            self.kernel32 = FakeKernel32()

        def require_bool(self, result, _message):
            assert result

        def require_hr(self, result, _message):
            assert result >= 0

        def close_handle(self, handle):
            if handle is not None and handle.value:
                closed.append(handle.value)

    class FakeThread:
        def __init__(self, **_kwargs):
            pass

        def start(self):
            pass

        def is_alive(self):
            return False

    fake_api = FakeApi()
    monkeypatch.setattr(conpty, "_WindowsApi", lambda: fake_api)
    monkeypatch.setattr(conpty.threading, "Thread", FakeThread)

    backend = conpty.WindowsConPtyBackend(
        cwd=tmp_path,
        shell="cmd.exe",
    )
    monkeypatch.setattr(backend._poll_timer, "start", lambda: None)

    def fake_start_process():
        # Microsoft requires the pseudoconsole-side pipe handles to remain open
        # through CreateProcessW. Closing either side before this point can make
        # the hosted process fail initialization with 0xc0000142.
        assert 101 not in closed
        assert 104 not in closed

    monkeypatch.setattr(backend, "_start_process", fake_start_process)

    backend.start()

    assert 101 in closed
    assert 104 in closed
