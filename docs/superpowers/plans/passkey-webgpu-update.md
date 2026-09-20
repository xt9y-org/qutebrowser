# Passkeys, WebGPU and self-update implementation plan

## Contract

- Keep authenticator crypto/platform integration inside QtWebEngine/Chromium.
- Handle `QWebEnginePage.webAuthUxRequested` in qutebrowser with native prompt UI.
- Add a masked prompt mode for WebAuth PIN collection.
- Abort active WebAuth prompts/requests on navigation, tab shutdown and replacement.
- Add `content.webgpu = auto|always|never` and map it to Chromium WebGPU feature flags.
- Report WebGPU capability via version diagnostics without pretending Python can enable a Qt build compiled without Dawn.
- Add a fork release identity separate from upstream `qutebrowser.__version__`.
- Add `:update` and `:update --check` backed by GitHub releases for `xt9y-org/qutebrowser`.
- Match artifacts exactly by OS, architecture and install kind.
- Never self-update source/pip/Flatpak/distro-managed installs.
- Verify SHA-256 before staging any replacement.
- Stage packaged updates externally so the running browser never overwrites itself.

## Tasks

1. Release identity, release tag parsing and exact artifact selection.
2. GitHub release discovery, checksum verification and `:update` command.
3. Platform staging helpers for Windows installer/standalone, macOS DMG and Linux standalone.
4. Build/release metadata generation and packaged-resource inclusion.
5. `content.webgpu` config, Chromium flag resolution and diagnostics.
6. Masked prompt mode and WebAuth request handler.
7. Wire WebAuth into `WebEngineTab` and lifecycle cancellation.
8. Focused unit tests, full relevant suites, lint/type sanity and branch review.

## Shared interfaces

- Build metadata produces `qutebrowser/release-info.json`; updater consumes it.
- Artifact names and build metadata use the same fork release tag.
- WebGPU schema is consumed by `qtargs._qtwebengine_features`.
- WebAuth handler consumes `PromptMode.password` and `WebEngineTab.abort_questions`.

