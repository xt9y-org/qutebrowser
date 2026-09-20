# SPDX-FileCopyrightText: Freya Bruhin (The Compiler) <mail@qutebrowser.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for qutebrowser.misc.quitter."""

import pathlib

from qutebrowser import qutebrowser
from qutebrowser.misc import autoupdate, ipc, quitter, sessions


def test_update_and_restart_launches_handoff_before_ipc_shutdown(
        monkeypatch, mocker):
    args = qutebrowser.get_argparser().parse_args([])
    obj = quitter.Quitter(args=args)
    mocker.patch.object(obj, '_compile_modules')
    manager = mocker.Mock()
    monkeypatch.setattr(sessions, 'session_manager', manager)
    save = manager.save
    server = mocker.Mock()
    monkeypatch.setattr(ipc, 'server', server)
    launch = mocker.patch.object(autoupdate, 'launch_update_handoff')
    staged = autoupdate.StagedUpdate(
        package_path=pathlib.Path('/tmp/update.tar.gz'),
        target=autoupdate.PlatformTarget(
            'linux', 'x86_64', autoupdate.InstallKind.linux_standalone),
        staged_root=pathlib.Path('/tmp/payload/qutebrowser'),
    )

    assert obj.update_and_restart(staged)

    save.assert_called_once_with('_restart', with_private=True)
    restart_args = launch.call_args.args[1]
    assert restart_args[-2:] == ['--json-args', mocker.ANY]
    server.shutdown.assert_called_once_with()


def test_update_and_restart_keeps_ipc_alive_if_handoff_fails(
        monkeypatch, mocker):
    args = qutebrowser.get_argparser().parse_args([])
    obj = quitter.Quitter(args=args)
    mocker.patch.object(obj, '_compile_modules')
    manager = mocker.Mock()
    monkeypatch.setattr(sessions, 'session_manager', manager)
    server = mocker.Mock()
    monkeypatch.setattr(ipc, 'server', server)
    mocker.patch.object(quitter.log.destroy, 'exception')
    mocker.patch.object(
        autoupdate, 'launch_update_handoff', side_effect=OSError('boom'))
    staged = autoupdate.StagedUpdate(
        package_path=pathlib.Path('/tmp/update.tar.gz'),
        target=autoupdate.PlatformTarget(
            'linux', 'x86_64', autoupdate.InstallKind.linux_standalone),
        staged_root=pathlib.Path('/tmp/payload/qutebrowser'),
    )

    assert not obj.update_and_restart(staged)
    server.shutdown.assert_not_called()
