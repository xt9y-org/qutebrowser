# Workspace Command Redesign Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace workspace-specific `:open -at/-ab/-af` routing and the public `:workspace-split` selector with independent `:browser`, `:terminal`, and `:filesystem` commands supporting current-tab replacement, foreground/background tabs, and explicit vertical/horizontal splits.

**Architecture:** Keep the existing `TerminalContent`, `FilesystemContent`, `WorkspaceTab`, `PaneManager`, and `SplitLayout` implementations. Replace only the public command/destination layer. `:open` remains the stock qutebrowser browser command. The three new commands share one destination validator and one placement path, with application-specific construction kept isolated so terminal failures cannot break browser/filesystem commands.

**Tech Stack:** Python 3.13/3.14, PyQt6, qutebrowser command API, pytest/pytest-qt, tox, GitHub Actions.

**Spec:** `docs/superpowers/specs/2026-09-19-workspace-command-redesign-design.md`

## Global Constraints

- `:open` must no longer be popped, replaced, wrapped, or extended with workspace selectors.
- `:browser`, `:terminal`, and `:filesystem` must register independently as window-scoped command-dispatcher commands.
- Supported placement flags are exactly `-t`, `-b`, `-v`, and `-h` for the new commands.
- `-v` means a vertical divider / side-by-side panes. Internally this maps to `Qt.Orientation.Horizontal` because a horizontal QSplitter lays widgets left-to-right.
- `-h` means a horizontal divider / stacked panes. Internally this maps to `Qt.Orientation.Vertical`.
- `-v` and `-h` require `-t`, are mutually exclusive, and cannot be combined with `-b`.
- `-t` and `-b` are mutually exclusive.
- Native terminal/filesystem tabs continue to use `WorkspaceTab`; browser tabs continue to use qutebrowser's existing browser tab implementation.
- No compatibility aliases for `-at/-ab/-af`, `:workspace-split`, `hh`, or `vv`.
- Keep existing pane focus/close/move/resize/session features unchanged.
- Preserve filesystem-to-terminal cwd inheritance when `:terminal` has no explicit cwd.
- Do not hide terminal backend errors. Convert expected construction/startup errors to `CommandError` while leaving browser/filesystem registration operational.

## Review Focus

1. Verify stock `:open` is untouched after component import.
2. Verify current-tab browser replacement works when the current tab is a `WorkspaceTab`; stock `openurl()` cannot directly treat that object as a web tab.
3. Verify visual split semantics rather than internal QSplitter naming: `-v` side-by-side, `-h` stacked.
4. Verify background tabs preserve the previously focused tab for both web and native workspace content.
5. Verify the Windows packaged smoke test reaches the real `:terminal`/ConPTY path so `0xc0000142` regressions remain observable.

---

## Task 1: Establish the new command contract with failing tests

**Files:**
- Modify: `tests/unit/components/test_workspacecommands.py`
- Reference only: `qutebrowser/browser/commands.py`
- Reference only: `docs/superpowers/specs/2026-09-19-workspace-command-redesign-design.md`

**Interfaces under test:**

```python
_register_workspace_commands() -> None
_validate_destination(*, tab: bool, bg: bool, vertical: bool, horizontal: bool) -> Qt.Orientation | None
```

- [ ] Replace `test_workspace_open_keeps_legacy_flags_with_application_selector` with a test that injects an existing `open` command sentinel into `workspacecommands.objects.commands`, calls `_register_workspace_commands()`, and asserts the sentinel is still the exact `open` object afterward.
- [ ] In the same registration test, assert `browser`, `terminal`, and `filesystem` were added and their handlers use `self` as the first parameter.
- [ ] Parse each new command with `[]`, `['-t']`, `['-b']`, `['-t', '-v']`, and `['-t', '-h']`; assert the booleans land on `tab`, `bg`, `vertical`, and `horizontal` respectively.
- [ ] Add parser/regression assertions showing the new command parsers expose no `application_terminal`, `application_browser`, or `application_filesystem` fields.
- [ ] Add parameterized failing tests for invalid destination combinations:
  - `-v` without `-t`
  - `-h` without `-t`
  - `-v -h`
  - `-b -v`
  - `-b -h`
  - `-t -b`
- [ ] Add orientation tests asserting:

```python
_validate_destination(tab=True, bg=False, vertical=True, horizontal=False)
    is Qt.Orientation.Horizontal
_validate_destination(tab=True, bg=False, vertical=False, horizontal=True)
    is Qt.Orientation.Vertical
```

- [ ] Run the focused tests and confirm RED because the new registration/validation functions do not exist yet:

```bash
python -m pytest tests/unit/components/test_workspacecommands.py -v
```

Expected: failures specifically for missing `_register_workspace_commands` / `_validate_destination` and old selector behavior, not unrelated import errors.

- [ ] Commit the failing tests:

