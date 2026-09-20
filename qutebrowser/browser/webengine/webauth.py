"""WebAuthn/passkey UX integration for QtWebEngine."""

import html
from typing import Any

from qutebrowser.utils import message, usertypes


_REPLACE_ID = 'webauth'


class WebAuthHandler:

    """Drive QWebEngineWebAuthUxRequest using qutebrowser prompts."""

    def __init__(self) -> None:
        self._request: Any | None = None
        self._question: usertypes.Question | None = None

    def handle(self, request: Any) -> None:
        if self._request is not None and self._request is not request:
            self.cancel()
        self._request = request
        request.stateChanged.connect(self._on_state_changed)
        self._on_state_changed(request.state())

    def cancel(self) -> None:
        request = self._request
        self._request = None
        self._question = None
        if request is not None:
            request.cancel()

    def _on_state_changed(self, state: Any) -> None:
        request = self._request
        if request is None:
            return
        state_name = state.name
        if state_name == 'SelectAccount':
            self._select_account(request)
        elif state_name == 'CollectPin':
            self._collect_pin(request)
        elif state_name == 'FinishTokenCollection':
            message.info(
                'Passkey: touch your security key or complete biometric verification.',
                replace=_REPLACE_ID,
            )
        elif state_name == 'RequestFailed':
            self._request_failed(request)
        elif state_name == 'Cancelled':
            message.info('Passkey request cancelled.', replace=_REPLACE_ID)
            self._request = None
            self._question = None
        elif state_name == 'Completed':
            message.info('Passkey request completed.', replace=_REPLACE_ID)
            self._request = None
            self._question = None

    def _track_question(self, question: usertypes.Question | None) -> None:
        self._question = question
        if question is None:
            return
        question.cancelled.connect(self.cancel)
        question.aborted.connect(self.cancel)

    def _select_account(self, request: Any) -> None:
        active_request: Any = request
        users = list(request.userNames())
        if not users:
            request.cancel()
            return
        if len(users) == 1:
            request.setSelectedAccount(users[0])
            return

        choices = '<br/>'.join(
            f'{index + 1}. <b>{html.escape(user)}</b>'
            for index, user in enumerate(users)
        )

        def selected(answer: Any) -> None:
            if active_request is not self._request:
                return
            if answer in users:
                active_request.setSelectedAccount(answer)
                return
            try:
                index = int(answer) - 1
            except (TypeError, ValueError):
                index = -1
            if 0 <= index < len(users):
                active_request.setSelectedAccount(users[index])
            else:
                message.error('Unknown passkey account; request cancelled.')
                self.cancel()

        question = message.ask_async(
            'Choose passkey account',
            mode=usertypes.PromptMode.text,
            handler=selected,
            default=users[0],
            text=f'Passkey for <b>{html.escape(request.relyingPartyId())}</b><br/>{choices}',
        )
        self._track_question(question)

    def _collect_pin(self, request: Any) -> None:
        active_request: Any = request
        pin_request = request.pinRequest()
        details = []
        min_length = pin_request.minPinLength()
        remaining = pin_request.remainingAttempts()
        error_name = pin_request.error().name

        if min_length:
            details.append(f'Minimum length: {min_length}')
        if remaining >= 0:
            details.append(f'Remaining attempts: {remaining}')
        if error_name not in {'NoError', 'None_'}:
            details.append(f'Previous attempt: {html.escape(error_name)}')

        detail_text = '<br/>'.join(details)
        text = f'Enter the PIN for <b>{html.escape(request.relyingPartyId())}</b>.'
        if detail_text:
            text += f'<br/>{detail_text}'

        def entered(pin: Any) -> None:
            if active_request is self._request and pin is not None:
                active_request.setPin(str(pin))

        question = message.ask_async(
            'Passkey PIN',
            mode=usertypes.PromptMode.password,
            handler=entered,
            text=text,
        )
        self._track_question(question)

    def _request_failed(self, request: Any) -> None:
        active_request: Any = request
        reason = html.escape(request.requestFailureReason().name)

        def retry() -> None:
            if active_request is self._request:
                active_request.retry()

        def cancel() -> None:
            if active_request is self._request:
                self.cancel()

        question = message.confirm_async(
            title='Passkey request failed',
            text=f'{reason}. Retry the passkey request?',
            yes_action=retry,
            no_action=cancel,
            cancel_action=cancel,
        )
        self._track_question(question)
