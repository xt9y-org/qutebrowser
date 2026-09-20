# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""QtWebEngine WebAuth/passkey user interaction handling."""

from __future__ import annotations

import dataclasses
from typing import Any, Callable

from qutebrowser.qt.widgets import QApplication, QInputDialog, QLineEdit, QMessageBox
from qutebrowser.utils import log


@dataclasses.dataclass(frozen=True)
class PinInfo:
    """Non-secret information for a WebAuth PIN prompt."""

    reason: str
    error: str
    min_length: int
    remaining_attempts: int


def _enum_name(value: Any) -> str:
    name = getattr(value, "name", None)
    if isinstance(name, str):
        return name
    return str(value).rsplit(".", maxsplit=1)[-1]


def _qt_value(obj: Any, name: str) -> Any:
    value = getattr(obj, name)
    return value() if callable(value) else value


def _once(callback: Callable[[], None]) -> Callable[[], None]:
    """Return a callback which invokes *callback* at most once."""
    called = False

    def wrapper() -> None:
        nonlocal called
        if called:
            return
        called = True
        callback()

    return wrapper


class QtWebAuthUi:
    """Non-blocking Qt widgets used by :class:`WebAuthHandler`."""

    def __init__(self, parent=None):
        self._parent = parent
        self._dialog = None

    def _dialog_parent(self):
        if self._parent is not None:
            return self._parent
        return QApplication.activeWindow()

    def _replace_dialog(self, dialog) -> None:
        self.close()
        self._dialog = dialog
        dialog.setModal(False)
        dialog.show()
        dialog.raise_()
        dialog.activateWindow()

    def close(self) -> None:
        dialog = self._dialog
        self._dialog = None
        if dialog is None:
            return
        dialog.blockSignals(True)
        dialog.close()
        dialog.deleteLater()

    def select_account(
        self, *, relying_party: str, accounts: list[str],
        on_select: Callable[[str], None], on_cancel: Callable[[], None],
    ) -> None:
        dialog = QInputDialog(self._dialog_parent())
        dialog.setWindowTitle("Choose passkey")
        dialog.setLabelText(f"Choose an account for {relying_party}:")
        dialog.setComboBoxItems(accounts)
        dialog.setComboBoxEditable(False)
        dialog.accepted.connect(lambda: on_select(dialog.textValue()))
        dialog.rejected.connect(on_cancel)
        self._replace_dialog(dialog)

    def collect_pin(
        self, *, relying_party: str, info: PinInfo,
        on_submit: Callable[[str], None], on_cancel: Callable[[], None],
    ) -> None:
        dialog = QInputDialog(self._dialog_parent())
        dialog.setWindowTitle("Passkey PIN")
        details = [f"Enter the authenticator PIN for {relying_party}."]
        if info.reason == "Set":
            details[0] = f"Set a new authenticator PIN for {relying_party}."
        elif info.reason == "Change":
            details[0] = f"Change the authenticator PIN for {relying_party}."
        if info.error != "NoError":
            details.append(f"Previous attempt: {info.error}.")
        if info.min_length > 0:
            details.append(f"Minimum length: {info.min_length}.")
        if info.reason == "Challenge" and info.remaining_attempts >= 0:
            details.append(f"Attempts remaining: {info.remaining_attempts}.")
        dialog.setLabelText("\n".join(details))
        dialog.setTextEchoMode(QLineEdit.EchoMode.Password)
        dialog.accepted.connect(lambda: on_submit(dialog.textValue()))
        dialog.rejected.connect(on_cancel)
        self._replace_dialog(dialog)

    def finish_token_collection(
        self, *, relying_party: str, on_cancel: Callable[[], None],
    ) -> None:
        dialog = QMessageBox(self._dialog_parent())
        dialog.setWindowTitle("Verify passkey")
        dialog.setIcon(QMessageBox.Icon.Information)
        dialog.setText(
            f"Complete verification for {relying_party} on your authenticator "
            "(for example, touch the security key or use platform biometrics)."
        )
        dialog.setStandardButtons(QMessageBox.StandardButton.Cancel)
        cancel_once = _once(on_cancel)
        dialog.rejected.connect(cancel_once)
        dialog.buttonClicked.connect(lambda _button: cancel_once())
        self._replace_dialog(dialog)

    def request_failed(
        self, *, relying_party: str, reason: str,
        on_retry: Callable[[], None], on_cancel: Callable[[], None],
    ) -> None:
        dialog = QMessageBox(self._dialog_parent())
        dialog.setWindowTitle("Passkey request failed")
        dialog.setIcon(QMessageBox.Icon.Warning)
        dialog.setText(f"Passkey request for {relying_party} failed: {reason}.")
        dialog.setStandardButtons(
            QMessageBox.StandardButton.Retry | QMessageBox.StandardButton.Cancel)
        retry_once = _once(on_retry)
        cancel_once = _once(on_cancel)

        def clicked(button) -> None:
            if dialog.standardButton(button) == QMessageBox.StandardButton.Retry:
                retry_once()
            else:
                cancel_once()

        dialog.buttonClicked.connect(clicked)
        dialog.rejected.connect(cancel_once)
        self._replace_dialog(dialog)


