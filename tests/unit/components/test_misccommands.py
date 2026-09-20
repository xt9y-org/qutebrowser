# SPDX-FileCopyrightText: Freya Bruhin (The Compiler) <mail@qutebrowser.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for qutebrowser.components.misccommands."""

import signal
import contextlib
import time

import pytest

from qutebrowser.api import cmdutils, message
from qutebrowser.utils import utils
from qutebrowser.components import misccommands


@contextlib.contextmanager
def _trapped_segv(handler):
    """Temporarily install given signal handler for SIGSEGV."""
    old_handler = signal.signal(signal.SIGSEGV, handler)
    yield
    if old_handler is not None:
        signal.signal(signal.SIGSEGV, old_handler)


def test_debug_crash_exception():
    """Verify that debug_crash crashes as intended."""
    with pytest.raises(Exception, match="Forced crash"):
        misccommands.debug_crash(typ='exception')


@pytest.mark.skipif(utils.is_windows,
                    reason="current CPython/win can't recover from SIGSEGV")
def test_debug_crash_segfault():
    """Verify that debug_crash crashes as intended."""
    caught = False

    def _handler(num, frame):
        """Temporary handler for segfault."""
        nonlocal caught
        caught = num == signal.SIGSEGV

    with _trapped_segv(_handler):
        # since we handle the segfault, execution will continue and run into
        # the "Segfault failed (wat.)" Exception
        with pytest.raises(Exception, match="Segfault failed"):
            misccommands.debug_crash(typ='segfault')
        time.sleep(0.001)
    assert caught


def test_debug_trace(mocker):
    """Check if hunter.trace is properly called."""
    # but only if hunter is available
    pytest.importorskip('hunter')
    hunter_mock = mocker.patch.object(misccommands, 'hunter')
    misccommands.debug_trace(1)
    hunter_mock.trace.assert_called_with(1)


def test_debug_trace_exception(mocker):
    """Check that exceptions thrown by hunter.trace are handled."""
    def _mock_exception():
        """Side effect for testing debug_trace's reraise."""
        raise Exception('message')  # pylint: disable=broad-exception-raised

    hunter_mock = mocker.patch.object(misccommands, 'hunter')
    hunter_mock.trace.side_effect = _mock_exception
    with pytest.raises(cmdutils.CommandError, match='Exception: message'):
        misccommands.debug_trace()


def test_debug_trace_no_hunter(monkeypatch):
    """Test that an error is shown if debug_trace is called without hunter."""
    monkeypatch.setattr(misccommands, 'hunter', None)
    with pytest.raises(cmdutils.CommandError, match="You need to install "
                       "'hunter' to use this command!"):
        misccommands.debug_trace()


class _FakeUpdateSignal:

    def __init__(self):
        self.callback = None

    def connect(self, callback):
        self.callback = callback

    def emit(self, *args):
        assert self.callback is not None
        self.callback(*args)


class _FakeUpdateClient:

    instances = []

    def __init__(self):
        self.update_available = _FakeUpdateSignal()
        self.up_to_date = _FakeUpdateSignal()
        self.staged = _FakeUpdateSignal()
        self.error = _FakeUpdateSignal()
        self.check_only = None
        self.staged_update = None
        self.instances.append(self)

    def start(self, *, check_only=False):
        self.check_only = check_only


@pytest.fixture(autouse=True)
def reset_update_client(monkeypatch):
    monkeypatch.setattr(misccommands, '_update_client', None)
    _FakeUpdateClient.instances.clear()


def test_update_check(monkeypatch, mocker):
    monkeypatch.setattr(misccommands.autoupdate, 'ForkUpdateClient', _FakeUpdateClient)
    info = mocker.patch.object(message, 'info')

    misccommands.update(check=True)

    client = _FakeUpdateClient.instances[-1]
    assert client.check_only is True
    assert misccommands._update_client is client

    client.update_available.emit('v3.7.0-xt9y.8')

    info.assert_called_once_with('Update available: v3.7.0-xt9y.8.')
    assert misccommands._update_client is None


def test_update_staged(monkeypatch, mocker):
    monkeypatch.setattr(misccommands.autoupdate, 'ForkUpdateClient', _FakeUpdateClient)
    info = mocker.patch.object(message, 'info')
    staged_update = object()
    quitter = mocker.Mock()
    quitter.update_and_restart.return_value = True
    monkeypatch.setattr(misccommands.quitter, 'instance', quitter)

    misccommands.update()

    client = _FakeUpdateClient.instances[-1]
    assert client.check_only is False
    client.update_available.emit('v3.7.0-xt9y.8')
    client.staged_update = staged_update
    client.staged.emit('v3.7.0-xt9y.8', '/tmp/qutebrowser-update/package.dmg')

    assert info.call_args_list == [
        mocker.call(
            'Update available: v3.7.0-xt9y.8; downloading and verifying it.'),
        mocker.call(
            'Verified update v3.7.0-xt9y.8; installing and restarting.'),
    ]
    quitter.update_and_restart.assert_called_once_with(staged_update)
    quitter.shutdown.assert_called_once_with(is_restart=True)
    assert misccommands._update_client is None


def test_update_does_not_quit_when_handoff_fails(monkeypatch, mocker):
    monkeypatch.setattr(misccommands.autoupdate, 'ForkUpdateClient', _FakeUpdateClient)
    error = mocker.patch.object(message, 'error')
    quitter = mocker.Mock()
    quitter.update_and_restart.return_value = False
    monkeypatch.setattr(misccommands.quitter, 'instance', quitter)

    misccommands.update()
    client = _FakeUpdateClient.instances[-1]
    client.staged_update = object()
    client.staged.emit('v3.7.0-xt9y.8', '/tmp/qutebrowser-update/package.dmg')

    error.assert_called_once_with(
        'Could not start the post-exit updater; qutebrowser was not closed.')
    quitter.shutdown.assert_not_called()
    assert misccommands._update_client is None


def test_update_error(monkeypatch, mocker):
    monkeypatch.setattr(misccommands.autoupdate, 'ForkUpdateClient', _FakeUpdateClient)
    error = mocker.patch.object(message, 'error')

    misccommands.update()
    client = _FakeUpdateClient.instances[-1]
    client.error.emit('No packaged build metadata found.')

    error.assert_called_once_with('No packaged build metadata found.')
    assert misccommands._update_client is None


def test_update_prevents_overlap(monkeypatch, mocker):
    monkeypatch.setattr(misccommands.autoupdate, 'ForkUpdateClient', _FakeUpdateClient)
    warning = mocker.patch.object(message, 'warning')

    misccommands.update()
    misccommands.update()

    assert len(_FakeUpdateClient.instances) == 1
    warning.assert_called_once_with('An update check is already running.')
