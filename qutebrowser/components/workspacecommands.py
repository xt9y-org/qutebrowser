# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Workspace-aware command extensions."""

from qutebrowser.api import cmdutils
from qutebrowser.browser import workspace
from qutebrowser.completion.models import urlmodel
from qutebrowser.mainwindow import mainwindow
from qutebrowser.misc import objects
from qutebrowser.utils import objreg


def _open_filesystem(
    *,
    tabbed_browser,
    path,
    related,
    bg,
    tab,
    window,
    count,
    secure,
    private,
):
    """Open a native filesystem workspace tab."""
    cmdutils.check_exclusive(
        (tab, bg, window, private),
        ("t", "b", "w", "p"),
    )
    if secure:
        raise cmdutils.CommandError(
            "-s/--secure only applies to browser content."
        )
    if count is not None:
        raise cmdutils.CommandError(
            "A tab count is not supported for filesystem content yet."
        )

    filesystem_path = path if path not in (None, "") else None

    if window or private:
        is_private = True if private else tabbed_browser.is_private
        target_window = mainwindow.MainWindow(private=is_private)
        new_tab = target_window.tabbed_browser.workspace_tabopen(
            workspace.ContentKind.FILESYSTEM,
            path=filesystem_path,
            background=False,
            related=related,
        )
        target_window.show()
        return new_tab

    return tabbed_browser.workspace_tabopen(
        workspace.ContentKind.FILESYSTEM,
        path=filesystem_path,
        background=bg,
        related=related,
    )


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
            url: URL for browser content, or path for filesystem content.
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
        tabbed_browser = objreg.get(
            "tabbed-browser",
            scope="window",
            window=win_id,
            from_command=True,
        )

        if content_kind is workspace.ContentKind.BROWSER:
            current = tabbed_browser.widget.currentWidget()
            if (
                isinstance(current, workspace.WorkspaceTab)
                and not any((bg, tab, window, private))
            ):
                tab = True
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

        if content_kind is workspace.ContentKind.FILESYSTEM:
            return _open_filesystem(
                tabbed_browser=tabbed_browser,
                path=url,
                related=related,
                bg=bg,
                tab=tab,
                window=window,
                count=count,
                secure=secure,
                private=private,
            )

        raise cmdutils.CommandError(
            "Terminal workspace tabs are not connected yet."
        )

    workspace.add_application_selector_arguments(objects.commands["open"].parser)


_register_workspace_open()