class WebAuthHandler:
    """Translate QWebEngine WebAuth UX states into user interaction."""

    def __init__(self, *, ui=None):
        self._ui = QtWebAuthUi() if ui is None else ui
        self.request = None

    def handle_request(self, request) -> None:
        """Start handling a newly emitted QWebEngine WebAuth UX request."""
        if self.request is not None and self.request is not request:
            try:
                self.request.cancel()
            except RuntimeError:
                pass
            self._ui.close()

        self.request = request
        request.stateChanged.connect(
            lambda state, current=request: self._on_state_changed(current, state))
        self._on_state_changed(request, request.state())

    def abort(self) -> None:
        """Cancel the active request, if any, and dispose its UI."""
        request = self.request
        self.request = None
        self._ui.close()
        if request is not None:
            try:
                request.cancel()
            except RuntimeError:
                # The underlying QWebEngine request can disappear with its page.
                pass

    def _is_active(self, request) -> bool:
        return request is self.request

    def _cancel(self, request) -> None:
        if self._is_active(request):
            request.cancel()

    def _select_account(self, request, account: str) -> None:
        if self._is_active(request):
            request.setSelectedAccount(account)

    def _submit_pin(self, request, pin: str) -> None:
        # Deliberately never store or log the PIN.
        if self._is_active(request):
            request.setPin(pin)

    def _retry(self, request) -> None:
        if self._is_active(request):
            request.retry()

    def _on_state_changed(self, request, state) -> None:
        if not self._is_active(request):
            return

        state_name = _enum_name(state)
        relying_party = str(_qt_value(request, "relyingPartyId"))

        if state_name == "NotStarted":
            self._ui.close()
        elif state_name == "SelectAccount":
            accounts = list(_qt_value(request, "userNames"))
            self._ui.select_account(
                relying_party=relying_party,
                accounts=accounts,
                on_select=lambda account: self._select_account(request, account),
                on_cancel=lambda: self._cancel(request),
            )
        elif state_name == "CollectPin":
            pin_request = _qt_value(request, "pinRequest")
            info = PinInfo(
                reason=_enum_name(_qt_value(pin_request, "reason")),
                error=_enum_name(_qt_value(pin_request, "error")),
                min_length=int(_qt_value(pin_request, "minPinLength")),
                remaining_attempts=int(_qt_value(pin_request, "remainingAttempts")),
            )
            self._ui.collect_pin(
                relying_party=relying_party,
                info=info,
                on_submit=lambda pin: self._submit_pin(request, pin),
                on_cancel=lambda: self._cancel(request),
            )
        elif state_name == "FinishTokenCollection":
            self._ui.finish_token_collection(
                relying_party=relying_party,
                on_cancel=lambda: self._cancel(request),
            )
        elif state_name == "RequestFailed":
            reason = _enum_name(_qt_value(request, "requestFailureReason"))
            self._ui.request_failed(
                relying_party=relying_party,
                reason=reason,
                on_retry=lambda: self._retry(request),
                on_cancel=lambda: self._cancel(request),
            )
        elif state_name in {"Cancelled", "Completed"}:
            self.request = None
            self._ui.close()
        else:
            log.webview.error("Unknown WebAuth UX state: %s", state_name)
            self.abort()
