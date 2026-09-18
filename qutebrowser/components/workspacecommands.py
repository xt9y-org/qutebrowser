# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Workspace-aware command extensions."""

from qutebrowser.api import cmdutils
from qutebrowser.browser import workspace
from qutebrowser.completion.models import urlmodel
from qutebrowser.misc import objects
from qutebrowser.utils import objreg


def _register_workspace_open() -> None:
    """Replace the stock :open command with a workspace-aware wrapper."""
    if "open" not in objects.commands:
        return

    objects.commands.pop("open")

    @cmdutils.register(name="open", maxsplit=0)
    @cmdutils.argument("url", completion=urlmodel.url)
    @cmdutils.argument("count", value=cmdutils.Value.count)
    @cmdutils.argument("win_id", value=cmdutils.Value.win_id)
    def workspace_open(
        url=None,
        related=False,
        bg=False,
        tab=False,
        window=False,
        count=None,
        secure=False,
        private=False,
        win_id=None,
    ):
        """Open browser, terminal, or filesystem workspace content.

        Existing :open flags keep their original meaning. Application selectors
        choose the content type: -at for terminal, -ab for browser, and -af for
        filesystem.

        Args:
            url: The URL to open for browser content.
            related: Position a newly opened tab as related to the current one.
            bg: Open in a new background tab.
            tab: Open in a new tab.
            window: Open in a new window.
            count: The tab index to open the URL in, or None.
            secure: Force HTTPS for browser content.
            private: Open a new private window.
            win_id: The current qutebrowser window ID.
        """
        command = objects.commands["open"]
        content_kind = workspace.selected_content_kind(command.namespace)

        dispatcher = objreg.get(
            "command-dispatcher",
            scope="window",
            window=win_id,
            from_command=True,
        )

        if content_kind is workspace.ContentKind.BROWSER:
            return dispatcher.openurl(
                url=url,
                related=related,
                bg=bg,
                tab=tab,
                window=window,
                count=count,
                secure=secure,
                private=private,
            )

        raise cmdutils.CommandError(
            "{} workspace tabs are not connected yet.".format(
                content_kind.value.capitalize()
            )
        )

    workspace.add_application_selector_arguments(objects.commands["open"].parser)


_register_workspace_open()
