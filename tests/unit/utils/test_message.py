from qutebrowser.utils import message, usertypes


def test_ask_async_returns_question(mocker):
    bridge = mocker.patch.object(message.global_bridge, 'ask')

    question = message.ask_async(
        'PIN',
        mode=usertypes.PromptMode.text,
        handler=lambda _answer: None,
    )

    assert isinstance(question, usertypes.Question)
    bridge.assert_called_once_with(question, blocking=False)
