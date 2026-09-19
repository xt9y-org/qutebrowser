# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Windows ConPTY transport for native terminal workspace tabs."""

from __future__ import annotations

import ctypes
import os
import threading
from pathlib import Path

from qutebrowser.qt.core import QTimer

from qutebrowser.browser import terminalcontent


HANDLE = ctypes.c_void_p
DWORD = ctypes.c_ulong
WORD = ctypes.c_ushort
SIZE_T = ctypes.c_size_t
ULONG_PTR = ctypes.c_size_t
BOOL = ctypes.c_int
HRESULT = ctypes.c_long
LPVOID = ctypes.c_void_p


class COORD(ctypes.Structure):
    _fields_ = [
        ("X", ctypes.c_short),
        ("Y", ctypes.c_short),
    ]


class STARTUPINFOW(ctypes.Structure):
    _fields_ = [
        ("cb", DWORD),
        ("lpReserved", ctypes.c_wchar_p),
        ("lpDesktop", ctypes.c_wchar_p),
        ("lpTitle", ctypes.c_wchar_p),
        ("dwX", DWORD),
        ("dwY", DWORD),
        ("dwXSize", DWORD),
        ("dwYSize", DWORD),
        ("dwXCountChars", DWORD),
        ("dwYCountChars", DWORD),
        ("dwFillAttribute", DWORD),
        ("dwFlags", DWORD),
        ("wShowWindow", WORD),
        ("cbReserved2", WORD),
        ("lpReserved2", ctypes.POINTER(ctypes.c_ubyte)),
        ("hStdInput", HANDLE),
        ("hStdOutput", HANDLE),
        ("hStdError", HANDLE),
    ]


class STARTUPINFOEXW(ctypes.Structure):
    _fields_ = [
        ("StartupInfo", STARTUPINFOW),
        ("lpAttributeList", LPVOID),
    ]


class PROCESS_INFORMATION(ctypes.Structure):
    _fields_ = [
        ("hProcess", HANDLE),
        ("hThread", HANDLE),
        ("dwProcessId", DWORD),
        ("dwThreadId", DWORD),
    ]


PROC_THREAD_ATTRIBUTE_PSEUDOCONSOLE = 0x00020016
EXTENDED_STARTUPINFO_PRESENT = 0x00080000
HANDLE_FLAG_INHERIT = 0x00000001
WAIT_OBJECT_0 = 0x00000000
WAIT_TIMEOUT = 0x00000102
ERROR_BROKEN_PIPE = 109
ERROR_OPERATION_ABORTED = 995


def _coord(*, rows: int, columns: int) -> COORD:
    """Build a ConPTY COORD, whose X/Y fields mean columns/rows."""
    return COORD(max(1, columns), max(1, rows))


