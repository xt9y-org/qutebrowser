# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for native terminal workspace transports."""

import os

import pytest

from qutebrowser.browser import terminal


def test_default_shell_posix_prefers_shell_env(monkeypatch):
    monkeypatch.setenv("SHELL", "/bin/zsh")

    assert terminal.default_shell(platform_name="posix") == ["/bin/zsh"]


def test_default_shell_posix_falls_back(monkeypatch):
    monkeypatch.delenv("SHELL", raising=False)

    assert terminal.default_shell(platform_name="posix") == ["/bin/sh"]


def test_default_shell_windows_prefers_comspec(monkeypatch):
    monkeypatch.setenv("COMSPEC", r"C:\Windows\System32\cmd.exe")

    assert terminal.default_shell(platform_name="nt") == [
        r"C:\Windows\System32\cmd.exe"
    ]


def test_default_shell_windows_falls_back(monkeypatch):
    monkeypatch.delenv("COMSPEC", raising=False)

    assert terminal.default_shell(platform_name="nt") == ["cmd.exe"]


def test_backend_factory():
    assert isinstance(
        terminal.create_backend(platform_name="posix"),
        terminal.UnixPtyBackend,
    )
    assert isinstance(
        terminal.create_backend(platform_name="nt"),
        terminal.WinConPtyBackend,
    )


def test_backend_factory_rejects_unknown_platform():
    with pytest.raises(ValueError, match="Unsupported terminal platform"):
        terminal.create_backend(platform_name="plan9")


def test_terminal_spec_defaults(tmp_path):
    spec = terminal.TerminalSpec(cwd=tmp_path)

    assert spec.cwd == tmp_path
    assert spec.command == terminal.default_shell()
    assert spec.columns == 80
    assert spec.rows == 24
    assert spec.env is None


def test_terminal_spec_copies_command(tmp_path):
    command = ["sh", "-l"]
    spec = terminal.TerminalSpec(cwd=tmp_path, command=command)
    command.append("ignored")

    assert spec.command == ["sh", "-l"]


def test_terminal_spec_rejects_invalid_size(tmp_path):
    with pytest.raises(ValueError, match="positive"):
        terminal.TerminalSpec(cwd=tmp_path, columns=0)

    with pytest.raises(ValueError, match="positive"):
        terminal.TerminalSpec(cwd=tmp_path, rows=-1)


def test_terminal_spec_expands_environment(tmp_path):
    spec = terminal.TerminalSpec(cwd=tmp_path, env={"TERM": "xterm-256color"})
    env = spec.environment()

    assert env["TERM"] == "xterm-256color"
    assert env["COLORTERM"] == "truecolor"
    assert env["TERM_PROGRAM"] == "qutebrowser"
    for key, value in os.environ.items():
        if key not in {"TERM", "COLORTERM", "TERM_PROGRAM"}:
            assert env[key] == value


def test_emulator_feed_and_cursor():
    emulator = terminal.TerminalEmulator(columns=8, rows=3)

    emulator.feed(b"abc")

    assert emulator.display[0] == "abc     "
    assert emulator.cursor == (3, 0)


def test_emulator_handles_ansi_cursor_motion():
    emulator = terminal.TerminalEmulator(columns=8, rows=3)

    emulator.feed(b"abc\x1b[2DXY")

    assert emulator.display[0] == "aXY     "


def test_emulator_resize():
    emulator = terminal.TerminalEmulator(columns=8, rows=3)
    emulator.feed(b"abc")

    emulator.resize(columns=12, rows=5)

    assert emulator.columns == 12
    assert emulator.rows == 5
    assert len(emulator.display) == 5
    assert all(len(line) == 12 for line in emulator.display)


def test_emulator_rejects_invalid_size():
    with pytest.raises(ValueError, match="positive"):
        terminal.TerminalEmulator(columns=0, rows=24)

    emulator = terminal.TerminalEmulator(columns=80, rows=24)
    with pytest.raises(ValueError, match="positive"):
        emulator.resize(columns=80, rows=0)
