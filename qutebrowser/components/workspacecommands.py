# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Workspace-aware command integration."""

from qutebrowser.qt.core import QUrl

from qutebrowser.api import cmdutils
from qutebrowser.browser import filesystemcontent, workspace, workspaceterminal
from qutebrowser.completion.models import urlmodel
from qutebrowser.mainwindow import workspacehost
from qutebrowser.misc import objects


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
    tabbed_browser._remove_tab(old_tab, add_undo=False)
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
        target_browser = dispatcher._new_tabbed_browser(private_mode)
        result = target_browser.tabopen_workspace(
            content,
            background=False,
            related=related,
        )
        target_browser.window().show()
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
    """Preserve normal :open behavior when the selected tab is native content."""
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
            bg=False,
            tab=False,
            window=False,
            count=count,
            secure=secure,
            private=False,
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
    """Resolve cwd, inheriting it from a filesystem tab when possible."""
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


def _clone_workspace_content(tab):
    """Create a fresh adapter carrying the cloneable state of a native tab."""
    if tab.kind is workspace.ContentKind.FILESYSTEM:
        return filesystemcontent.FilesystemContent(tab.content.path)
    if tab.kind is workspace.ContentKind.TERMINAL:
        return workspaceterminal.TerminalContent(
            cwd=tab.content.cwd,
            shell=tab.content.shell,
        )
    raise cmdutils.CommandError("This workspace tab cannot be cloned")


def _register_workspace_open() -> None:
    """Replace stock :open with the workspace-aware dispatcher command."""
    if "open" not in objects.commands:
        return

    objects.commands.pop("open")

    @cmdutils.register(
        name="open",
        maxsplit=0,
        instance="command-dispatcher",
        scope="window",
    )
    @cmdutils.argument("url", completion=urlmodel.url)
    @cmdutils.argument("count", value=cmdutils.Value.count)
    @cmdutils.argument("application_terminal", flag="at")
    @cmdutils.argument("application_browser", flag="ab")
    @cmdutils.argument("application_filesystem", flag="af")
    def workspace_open(
        dispatcher,
        url=None,
        related=False,
        bg=False,
        tab=False,
        window=False,
        count=None,
        secure=False,
        private=False,
        application_terminal=False,
        application_browser=False,
        application_filesystem=False,
    ):
        """Open browser, terminal, or filesystem workspace content.

        Existing :open destination flags keep their original meanings.
        `-at`, `-ab`, and `-af` select terminal, browser, and filesystem
        content respectively. Browser remains the default.

        Args:
            url: URL, filesystem path, or application-specific target.
            related: Position a newly opened tab as related to the current one.
            bg: Open in a new background tab.
            tab: Open in a new tab.
            window: Open in a new window.
            count: The tab index to replace/open into, or None.
            secure: Force HTTPS for browser content.
            private: Open a new private window.
            application_terminal: Open native terminal content.
            application_browser: Explicitly select browser content.
            application_filesystem: Open native filesystem content.
        """
        content_kind = workspace.resolve_content_kind(
            application_terminal=application_terminal,
            application_browser=application_browser,
            application_filesystem=application_filesystem,
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


def _register_workspace_tab_clone() -> None:
    """Extend :tab-clone to native filesystem and terminal tabs."""
    if "tab-clone" not in objects.commands:
        return

    objects.commands.pop("tab-clone")

    @cmdutils.register(
        name="tab-clone",
        instance="command-dispatcher",
        scope="window",
    )
    def workspace_tab_clone(dispatcher, bg=False, window=False, private=False):
        """Duplicate the current browser or native workspace tab.

        Filesystem tabs retain their path. Terminal clones start a new shell
        with the same working directory and shell executable.

        Args:
            bg: Open in a background tab.
            window: Open in a new window.
            private: Open in a new private window.
        """
        current = dispatcher._tabbed_browser.widget.currentWidget()
        if not isinstance(current, workspacehost.WorkspaceTab):
            return dispatcher.tab_clone(bg=bg, window=window, private=private)

        cmdutils.check_exclusive((bg, window, private), "bwp")
        try:
            content = _clone_workspace_content(current)
        except (OSError, RuntimeError, ValueError) as error:
            raise cmdutils.CommandError(str(error))

        if window or private:
            target = dispatcher._new_tabbed_browser(
                private=dispatcher._tabbed_browser.is_private or private
            )
        else:
            target = dispatcher._tabbed_browser

        clone = target.tabopen_workspace(
            content,
            background=bg,
            related=False,
        )
        clone.set_pinned(current.data.pinned)
        target.window().show()
        return clone


_register_workspace_open()
_register_workspace_tab_clone()
