import enum

from qutebrowser.browser.webengine import webauth
from qutebrowser.utils import usertypes


class Signal:

    def __init__(self):
        self.handlers = []

    def connect(self, handler):
        self.handlers.append(handler)

    def emit(self, value=None):
        for handler in list(self.handlers):
            if value is None:
                handler()
            else:
                handler(value)


class State(enum.Enum):
    NotStarted = 0
    SelectAccount = 1
    CollectPin = 2
    FinishTokenCollection = 3
    RequestFailed = 4
    Cancelled = 5
    Completed = 6


class Pin:

    def reason(self):
        return enum.Enum('Reason', {'Challenge': 2}).Challenge

    def error(self):
        return enum.Enum('Error', {'WrongPin': 2}).WrongPin

    def minPinLength(self):
        return 6

    def remainingAttempts(self):
        return 2


class Request:

    def __init__(self, state, users=()):
        self._state = state
        self._users = list(users)
        self.stateChanged = Signal()
        self.selected = None
        self.pin = None
        self.cancelled = False
        self.retried = False

    def state(self):
        return self._state

    def userNames(self):
        return self._users

    def relyingPartyId(self):
        return 'example.com'

    def pinRequest(self):
        return Pin()

    def requestFailureReason(self):
        return enum.Enum('Failure', {'Timeout': 0}).Timeout

    def setSelectedAccount(self, account):
        self.selected = account

    def setPin(self, pin):
        self.pin = pin

    def retry(self):
        self.retried = True

    def cancel(self):
        self.cancelled = True


class Question:

    def __init__(self):
        self.cancelled = Signal()
        self.aborted = Signal()


def test_single_account_selected_without_prompt(mocker):
    ask = mocker.patch.object(webauth.message, 'ask_async')
    request = Request(State.SelectAccount, users=['felix@example.com'])

    webauth.WebAuthHandler().handle(request)

    assert request.selected == 'felix@example.com'
    ask.assert_not_called()


def test_pin_uses_masked_prompt(mocker):
    question = Question()
    ask = mocker.patch.object(webauth.message, 'ask_async', return_value=question)
    request = Request(State.CollectPin)

    webauth.WebAuthHandler().handle(request)

    assert ask.call_args.kwargs['mode'] == usertypes.PromptMode.password
    assert '6' in ask.call_args.kwargs['text']
    ask.call_args.kwargs['handler']('123456')
    assert request.pin == '123456'


def test_abort_cancels_request(mocker):
    question = Question()
    mocker.patch.object(webauth.message, 'ask_async', return_value=question)
    request = Request(State.CollectPin)
    handler = webauth.WebAuthHandler()
    handler.handle(request)

    question.aborted.emit()

    assert request.cancelled


def test_token_collection_shows_touch_message(mocker):
    info = mocker.patch.object(webauth.message, 'info')

    webauth.WebAuthHandler().handle(Request(State.FinishTokenCollection))

    assert 'security key' in info.call_args.args[0].lower()


def test_failure_can_retry(mocker):
    question = Question()
    confirm = mocker.patch.object(webauth.message, 'confirm_async', return_value=question)
    request = Request(State.RequestFailed)

    webauth.WebAuthHandler().handle(request)

    confirm.call_args.kwargs['yes_action']()
    assert request.retried
