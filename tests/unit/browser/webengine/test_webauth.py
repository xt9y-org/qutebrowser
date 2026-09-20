# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for QtWebEngine WebAuth UX handling."""

import enum

from qutebrowser.browser.webengine import webauth


class State(enum.Enum):
    NotStarted = 0
    SelectAccount = 1
    CollectPin = 2
    FinishTokenCollection = 3
    RequestFailed = 4
    Cancelled = 5
    Completed = 6


class Reason(enum.Enum):
    Set = 0
    Change = 1
    Challenge = 2


class PinError(enum.Enum):
    NoError = 0
    WrongPin = 2


class Failure(enum.Enum):
    Timeout = 0
    WinUserCancelled = 12


class Signal:
    def __init__(self):
        self.callback = None

    def connect(self, callback):
        self.callback = callback

    def emit(self, state):
        assert self.callback is not None
        self.callback(state)


class PinRequest:
    def __init__(self):
        self.reason = lambda: Reason.Challenge
        self.error = lambda: PinError.WrongPin
        self.minPinLength = lambda: 6
        self.remainingAttempts = lambda: 3


class Request:
    def __init__(self, state):
        self._state = state
        self.stateChanged = Signal()
        self.cancelled = 0
        self.retried = 0
        self.selected = []
        self.pins = []

    def state(self):
        return self._state

    def relyingPartyId(self):
        return "example.com"

    def userNames(self):
        return ["alice", "bob"]

    def pinRequest(self):
        return PinRequest()

    def requestFailureReason(self):
        return Failure.Timeout

    def cancel(self):
        self.cancelled += 1

    def retry(self):
        self.retried += 1

    def setSelectedAccount(self, account):
        self.selected.append(account)

    def setPin(self, pin):
        self.pins.append(pin)


class Ui:
    def __init__(self):
        self.closed = 0
        self.account = None
        self.pin = None
        self.touch = None
        self.failure = None

    def close(self):
        self.closed += 1

    def select_account(self, *, relying_party, accounts, on_select, on_cancel):
        self.account = (relying_party, accounts, on_select, on_cancel)

    def collect_pin(self, *, relying_party, info, on_submit, on_cancel):
        self.pin = (relying_party, info, on_submit, on_cancel)

    def finish_token_collection(self, *, relying_party, on_cancel):
        self.touch = (relying_party, on_cancel)

    def request_failed(self, *, relying_party, reason, on_retry, on_cancel):
        self.failure = (relying_party, reason, on_retry, on_cancel)


def test_select_account():
    request = Request(State.SelectAccount)
    ui = Ui()
    handler = webauth.WebAuthHandler(ui=ui)

    handler.handle_request(request)

    assert ui.account[:2] == ("example.com", ["alice", "bob"])
    ui.account[2]("bob")
    assert request.selected == ["bob"]


def test_collect_pin_passes_details_without_storing_pin():
    request = Request(State.CollectPin)
    ui = Ui()
    handler = webauth.WebAuthHandler(ui=ui)

    handler.handle_request(request)

    info = ui.pin[1]
    assert info.reason == "Challenge"
    assert info.error == "WrongPin"
    assert info.min_length == 6
    assert info.remaining_attempts == 3
    ui.pin[2]("123456")
    assert request.pins == ["123456"]
    assert not hasattr(handler, "pin")


def test_finish_token_collection_shows_touch_ui():
    request = Request(State.FinishTokenCollection)
    ui = Ui()
    handler = webauth.WebAuthHandler(ui=ui)

    handler.handle_request(request)

    assert ui.touch[0] == "example.com"


def test_failure_can_retry():
    request = Request(State.RequestFailed)
    ui = Ui()
    handler = webauth.WebAuthHandler(ui=ui)

    handler.handle_request(request)

    assert ui.failure[:2] == ("example.com", "Timeout")
    ui.failure[2]()
    assert request.retried == 1


def test_cancel_from_ui_cancels_request():
    request = Request(State.SelectAccount)
    ui = Ui()
    handler = webauth.WebAuthHandler(ui=ui)
    handler.handle_request(request)

    ui.account[3]()

    assert request.cancelled == 1


def test_state_changed_updates_ui_and_completed_closes():
    request = Request(State.NotStarted)
    ui = Ui()
    handler = webauth.WebAuthHandler(ui=ui)
    handler.handle_request(request)

    request.stateChanged.emit(State.SelectAccount)
    assert ui.account is not None

    request.stateChanged.emit(State.Completed)
    assert ui.closed >= 1
    assert handler.request is None


def test_abort_cancels_active_request():
    request = Request(State.CollectPin)
    ui = Ui()
    handler = webauth.WebAuthHandler(ui=ui)
    handler.handle_request(request)

    handler.abort()

    assert request.cancelled == 1
    assert handler.request is None
    assert ui.closed >= 1
