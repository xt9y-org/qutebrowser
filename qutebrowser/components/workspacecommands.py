# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Workspace-aware command integration."""

from qutebrowser.qt.core import Qt, QUrl

from qutebrowser.api import cmdutils
from qutebrowser.browser import filesystemcontent, workspace, workspaceterminal
from qutebrowser.completion.models import urlmodel
from qutebrowser.mainwindow import workspacehost
from qutebrowser.misc import objects


def _filesystem_path(value):
    """Turn a command's optional target argument into a filesystem path."""
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
    """Apply tab destinations to native workspace content."""
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
    """Preserve normal browser opening when the selected tab is native content."""
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


def _validate_destination(*, tab, bg, vertical, horizontal):
    """Validate a workspace destination and return its split orientation."""
    if tab and bg:
        raise cmdutils.CommandError("Only one of -t/-b can be given!")
    if vertical and horizontal:
        raise cmdutils.CommandError("Only one of -v/-h can be given!")
    if (vertical or horizontal) and not tab:
        raise cmdutils.CommandError("-v/-h require -t")
    if bg and (vertical or horizontal):
        raise cmdutils.CommandError("Background tabs cannot create a split")
    if vertical:
        return Qt.Orientation.Horizontal
    if horizontal:
        return Qt.Orientation.Vertical
    return None


def _claim_horizontal_short_flag(command) -> None:
    """Give a workspace command ``-h`` while retaining ``--help``.

    qutebrowser installs ``-h/--help`` on every command before inspecting its
    handler.  The workspace command contract deliberately uses ``-h`` for a
    horizontal split, so only these command parsers release the short help
    spelling.  ``--help`` remains unchanged.
    """
    parser = command.parser
    help_action = parser._option_string_actions.pop("-h")
    help_action.option_strings.remove("-h")

    horizontal_action = parser._option_string_actions.pop("-H")
    horizontal_action.option_strings.remove("-H")
    horizontal_action.option_strings.append("-h")
    parser._option_string_actions["-h"] = horizontal_action
    command.opt_args["horizontal"] = ("--horizontal", "-h")


def _register_workspace_commands() -> None:
    """Register independent browser, terminal, and filesystem commands."""

    @cmdutils.register(
        name="browser",
        maxsplit=0,
        instance="command-dispatcher",
        scope="window",
    )
    @cmdutils.argument("target", completion=urlmodel.url)
    @cmdutils.argument("vertical", flag="v")
    @cmdutils.argument("horizontal", flag="H")
    def browser(
        self,
        target=None,
        tab=False,
        bg=False,
        vertical=False,
        horizontal=False,
    ):
        """Open browser content in the current tab, a new tab, or a split.

        Args:
            target: URL to open, or None for qutebrowser's normal default.
            tab: Open in a new foreground tab.
            bg: Open in a new background tab.
            vertical: Split side-by-side; requires -t.
            horizontal: Split stacked; requires -t.
        """
        _validate_destination(
            tab=tab,
            bg=bg,
            vertical=vertical,
            horizontal=horizontal,
        )
        return _open_browser_from_workspace(
            self,
            url=target,
            related=False,
            bg=bg,
            tab=tab,
            window=False,
            count=None,
            secure=False,
            private=False,
        )

    @cmdutils.register(
        name="terminal",
        maxsplit=0,
        instance="command-dispatcher",
        scope="window",
    )
    @cmdutils.argument("vertical", flag="v")
    @cmdutils.argument("horizontal", flag="H")
    def terminal(
        self,
        target=None,
        tab=False,
        bg=False,
        vertical=False,
        horizontal=False,
    ):
        """Open terminal content in the current tab, a new tab, or a split.

        Args:
            target: Working directory, or None for the inherited/default cwd.
            tab: Open in a new foreground tab.
            bg: Open in a new background tab.
            vertical: Split side-by-side; requires -t.
            horizontal: Split stacked; requires -t.
        """
        _validate_destination(
            tab=tab,
            bg=bg,
            vertical=vertical,
            horizontal=horizontal,
        )
        try:
            content = workspaceterminal.TerminalContent(
                cwd=_terminal_cwd(self, target)
            )
        except (OSError, RuntimeError, ValueError) as error:
            raise cmdutils.CommandError(str(error))
        return _open_workspace_content(
            self,
            content,
            bg=bg,
            tab=tab,
        )

    @cmdutils.register(
        name="filesystem",
        maxsplit=0,
        instance="command-dispatcher",
        scope="window",
    )
    @cmdutils.argument("vertical", flag="v")
    @cmdutils.argument("horizontal", flag="H")
    def filesystem(
        self,
        target=None,
        tab=False,
        bg=False,
        vertical=False,
        horizontal=False,
    ):
        """Open filesystem content in the current tab, a new tab, or a split.

        Args:
            target: Filesystem path, or None for the default path.
            tab: Open in a new foreground tab.
            bg: Open in a new background tab.
            vertical: Split side-by-side; requires -t.
            horizontal: Split stacked; requires -t.
        """
        _validate_destination(
            tab=tab,
            bg=bg,
            vertical=vertical,
            horizontal=horizontal,
        )
        try:
            content = filesystemcontent.FilesystemContent(
                _filesystem_path(target)
            )
        except (OSError, ValueError) as error:
            raise cmdutils.CommandError(str(error))
        return _open_workspace_content(
            self,
            content,
            bg=bg,
            tab=tab,
        )

    for name in ("browser", "terminal", "filesystem"):
        _claim_horizontal_short_flag(objects.commands[name])


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
    def workspace_tab_clone(self, bg=False, window=False, private=False):
        """Duplicate the current browser or native workspace tab.

        Filesystem tabs retain their path. Terminal clones start a new shell
        with the same working directory and shell executable.

        Args:
            bg: Open in a background tab.
            window: Open in a new window.
            private: Open in a new private window.
        """
        current = self._tabbed_browser.widget.currentWidget()
        if not isinstance(current, workspacehost.WorkspaceTab):
            return self.tab_clone(bg=bg, window=window, private=private)

        cmdutils.check_exclusive((bg, window, private), "bwp")
        try:
            content = _clone_workspace_content(current)
        except (OSError, RuntimeError, ValueError) as error:
            raise cmdutils.CommandError(str(error))

        if window or private:
            target = self._new_tabbed_browser(
                private=self._tabbed_browser.is_private or private
            )
        else:
            target = self._tabbed_browser

        clone = target.tabopen_workspace(
            content,
            background=bg,
            related=False,
        )
        clone.set_pinned(current.data.pinned)
        target.window().show()
        return clone


_register_workspace_commands()
_register_workspace_tab_clone()