```bash
git add tests/unit/components/test_workspacecommands.py
git commit -m "Test first-class workspace command contract"
```

---

## Task 2: Register `:browser`, `:terminal`, and `:filesystem` without touching `:open`

**Files:**
- Modify: `qutebrowser/components/workspacecommands.py`
- Modify: `tests/unit/components/test_workspacecommands.py`

**Implementation shape:**

```python
def _validate_destination(*, tab, bg, vertical, horizontal):
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
```

The exact error text may be adjusted to match qutebrowser conventions, but tests should assert stable, useful substrings rather than brittle full messages.

**Registration contract:**

```python
@cmdutils.register(name="browser", instance="command-dispatcher", scope="window", maxsplit=0)
@cmdutils.argument("target", completion=urlmodel.url)
@cmdutils.argument("vertical", flag="v")
@cmdutils.argument("horizontal", flag="h")
def browser(self, target=None, tab=False, bg=False, vertical=False, horizontal=False):
    ...
```

`terminal` and `filesystem` use the same destination flags but no URL completion requirement. Keep the handlers small and delegate placement.

- [ ] Remove `_register_workspace_open()` entirely and remove its module-bottom invocation.
- [ ] Do not call `objects.commands.pop("open")` anywhere in workspace integration.
- [ ] Add `_validate_destination()` exactly once and use it for all three public commands.
- [ ] Add `_register_workspace_commands()` which registers `browser`, `terminal`, and `filesystem` independently.
- [ ] Ensure repeated test registration can operate against a monkeypatched command dictionary without mutating stock `open`.
- [ ] Keep `_register_workspace_tab_clone()` and `_clone_workspace_content()` behavior unchanged.
- [ ] Remove imports that existed only for the old `:open` overload after subsequent tasks make them unnecessary; do not perform unrelated cleanup yet.
- [ ] Run:

```bash
python -m pytest tests/unit/components/test_workspacecommands.py -v
```

Expected: command registration/parser/validation tests GREEN; placement tests are added in Task 3.

- [ ] Commit:

```bash
git add qutebrowser/components/workspacecommands.py tests/unit/components/test_workspacecommands.py
git commit -m "Add first-class browser terminal filesystem commands"
```

---

## Task 3: Implement one shared placement layer for current tabs, new tabs, background tabs, and splits

**Files:**
- Modify: `qutebrowser/components/workspacecommands.py`
- Modify: `tests/unit/components/test_workspacecommands.py`
- Reference only: `qutebrowser/mainwindow/workspacehost.py`
- Reference only: `qutebrowser/components/workspacepanes.py`

**Shared placement interfaces:**

```python
def _replace_with_workspace(tabbed_browser, content):
    ...

def _open_native_content(dispatcher, content, *, tab=False, bg=False):
    ...

def _open_browser_content(dispatcher, target, *, tab=False, bg=False):
    ...

def _open_application(
    dispatcher,
    *,
    application: str,
    target=None,
    tab=False,
    bg=False,
    vertical=False,
    horizontal=False,
):
    ...
```

The names can vary slightly if a cleaner equivalent emerges, but there must be one shared destination decision point and no duplicated split validation across handlers.

**Browser behavior:**

- Normal current web tab: delegate to stock `dispatcher.openurl(url=target, tab=False, bg=False, ...)`.
- `-t`: delegate to stock `openurl(..., tab=True)`.
- `-b`: delegate to stock `openurl(..., bg=True)`.
- Current `WorkspaceTab`: do not call stock current-tab navigation on the native object. Open the browser target as a foreground web tab, remove the old workspace tab with `add_undo=False`, and keep the newly opened browser tab selected.
- `target=None`: preserve stock qutebrowser default-page behavior by passing `None` to `openurl()` rather than independently duplicating URL-default resolution.

**Native content behavior:**

- Current tab: insert the new workspace tab at the old tab index, then remove the old tab.
- `-t`: `tabopen_workspace(..., background=False, related=False)`.
- `-b`: `tabopen_workspace(..., background=True, related=False)`.
- Filesystem target: pass `_filesystem_path(target)` to `FilesystemContent`.
- Terminal target: pass `_terminal_cwd(dispatcher, target)` to `TerminalContent`.

**Split behavior:**

```python
manager = workspacepanes._pane_manager(dispatcher._tabbed_browser.window())
manager.split_active(
    orientation=orientation,
    application=application,
    target=normalized_target,
)
```

Use the existing `PaneManager._populate()` paths; do not build a second split implementation in `workspacecommands.py`.

