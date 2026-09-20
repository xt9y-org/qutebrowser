# Passkey, WebGPU, and Self-Update Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add fork release identity, WebAuthn/passkey UX integration, WebGPU configuration, and safe self-update discovery/staging for packaged qutebrowser builds.

**Architecture:** Keep platform/browser primitives in QtWebEngine and add thin qutebrowser integration layers. Release/update selection is pure Python and testable independently; Qt async clients only transport release metadata/downloads. Passkeys are a dedicated WebEngine helper connected from tabs. WebGPU uses the existing centralized Chromium feature argument builder.

**Tech Stack:** Python, PyQt6/QtWebEngine 6.11, Chromium feature flags, GitHub Releases API, pytest/tox, GitHub Actions.

**Spec:** `docs/superpowers/specs/2026-09-20-passkey-webgpu-self-update-design.md`

## Global Constraints

- Preserve upstream `qutebrowser.__version__`; fork release tags are separate.
- No independent FIDO2/WebAuthn cryptography implementation.
- Never persist/log WebAuth PIN values.
- Fail closed for unknown release tags, architectures, install kinds, and asset shapes.
- Never self-replace package-manager, Flatpak, pip, or source/git installs.
- Existing installation remains intact when update staging fails.

## Review Focus

- Malformed/foreign GitHub releases must not outrank valid fork tags.
- macOS arm64/x86_64 and Windows installer/standalone selection must never cross-match.
- WebAuth request cancellation/navigation must dispose prompts without applying stale responses.
- User-provided Chromium flags must not be duplicated or accidentally inverted by `content.webgpu`.
- Source/package-manager installs must remain check-only.

---

### Task 1: Release identity and release selection

**Files:**
- Create: `qutebrowser/misc/releaseinfo.py`
- Modify: `qutebrowser/misc/autoupdate.py`
- Modify: `tests/unit/misc/test_autoupdate.py`
- Create: `tests/unit/misc/test_releaseinfo.py`

**Interfaces:**
- Produces: `ForkRelease`, `parse_fork_tag(tag)`, `newest_compatible_release(...)`, `PlatformTarget`, `select_release_asset(...)`, and `releaseinfo.current()`.

- [ ] Add failing tests for valid/invalid `vX.Y.Z-xt9y.N` parsing and numeric ordering.
- [ ] Run focused tests and verify failure is due to missing APIs.
- [ ] Implement minimal immutable dataclasses and pure parsing/selection helpers.
- [ ] Add tests for OS/arch/install-kind asset matching and unsupported targets.
- [ ] Run focused tests until green.

### Task 2: GitHub release client and `:update --check`

**Files:**
- Modify: `qutebrowser/misc/autoupdate.py`
- Create: `qutebrowser/components/updatecommands.py`
- Create: `tests/unit/components/test_updatecommands.py`
- Modify: `tests/unit/misc/test_autoupdate.py`

**Interfaces:**
- Consumes: Task 1 release parsing/selection.
- Produces: `GitHubReleaseClient`, update command registration, check-only behavior.

- [ ] Add failing tests for GitHub JSON parsing, draft/prerelease filtering, no-update/current/newer states.
- [ ] Implement GitHub release transport through existing `HTTPClient`.
- [ ] Add command tests for `:update --check` messages and unsupported source/package installs.
- [ ] Implement command wiring and asynchronous result handlers.
- [ ] Run focused tests until green.

### Task 3: WebGPU configuration

**Files:**
- Modify: `qutebrowser/config/configdata.yml`
- Modify: `qutebrowser/config/qtargs.py`
- Modify: `tests/unit/config/test_qtargs.py`

**Interfaces:**
- Produces: `content.webgpu` (`auto`, `always`, `never`) and deterministic Chromium feature lists.

- [ ] Add failing tests for auto/always/never and interaction with pre-existing `--enable-features`/`--disable-features` arguments.
- [ ] Add the config option and feature-list mapping.
- [ ] Run qtargs tests until green.

### Task 4: WebAuthn/passkey request handler

**Files:**
- Create: `qutebrowser/browser/webengine/webauth.py`
- Modify: `qutebrowser/browser/webengine/webenginetab.py`
- Modify: `qutebrowser/utils/usertypes.py`
- Modify: `qutebrowser/mainwindow/prompt.py`
- Create: `tests/unit/browser/webengine/test_webauth.py`

**Interfaces:**
- Produces: `WebAuthHandler` attached per WebEngine tab.

- [ ] Add failing tests using fake WebAuth UX requests for account selection, PIN, cancellation, retry, and informational states.
- [ ] Add masked WebAuth PIN prompt plumbing without logging/persistence.
- [ ] Implement request-state mapping and signal connection guarded by API availability.
- [ ] Abort active prompts on navigation/shutdown/cancellation.
- [ ] Run WebAuth-focused tests until green.

### Task 5: Packaged release metadata and updater staging

**Files:**
- Modify: `.github/workflows/build-artifacts.yml`
- Modify: `misc/qutebrowser.spec`
- Modify: `qutebrowser/misc/releaseinfo.py`
- Modify: `qutebrowser/misc/autoupdate.py`
- Modify: `qutebrowser/components/updatecommands.py`
- Modify: tests for release/update behavior.

**Interfaces:**
- Consumes: Tasks 1-2 selection APIs.
- Produces: embedded `release-info.json`, exact current fork tag detection, download/staging hooks for supported packaged installs.

- [ ] Add failing tests for embedded metadata load/fallback and update refusal for unsupported installs.
- [ ] Generate release metadata during packaged builds and include it in PyInstaller resources.
- [ ] Implement staging paths and platform launch/replacement boundaries without mutating live files before successful staging.
- [ ] Run focused tests until green.

### Task 6: Integration verification

**Files:** all touched files.

- [ ] Run focused unit suites for autoupdate/releaseinfo/updatecommands/qtargs/webauth.
- [ ] Run repository CI on the feature branch.
- [ ] Inspect failures, fix only issues introduced by this work using RED→GREEN tests.
- [ ] Perform final branch diff review against the spec.