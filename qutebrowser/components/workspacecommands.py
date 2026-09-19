# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Workspace-aware command extensions."""

from qutebrowser.qt.core import QUrl

from qutebrowser.api import cmdutils
from qutebrowser.browser import filesystemcontent, workspace, workspaceterminal
from qutebrowser.completion.models import urlmodel
from qutebrowser.mainwindow import workspacehost
from qutebrowser.misc import objects
from qutebrowser.utils import objreg


def _filesystem_path(value):
    """Turn :open's optional URL argument into a filesystem path."""
    if value is None:
        return None
    if isinstance(value, QUrl):
        if value.isLocalFile():
            return value.toLocalFile()
        return value.toString()
    return value


def _replace_with_workspace(tabbed_browser, content, count=None):
    """Replace the selected/current tab with native workspace content."""
    if count is None:
        idx = tabbed_browser.widget.currentIndex()
    else:
        idx = count - 1
        if idx < 0 or idx >= tabbed_browser.widget.count():
            return None

    old_tab = tabbed_browser.widget.widget(idx) if idx >= 0 else None
    if old_tab is None:
        return tabbed_browser.tabopen_workspace(
            content,
            background=False,
            related=False,
        )

    new_tab = tabbed_browser.tabopen_workspace(
        content,
        background=False,
        related=False,
        idx=idx,
    )
    tabbed_browser._remove_tab(old_tab)
    return new_tab


def _open_workspace_content(
    dispatcher,
    content,
    *,
    related=False,
    bg=False,
    tab=False,
    window=False,
    count=None,
    private=False,
):
    """Apply existing :open destination flags to native workspace content."""
    cmdutils.check_exclusive((tab, bg, window, private), "tbwp")

    tabbed_browser = dispatcher._tabbed_browser
    if window or private:
        private_mode = private or tabbed_browser.is_private
        tabbed_browser = dispatcher._new_tabbed_browser(private_mode)
        result = tabbed_browser.tabopen_workspace(
            content,
            background=False,
            related=related,
        )
        tabbed_browser.window().show()
        return result

    if tab or bg:
        return tabbed_browser.tabopen_workspace(
            content,
            background=bg,
            related=related,
        )

    return _replace_with_workspace(tabbed_browser, content, count=count)


def _open_browser_from_workspace(
    dispatcher,
    *,
    url,
    related,
    bg,
    tab,
    window,
    count,
    secure,
    private,
):
    """Preserve normal :open behavior when the active tab is native content."""
    tabbed_browser = dispatcher._tabbed_browser
    if tab or bg or window or private:
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

    if count is None:
        idx = tabbed_browser.widget.currentIndex()
    else:
        idx = count - 1
        if idx < 0 or idx >= tabbed_browser.widget.count():
            return None

    old_tab = tabbed_browser.widget.widget(idx) if idx >= 0 else None
    if not isinstance(old_tab, workspacehost.WorkspaceTab):
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

    dispatcher.openurl(
        url=url,
        related=related,
        bg=False,
        tab=True,
        window=False,
        count=None,
        secure=secure,
        private=False,
    )
    tabbed_browser._remove_tab(old_tab, add_undo=False)
    return None


def _terminal_cwd(dispatcher, value):
    """Resolve terminal cwd, inheriting it from a filesystem tab when possible."""
    explicit = _filesystem_path(value)
    if explicit is not None:
        return explicit

    current = dispatcher._tabbed_browser.widget.currentWidget()
    if (
        isinstance(current, workspacehost.WorkspaceTab)
        and current.kind is workspace.ContentKind.FILESYSTEM
    ):
        return current.content.path
    return None


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
            url: URL, filesystem path, or application-specific target.
            related: Position a newly opened tab as related to the current one.
            bg: Open in a new background tab.
            tab: Open in a new tab.
            window: Open in a new window.
            count: The tab index to replace/open into, or None.
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
            return _open_browser_from_workspace(
                dispatcher,
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
            try:
                content = filesystemcontent.FilesystemContent(
                    _filesystem_path(url)
                )
            except (OSError, ValueError) as error:
                raise cmdutils.CommandError(str(error))
            return _open_workspace_content(
                dispatcher,
                content,
                related=related,
                bg=bg,
                tab=tab,
                window=window,
                count=count,
                private=private,
            )

        if content_kind is workspace.ContentKind.TERMINAL:
            try:
                content = workspaceterminal.TerminalContent(
                    cwd=_terminal_cwd(dispatcher, url)
                )
            except (OSError, RuntimeError, ValueError) as error:
                raise cmdutils.CommandError(str(error))
            return _open_workspace_content(
                dispatcher,
                content,
                related=related,
                bg=bg,
                tab=tab,
                window=window,
                count=count,
                private=private,
            )

        raise cmdutils.CommandError("Unsupported workspace content type")

    workspace.add_application_selector_arguments(objects.commands["open"].parser)


_register_workspace_open()