- [ ] Add failing tests with lightweight fake tab widgets/browsers showing native current-tab replacement inserts at the same index and removes the previous tab once.
- [ ] Add failing tests that `:filesystem -t` uses `background=False` and `:filesystem -b` uses `background=True`.
- [ ] Add equivalent terminal foreground/background tests without starting a real PTY; monkeypatch `TerminalContent` with a fake constructor.
- [ ] Add browser tests for current web tab, foreground tab, and background tab by recording `dispatcher.openurl()` arguments.
- [ ] Add the critical browser-from-workspace regression test: when current is a `WorkspaceTab`, `:browser` creates a new browser tab via `tab=True` and removes the native tab instead of calling web navigation methods on it.
- [ ] Add terminal cwd tests:
  - explicit cwd wins;
  - no cwd on a filesystem workspace tab inherits `current.content.path`;
  - no cwd on a browser/terminal tab remains `None` and lets `TerminalContent` choose its normal default.
- [ ] Add split delegation tests for all three application names and both orientations. Assert `-v` sends `Qt.Orientation.Horizontal`; `-h` sends `Qt.Orientation.Vertical`.
- [ ] Add a failure-isolation test: monkeypatch `TerminalContent` to raise `RuntimeError`, assert the terminal handler raises `CommandError`, then invoke browser/filesystem command handlers successfully in the same test context.
- [ ] Implement the minimal placement helpers and wire the three command handlers to them.
- [ ] Catch only expected application construction/split errors (`OSError`, `RuntimeError`, `ValueError`) and rethrow as `cmdutils.CommandError(str(error))`; do not swallow arbitrary exceptions.
- [ ] Run:

```bash
python -m pytest tests/unit/components/test_workspacecommands.py -v
```

Expected: all new command placement tests GREEN.

- [ ] Run related native-tab regression tests:

```bash
python -m pytest \
  tests/unit/mainwindow/test_workspacehost.py \
  tests/unit/browser/test_filesystemcontent.py \
  tests/unit/browser/test_workspaceterminal.py \
  -v
```

If an exact test filename differs in the repository, use the existing filesystem/terminal unit test files discovered under `tests/unit/browser/`; do not create duplicate suites just to match this command.

- [ ] Commit:

```bash
git add qutebrowser/components/workspacecommands.py tests/unit/components/test_workspacecommands.py
git commit -m "Route workspace commands through shared destinations"
```

---

## Task 4: Remove obsolete application selectors, generic split command, and `hh`/`vv` bindings

**Files:**
- Modify: `qutebrowser/browser/workspace.py`
- Modify: `tests/unit/browser/test_workspace.py`
- Modify: `qutebrowser/components/workspacepanes.py`
- Create or modify: `tests/unit/components/test_workspacepanes.py` if a focused component test is needed
- Modify: `TODO`

- [ ] First add/adjust tests so the old selector resolver is no longer part of the expected workspace API and existing `BrowserContentAdapter`/`ContentSession` tests remain intact.
- [ ] Remove `resolve_content_kind()` from `qutebrowser/browser/workspace.py` and remove its now-unused `cmdutils` import.
- [ ] Remove selector-resolution tests and the now-unused `cmdutils` import from `tests/unit/browser/test_workspace.py`.
- [ ] Add a focused test around `workspacepanes` command registration/import behavior if necessary to prove there is no public `workspace-split` command. The test must not depend on source-text grep when command-registry behavior can be asserted directly.
- [ ] Remove the public `workspace_split()` command from `qutebrowser/components/workspacepanes.py`.
- [ ] Remove `_ORIENTATIONS` and `_APPLICATIONS` if no internal caller uses them after `workspace_split()` is gone.
- [ ] Remove `_install_default_bindings()`, its module-bottom call, and the `keyutils` import. This eliminates automatic `hh`/`vv` bindings.
- [ ] Keep `_install_layout()`, `_pane_manager()`, `PaneManager.split_active()`, `_populate()`, pane close/next/prev, movement/resize, and session code intact.
- [ ] Update root `TODO` so it documents the actual completed command model rather than the removed interface. Replace the old OPEN COMMAND/KEYBINDS sections with the first-class command contract and `-t/-b/-v/-h` semantics.
- [ ] Run:

```bash
python -m pytest \
  tests/unit/browser/test_workspace.py \
  tests/unit/components/test_workspacecommands.py \
  tests/unit/components/test_workspacepaneops.py \
  tests/unit/mainwindow/test_workspacesplit.py \
  -v
```

Expected: GREEN.

- [ ] Run a repository search to ensure removed public syntax is gone from executable/test/workflow code except historical design/spec text where explicitly discussing removal:

```bash
git grep -n -E ':open -(at|ab|af)|workspace-split|"hh"|"vv"|resolve_content_kind' -- \
  qutebrowser tests .github TODO
```

Expected: no matches.

- [ ] Commit:

```bash
git add qutebrowser/browser/workspace.py \
        tests/unit/browser/test_workspace.py \
        qutebrowser/components/workspacepanes.py \
        tests/unit/components/test_workspacepanes.py \
        TODO
git commit -m "Remove legacy workspace selector interface"
```

