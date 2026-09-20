# Passkey, WebGPU, and Self-Update Design

## Goal

Extend the xt9y qutebrowser fork with complete QtWebEngine WebAuthn UX integration, explicit WebGPU capability control, and a `:update` command which discovers the newest compatible GitHub release and updates supported packaged installs safely.

## Constraints

- Preserve qutebrowser's existing QtWebEngine architecture; do not implement a second browser engine or a second FIDO2 stack.
- Keep upstream `qutebrowser.__version__` semantics. Fork release identity is separate and uses tags such as `v3.7.0-xt9y.7`.
- QtWebEngine is the authority for WebAuthn authenticator discovery, cryptography, Windows Hello/Touch ID/security-key integration, and WebGPU implementation.
- Passkey UX must use qutebrowser-owned prompts where Qt exposes a WebAuth UX request.
- PIN/passkey secrets must never be logged or persisted.
- `:update` may self-update only packaged installs whose replacement semantics are known and writable. Package-manager, Flatpak, pip, and source/git installs are check-only and must explain the owning update mechanism.
- Release selection must match operating system, CPU architecture, and package/install kind exactly.
- Failed download, validation, extraction, or replacement must leave the existing installation untouched.

## Release identity

Packaged builds embed `qutebrowser/release-info.json` with the GitHub release tag, commit, platform, architecture, and package kind. Source checkouts fall back to git metadata and are not self-updatable.

The runtime exposes release identity through a small `qutebrowser.misc.releaseinfo` module rather than overloading `qutebrowser.__version__`.

## Passkeys / WebAuthn

A dedicated `qutebrowser.browser.webengine.webauth` module owns WebAuthn request state. `WebEngineTab` connects `QWebEnginePage.webAuthUxRequested` when the binding exposes it. The handler supports account selection, PIN collection, request retry/cancellation, and informational states. It aborts active prompts on navigation, tab shutdown, or request cancellation.

Native authentication remains in Chromium/QtWebEngine. This allows Windows Hello, Windows fingerprint/face/PIN, macOS Touch ID/platform credentials, and Linux/external FIDO2 authenticators to work to the extent exposed by the shipped QtWebEngine build.

## WebGPU

Add `content.webgpu` with `auto`, `always`, and `never` values. `auto` leaves the shipped QtWebEngine default intact, `always` enables Chromium's WebGPU feature when required by the shipped Chromium, and `never` disables WebGPU. The setting is translated by the existing centralized Chromium feature-argument path.

Expose WebGPU-relevant QtWebEngine/Chromium information through version diagnostics. Runtime website capability still depends on the QtWebEngine build; qutebrowser must not claim support solely because a flag was set.

## Updater

Extend `qutebrowser.misc.autoupdate` with pure release parsing/selection plus a GitHub releases client. Add an update command component which supports:

- `:update --check`: discover and report whether a newer fork release exists.
- `:update`: discover, select the exact platform asset, download/stage it, and start the platform-specific replacement path for supported packaged installs.

Release tags are ordered by upstream numeric version followed by numeric `xt9y` revision. Drafts are ignored. Prereleases are ignored unless explicitly requested in a future extension.

Supported release asset mapping:

- Windows x86_64 installer: `*-amd64.exe`
- Windows x86_64 standalone: `*-windows-standalone.zip`
- macOS arm64: `*-arm64.dmg`
- macOS x86_64: `*-x86_64.dmg`
- Linux x86_64 standalone: `*-linux-x86_64.tar.gz`

Unsupported architectures/install kinds fail closed.

## Verification

Unit tests cover release tag parsing/order, release filtering, asset selection, WebGPU Chromium flags, WebAuth request state mapping/cancellation, and command behavior. Branch CI is the authoritative execution environment for PyQt/QtWebEngine tests when the local runtime is unavailable.