class _WindowsApi:
    """Typed subset of kernel32 used by the ConPTY backend."""

    def __init__(self) -> None:
        if os.name != "nt":
            raise RuntimeError("ConPTY is only available on Windows")

        self.kernel32 = ctypes.WinDLL("kernel32", use_last_error=True)
        kernel32 = self.kernel32

        kernel32.CreatePipe.argtypes = [
            ctypes.POINTER(HANDLE),
            ctypes.POINTER(HANDLE),
            LPVOID,
            DWORD,
        ]
        kernel32.CreatePipe.restype = BOOL

        kernel32.SetHandleInformation.argtypes = [HANDLE, DWORD, DWORD]
        kernel32.SetHandleInformation.restype = BOOL

        kernel32.CreatePseudoConsole.argtypes = [
            COORD,
            HANDLE,
            HANDLE,
            DWORD,
            ctypes.POINTER(HANDLE),
        ]
        kernel32.CreatePseudoConsole.restype = HRESULT

        kernel32.ResizePseudoConsole.argtypes = [HANDLE, COORD]
        kernel32.ResizePseudoConsole.restype = HRESULT

        kernel32.ClosePseudoConsole.argtypes = [HANDLE]
        kernel32.ClosePseudoConsole.restype = None

        kernel32.InitializeProcThreadAttributeList.argtypes = [
            LPVOID,
            DWORD,
            DWORD,
            ctypes.POINTER(SIZE_T),
        ]
        kernel32.InitializeProcThreadAttributeList.restype = BOOL

        kernel32.UpdateProcThreadAttribute.argtypes = [
            LPVOID,
            DWORD,
            ULONG_PTR,
            LPVOID,
            SIZE_T,
            LPVOID,
            LPVOID,
        ]
        kernel32.UpdateProcThreadAttribute.restype = BOOL

        kernel32.DeleteProcThreadAttributeList.argtypes = [LPVOID]
        kernel32.DeleteProcThreadAttributeList.restype = None

        kernel32.CreateProcessW.argtypes = [
            ctypes.c_wchar_p,
            ctypes.c_wchar_p,
            LPVOID,
            LPVOID,
            BOOL,
            DWORD,
            LPVOID,
            ctypes.c_wchar_p,
            ctypes.POINTER(STARTUPINFOW),
            ctypes.POINTER(PROCESS_INFORMATION),
        ]
        kernel32.CreateProcessW.restype = BOOL

        kernel32.ReadFile.argtypes = [
            HANDLE,
            LPVOID,
            DWORD,
            ctypes.POINTER(DWORD),
            LPVOID,
        ]
        kernel32.ReadFile.restype = BOOL

        kernel32.WriteFile.argtypes = [
            HANDLE,
            LPVOID,
            DWORD,
            ctypes.POINTER(DWORD),
            LPVOID,
        ]
        kernel32.WriteFile.restype = BOOL

        kernel32.WaitForSingleObject.argtypes = [HANDLE, DWORD]
        kernel32.WaitForSingleObject.restype = DWORD

        kernel32.GetExitCodeProcess.argtypes = [HANDLE, ctypes.POINTER(DWORD)]
        kernel32.GetExitCodeProcess.restype = BOOL

        kernel32.CloseHandle.argtypes = [HANDLE]
        kernel32.CloseHandle.restype = BOOL

    @staticmethod
    def _last_error(message: str) -> OSError:
        code = ctypes.get_last_error()
        return OSError(code, "{}: {}".format(message, ctypes.FormatError(code)))

    def require_bool(self, result: int, message: str) -> None:
        if not result:
            raise self._last_error(message)

    @staticmethod
    def require_hr(result: int, message: str) -> None:
        if result < 0:
            unsigned = ctypes.c_ulong(result).value
            raise OSError(unsigned, "{} failed with HRESULT 0x{:08x}".format(
                message,
                unsigned,
            ))

    def close_handle(self, handle: HANDLE | None) -> None:
        if handle is not None and handle.value:
            self.kernel32.CloseHandle(handle)


