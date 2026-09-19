# Workspace Command Redesign

## Goal

Replace the overloaded workspace integration built on top of `:open` and the separate `:workspace-split` interface with three explicit first-class commands:

- `:browser`
- `:terminal`
- `:filesystem`

The command surface must make the selected application explicit and keep destination behavior consistent across all three commands.

## Public command interface

Each command accepts an optional application-specific target plus destination flags.

### Browser

- `:browser [url]` — replace the current tab with a browser tab.
- `:browser -t [url]` — open a new foreground browser tab.
- `:browser -b [url]` — open a new background browser tab.
- `:browser -t -v [url]` — open a new vertical/side-by-side pane containing a browser tab.
- `:browser -t -h [url]` — open a new horizontal/stacked pane containing a browser tab.

### Terminal

- `:terminal [cwd]` — replace the current tab with a native terminal tab.
- `:terminal -t [cwd]` — open a new foreground terminal tab.
- `:terminal -b [cwd]` — open a new background terminal tab.
- `:terminal -t -v [cwd]` — open a new vertical/side-by-side pane containing a terminal tab.
- `:terminal -t -h [cwd]` — open a new horizontal/stacked pane containing a terminal tab.

If no cwd is supplied and the current tab is a filesystem workspace tab, inherit that filesystem path. Otherwise use the terminal backend's normal default cwd behavior.

### Filesystem

- `:filesystem [path]` — replace the current tab with a native filesystem tab.
- `:filesystem -t [path]` — open a new foreground filesystem tab.
- `:filesystem -b [path]` — open a new background filesystem tab.
- `:filesystem -t -v [path]` — open a new vertical/side-by-side pane containing a filesystem tab.
- `:filesystem -t -h [path]` — open a new horizontal/stacked pane containing a filesystem tab.

If no path is supplied, use the existing filesystem content default (the user's home directory).

## Flag semantics

- `-t`: open in a new foreground tab.
- `-b`: open in a new background tab.
- `-v`: create a vertical/side-by-side split pane. This is only valid together with `-t`.
- `-h`: create a horizontal/stacked split pane. This is only valid together with `-t`.

`-v` and `-h` are mutually exclusive. `-b` cannot be combined with a split because a newly created split pane becomes a visible pane by definition.

## Removed public interface

Remove all workspace-specific overloading from `:open`:

- `:open -at`
- `:open -af`
- `:open -ab`

Restore upstream `:open` registration and behavior without workspace monkeypatching.

Remove the generic split selector command from the public interface:

- `:workspace-split ...`

Remove default bindings which only existed to invoke that selector:

- `hh`
- `vv`

No compatibility aliases are retained.

## Internal structure

Keep the existing native implementations:

- browser tabs use the normal qutebrowser/WebEngine tab implementation;
- terminals use `TerminalContent` and the PTY/ConPTY backend;
- filesystem tabs use `FilesystemContent` and Qt's filesystem model;
- pane management continues to use `PaneManager` and the split-layout infrastructure.

Introduce one shared destination helper used by the three application commands. The helper owns the mechanics of:

1. replacing the current tab;
2. creating a foreground tab;
3. creating a background tab;
4. creating a vertical split pane;
5. creating a horizontal split pane.

Application-specific command handlers only construct or resolve their content/target and delegate placement to this common layer.

Browser replacement must preserve normal qutebrowser browser-tab behavior. Terminal/filesystem replacement may use the existing workspace-tab replacement mechanics.

Split creation should call the existing `PaneManager` directly with an explicit application rather than routing through a generic public `workspace-split` command.

## Error handling

Invalid destination combinations are command errors, not crashes:

- `-v` with `-h` -> error;
- `-v` without `-t` -> error;
- `-h` without `-t` -> error;
- `-b` with `-v` or `-h` -> error.

Invalid terminal cwd or filesystem path should be surfaced as `CommandError` using the existing exception-to-command-error behavior.

Terminal backend failures remain isolated to the terminal command. A terminal backend failure must not affect `:browser` or `:filesystem` registration or operation.

## Testing

Add command-level tests covering all three application commands and placement modes.

Required regression coverage:

- `:open` has no `-at`, `-af`, or `-ab` arguments.
- `:browser`, `:terminal`, and `:filesystem` are registered independently.
- current-tab replacement works for each application.
- `-t` opens foreground tabs.
- `-b` opens background tabs.
- `-t -v` creates a side-by-side split.
- `-t -h` creates a stacked split.
- invalid flag combinations return command errors.
- filesystem-to-terminal cwd inheritance is preserved.
- packaged smoke tests invoke the new commands instead of the removed `:open -a*` forms.
- Windows packaged smoke coverage still opens a real terminal command path so ConPTY regressions remain visible.

## Success criteria

The workspace application type is always explicit in the command name. `:open` is once again an ordinary upstream browser command. No `hh`/`vv` workspace shortcuts or generic application picker remain. Browser, terminal, and filesystem failures are isolated from each other, while tabs and splits share one small destination implementation.
