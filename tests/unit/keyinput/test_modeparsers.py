# SPDX-FileCopyrightText: Freya Bruhin (The Compiler) <mail@qutebrowser.org>:
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for mode parsers."""

from types import SimpleNamespace

import pytest

from qutebrowser.qt.core import Qt
from qutebrowser.qt.gui import QKeySequence

from qutebrowser.keyinput import modeparsers, keyutils
from qutebrowser.config import configexc


@pytest.fixture
def commandrunner(stubs):
    return stubs.FakeCommandRunner()


class ExplodingCommandRunner:

    def run(self, _cmdstr, _count):
        raise ValueError("boom")


def test_command_error_is_contained_for_native_workspace(
    monkeypatch, key_config_stub
):
    tab = SimpleNamespace(is_native_workspace_tab=True)
    browser = SimpleNamespace(
        widget=SimpleNamespace(currentWidget=lambda: tab),
    )
    errors = []
    monkeypatch.setattr(
        modeparsers.objreg,
        "get",
        lambda *_args, **_kwargs: browser,
    )
    monkeypatch.setattr(
        modeparsers.message,
        "error",
        lambda text, **_kwargs: errors.append(text),
    )
    parser = modeparsers.CommandKeyParser(
        mode=modeparsers.usertypes.KeyMode.normal,
        win_id=1,
        commandrunner=ExplodingCommandRunner(),
    )

    parser.execute("hint")

    assert errors == ["Command 'hint' is not available in this workspace."]


def test_command_error_still_propagates_for_web_tab(
    monkeypatch, key_config_stub
):
    tab = SimpleNamespace(is_native_workspace_tab=False)
    browser = SimpleNamespace(
        widget=SimpleNamespace(currentWidget=lambda: tab),
    )
    monkeypatch.setattr(
        modeparsers.objreg,
        "get",
        lambda *_args, **_kwargs: browser,
    )
    parser = modeparsers.CommandKeyParser(
        mode=modeparsers.usertypes.KeyMode.normal,
        win_id=1,
        commandrunner=ExplodingCommandRunner(),
    )

    with pytest.raises(ValueError, match="boom"):
        parser.execute("hint")


class TestsNormalKeyParser:

    @pytest.fixture(autouse=True)
    def patch_stuff(self, monkeypatch, stubs, keyinput_bindings):
        """Set up mocks and read the test config."""
        monkeypatch.setattr(
            'qutebrowser.keyinput.basekeyparser.usertypes.Timer',
            stubs.FakeTimer)

    @pytest.fixture
    def keyparser(self, commandrunner):
        kp = modeparsers.NormalKeyParser(win_id=0, commandrunner=commandrunner)
        return kp

    def test_keychain(self, keyparser, commandrunner):
        """Test valid keychain."""
        # Press 'z' which is ignored because of no match
        # Then start the real chain
        chain = keyutils.KeySequence.parse('zba')
        for info in chain:
            keyparser.handle(info.to_event())
        assert commandrunner.commands == [('message-info ba', None)]
        assert not keyparser._sequence

    def test_partial_keychain_timeout(self, keyparser, config_stub,
                                      qtbot, commandrunner):
        """Test partial keychain timeout."""
        config_stub.val.input.partial_timeout = 100
        timer = keyparser._partial_timer
        assert not timer.isActive()

        # Press 'b' for a partial match.
        # Then we check if the timer has been set up correctly
        keyparser.handle(keyutils.KeyInfo(Qt.Key.Key_B, Qt.KeyboardModifier.NoModifier).to_event())
        assert timer.isSingleShot()
        assert timer.interval() == 100
        assert timer.isActive()

        assert not commandrunner.commands
        assert keyparser._sequence == keyutils.KeySequence.parse('b')

        # Now simulate a timeout and check the keystring has been cleared.
        with qtbot.wait_signal(keyparser.keystring_updated) as blocker:
            timer.timeout.emit()

        assert not commandrunner.commands
        assert not keyparser._sequence
        assert blocker.args == ['']


class TestHintKeyParser:

    @pytest.fixture
    def hintmanager(self, stubs):
        return stubs.FakeHintManager()

    @pytest.fixture
    def keyparser(self, config_stub, key_config_stub, commandrunner,
                  hintmanager):
        return modeparsers.HintKeyParser(win_id=0,
                                         hintmanager=hintmanager,
                                         commandrunner=commandrunner)

    @pytest.mark.parametrize('bindings, keychain, prefix, hint', [
        (
            ['aa', 'as'],
            'as',
            'a',
            'as'
        ),
        (
            ['21', '22'],
            '<Num+2><Num+2>',
            '2',
            '22'
        ),
        (
            ['äa', 'äs'],
            'äs',
            'ä',
            'äs'
        ),
        (
            ['не', 'на'],
            'не',
            '<Н>',
            'не',
        ),
    ])
    def test_match(self, keyparser, hintmanager,
                   bindings, keychain, prefix, hint, pyqt_enum_workaround):
        with pyqt_enum_workaround(keyutils.KeyParseError):
            keyparser.update_bindings(bindings)

        seq = keyutils.KeySequence.parse(keychain)
        assert len(seq) == 2

        # pylint: disable-next=no-member
        match = keyparser.handle(seq[0].to_event())
        assert match == QKeySequence.SequenceMatch.PartialMatch
        assert hintmanager.keystr == prefix

        # pylint: disable-next=no-member
        match = keyparser.handle(seq[1].to_event())
        assert match == QKeySequence.SequenceMatch.ExactMatch
        assert hintmanager.keystr == hint

    def test_match_key_mappings(self, config_stub, keyparser, hintmanager,
                                pyqt_enum_workaround):
        with pyqt_enum_workaround(configexc.ValidationError):
            config_stub.val.bindings.key_mappings = {'α': 'a', 'σ': 's'}
        keyparser.update_bindings(['aa', 'as'])

        seq = keyutils.KeySequence.parse('ασ')
        assert len(seq) == 2

        # pylint: disable-next=no-member
        match = keyparser.handle(seq[0].to_event())
        assert match == QKeySequence.SequenceMatch.PartialMatch
        assert hintmanager.keystr == 'a'

        # pylint: disable-next=no-member
        match = keyparser.handle(seq[1].to_event())
        assert match == QKeySequence.SequenceMatch.ExactMatch
        assert hintmanager.keystr == 'as'

    def test_command(self, keyparser, config_stub, hintmanager, commandrunner):
        config_stub.val.bindings.commands = {
            'hint': {'abc': 'message-info abc'}
        }

        keyparser.update_bindings(['xabcy'])

        steps = [
            (Qt.Key.Key_X, QKeySequence.SequenceMatch.PartialMatch, 'x'),
            (Qt.Key.Key_A, QKeySequence.SequenceMatch.PartialMatch, ''),
            (Qt.Key.Key_B, QKeySequence.SequenceMatch.PartialMatch, ''),
            (Qt.Key.Key_C, QKeySequence.SequenceMatch.ExactMatch, ''),
        ]
        for key, expected_match, keystr in steps:
            info = keyutils.KeyInfo(key, Qt.KeyboardModifier.NoModifier)
            match = keyparser.handle(info.to_event())
            assert match == expected_match
            assert hintmanager.keystr == keystr
            if key != Qt.Key.Key_C:
                assert not commandrunner.commands

        assert commandrunner.commands == [('message-info abc', None)]