If `tests/unit/components/test_workspacepanes.py` is not created because existing registry tests provide sufficient coverage, omit it from `git add` rather than creating an empty file.

---

## Task 5: Update packaged smoke tests to exercise the new public commands

**Files:**
- Modify: `.github/workflows/build-artifacts.yml`

**Windows packaged smoke:**

Replace the removed selector path with the real terminal command:

```text
about:blank
:terminal -t .
:cmd-later 1500 quit
```

This must continue to launch a real `TerminalContent` and therefore the real Windows ConPTY backend.

**Linux packaged smoke:**

Use explicit independent commands in sequence:

```text
about:blank
:filesystem -t /tmp
:browser -t about:blank
:terminal -t /tmp
:cmd-later 500 quit
```

Additionally smoke one split path without starting an unnecessary second terminal backend, for example:

```text
:browser -t -v about:blank
```

This verifies packaged command parsing reaches the pane manager. Unit tests remain responsible for exhaustive orientation semantics.

- [ ] Edit the Windows smoke command from `:open -at .` to `:terminal -t .`.
- [ ] Edit the Linux selector sequence to `:filesystem`, `:browser`, and `:terminal` forms.
- [ ] Include one packaged `-t -v` browser split command on Linux so release packaging covers the new split flags as well as ordinary tabs.
- [ ] Run YAML/action checks available locally:

```bash
tox -e yamllint -- .github/workflows/build-artifacts.yml
```

If `actionlint` is installed in the execution environment, also run:

```bash
tox -e actionlint
```

- [ ] Commit:

```bash
git add .github/workflows/build-artifacts.yml
git commit -m "Smoke test first-class workspace commands"
```

---

## Task 6: Full verification, review, and merge preparation

**Files:**
- Review all files changed in Tasks 1–5.
- No new behavior should be added in this task unless verification exposes a defect required by the approved spec.

- [ ] Run the full focused workspace regression set:

```bash
tox -e py -- \
  tests/unit/browser/test_workspace.py \
  tests/unit/components/test_workspacecommands.py \
  tests/unit/components/test_workspacepaneops.py \
  tests/unit/mainwindow/test_workspacehost.py \
  tests/unit/mainwindow/test_workspacesplit.py
```

- [ ] Run flake8 on touched Python paths:

```bash
tox -e flake8 -- \
  qutebrowser/browser/workspace.py \
  qutebrowser/components/workspacecommands.py \
  qutebrowser/components/workspacepanes.py \
  tests/unit/browser/test_workspace.py \
  tests/unit/components/test_workspacecommands.py \
  tests/unit/components/test_workspacepaneops.py \
  tests/unit/mainwindow/test_workspacehost.py \
  tests/unit/mainwindow/test_workspacesplit.py
```

- [ ] Run mypy against touched production modules with the repository's PyQt6 setup:

```bash
tox -e mypy-pyqt6 -- \
  qutebrowser/browser/workspace.py \
  qutebrowser/components/workspacecommands.py \
  qutebrowser/components/workspacepanes.py
```

- [ ] Run the removed-syntax grep again:

```bash
git grep -n -E ':open -(at|ab|af)|workspace-split|"hh"|"vv"|resolve_content_kind' -- \
  qutebrowser tests .github TODO
```

Expected: no matches.

- [ ] Verify the intended command examples from the approved spec are all represented by parser/placement tests:

```text
:browser
:browser -t
:browser -b
:browser -t -v
:browser -t -h
:terminal
:terminal -t
:terminal -b
:terminal -t -v
:terminal -t -h
:filesystem
:filesystem -t
:filesystem -b
:filesystem -t -v
:filesystem -t -h
```

- [ ] Inspect `git diff main...HEAD` for accidental changes to the actual PTY/ConPTY terminal backend, filesystem widget implementation, or upstream `qutebrowser/browser/commands.py`. This redesign should not need to modify those implementations.
- [ ] Confirm stock `:open` code remains owned by `CommandDispatcher.openurl()` and that `workspacecommands.py` never removes/re-registers `open`.
- [ ] Confirm `PaneManager.split_active()` remains the only pane-creation entry used by the new command layer.
- [ ] Confirm Windows CI/build artifacts still execute the real terminal smoke path before considering a new release usable.
- [ ] If verification is green, open a PR from `workspace-command-redesign` to `main` summarizing:
  - first-class `:browser` / `:terminal` / `:filesystem` commands;
  - restored stock `:open`;
  - removed `-at/-ab/-af`, `:workspace-split`, `hh`, `vv`;
  - `-v` side-by-side and `-h` stacked split semantics;
  - updated Windows/Linux packaged smoke coverage.
- [ ] Do not publish or tag a release until the PR is merged and the post-merge `Build Artifacts` Windows/Linux/macOS jobs are green.