class WindowsConPtyBackend(terminalcontent.TerminalBackend):
    """Windows 10 1809+ pseudoconsole transport."""

    def __init__(self, *, cwd: Path, shell: str, parent=None) -> None:
        super().__init__(parent)
        self.cwd = Path(cwd)
        self.shell = shell
        self._api: _WindowsApi | None = None
        self._hpc = HANDLE()
        self._input_write = HANDLE()
        self._output_read = HANDLE()
        self._process = HANDLE()
        self._reader: threading.Thread | None = None
        self._closing = threading.Event()
        self._poll_timer = QTimer(self)
        self._poll_timer.setInterval(100)
        self._poll_timer.timeout.connect(self._poll_process)

    def start(self) -> None:
        api = _WindowsApi()
        self._api = api
        kernel32 = api.kernel32

        pty_input_read = HANDLE()
        pty_output_write = HANDLE()
        try:
            api.require_bool(
                kernel32.CreatePipe(
                    ctypes.byref(pty_input_read),
                    ctypes.byref(self._input_write),
                    None,
                    0,
                ),
                "CreatePipe(ConPTY input)",
            )
            api.require_bool(
                kernel32.CreatePipe(
                    ctypes.byref(self._output_read),
                    ctypes.byref(pty_output_write),
                    None,
                    0,
                ),
                "CreatePipe(ConPTY output)",
            )

            api.require_bool(
                kernel32.SetHandleInformation(
                    self._input_write,
                    HANDLE_FLAG_INHERIT,
                    0,
                ),
                "SetHandleInformation(input)",
            )
            api.require_bool(
                kernel32.SetHandleInformation(
                    self._output_read,
                    HANDLE_FLAG_INHERIT,
                    0,
                ),
                "SetHandleInformation(output)",
            )

            api.require_hr(
                kernel32.CreatePseudoConsole(
                    _coord(rows=24, columns=80),
                    pty_input_read,
                    pty_output_write,
                    0,
                    ctypes.byref(self._hpc),
                ),
                "CreatePseudoConsole",
            )
        except Exception:
            api.close_handle(self._input_write)
            api.close_handle(self._output_read)
            self._input_write = HANDLE()
            self._output_read = HANDLE()
            raise
        finally:
            api.close_handle(pty_input_read)
            api.close_handle(pty_output_write)

        try:
            self._start_process()
        except Exception:
            self.shutdown()
            raise

        self._reader = threading.Thread(
            target=self._reader_main,
            name="qutebrowser-conpty-reader",
            daemon=True,
        )
        self._reader.start()
        self._poll_timer.start()

    def _start_process(self) -> None:
        assert self._api is not None
        api = self._api
        kernel32 = api.kernel32

        required = SIZE_T(0)
        kernel32.InitializeProcThreadAttributeList(
            None,
            1,
            0,
            ctypes.byref(required),
        )
        if required.value == 0:
            raise api._last_error("InitializeProcThreadAttributeList(size)")

        attribute_buffer = ctypes.create_string_buffer(required.value)
        attribute_list = ctypes.cast(attribute_buffer, LPVOID)
        api.require_bool(
            kernel32.InitializeProcThreadAttributeList(
                attribute_list,
                1,
                0,
                ctypes.byref(required),
            ),
            "InitializeProcThreadAttributeList",
        )

        startup = STARTUPINFOEXW()
        startup.StartupInfo.cb = ctypes.sizeof(STARTUPINFOEXW)
        startup.lpAttributeList = attribute_list

        try:
            api.require_bool(
                kernel32.UpdateProcThreadAttribute(
                    attribute_list,
                    0,
                    PROC_THREAD_ATTRIBUTE_PSEUDOCONSOLE,
                    self._hpc,
                    ctypes.sizeof(HANDLE),
                    None,
                    None,
                ),
                "UpdateProcThreadAttribute(ConPTY)",
            )

            process_info = PROCESS_INFORMATION()
            command_line = ctypes.create_unicode_buffer(self.shell)
            startup_ptr = ctypes.cast(
                ctypes.byref(startup),
                ctypes.POINTER(STARTUPINFOW),
            )
            api.require_bool(
                kernel32.CreateProcessW(
                    None,
                    ctypes.cast(command_line, ctypes.c_wchar_p),
                    None,
                    None,
                    False,
                    EXTENDED_STARTUPINFO_PRESENT,
                    None,
                    str(self.cwd),
                    startup_ptr,
                    ctypes.byref(process_info),
                ),
                "CreateProcessW(ConPTY shell)",
            )
            self._process = process_info.hProcess
            api.close_handle(process_info.hThread)
        finally:
            kernel32.DeleteProcThreadAttributeList(attribute_list)

    def _reader_main(self) -> None:
        api = self._api
        if api is None:
            return
        kernel32 = api.kernel32
        buffer = ctypes.create_string_buffer(65536)

        while not self._closing.is_set():
            read = DWORD(0)
            ok = kernel32.ReadFile(
                self._output_read,
                buffer,
                len(buffer),
                ctypes.byref(read),
                None,
            )
            if ok and read.value:
                self.data_received.emit(buffer.raw[:read.value])
                continue
            if ok:
                continue

            error = ctypes.get_last_error()
            if error in {ERROR_BROKEN_PIPE, ERROR_OPERATION_ABORTED}:
                break
            break

    def _poll_process(self) -> None:
        api = self._api
        if api is None or not self._process.value:
            return
        result = api.kernel32.WaitForSingleObject(self._process, 0)
        if result == WAIT_TIMEOUT:
            return
        if result != WAIT_OBJECT_0:
            return

        exit_code = DWORD(0)
        if api.kernel32.GetExitCodeProcess(
            self._process,
            ctypes.byref(exit_code),
        ):
            self._poll_timer.stop()
            self.process_exited.emit(int(exit_code.value))

    def write(self, data: bytes) -> None:
        api = self._api
        if api is None or not self._input_write.value or not data:
            return

        buffer = ctypes.create_string_buffer(data)
        written = DWORD(0)
        ok = api.kernel32.WriteFile(
            self._input_write,
            buffer,
            len(data),
            ctypes.byref(written),
            None,
        )
        if not ok:
            error = ctypes.get_last_error()
            if error not in {ERROR_BROKEN_PIPE, ERROR_OPERATION_ABORTED}:
                raise api._last_error("WriteFile(ConPTY input)")

    def resize(self, rows: int, columns: int) -> None:
        api = self._api
        if api is None or not self._hpc.value:
            return
        api.require_hr(
            api.kernel32.ResizePseudoConsole(
                self._hpc,
                _coord(rows=rows, columns=columns),
            ),
            "ResizePseudoConsole",
        )

    def shutdown(self) -> None:
        self._poll_timer.stop()
        api = self._api
        if api is None:
            return

        self._closing.set()

        if self._hpc.value:
            api.kernel32.ClosePseudoConsole(self._hpc)
            self._hpc = HANDLE()

        if self._reader is not None and self._reader.is_alive():
            self._reader.join(timeout=0.5)

        api.close_handle(self._input_write)
        api.close_handle(self._output_read)
        api.close_handle(self._process)
        self._input_write = HANDLE()
        self._output_read = HANDLE()
        self._process = HANDLE()
        self._api = None
