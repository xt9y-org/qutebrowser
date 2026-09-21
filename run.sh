set -euo pipefail

REPO="xt9y-org/qutebrowser"
TAG="v3.7.0-xt9y.4"

git switch main
git pull --ff-only

gh repo set-default "$REPO"

HEAD="$(git rev-parse HEAD)"

echo "HEAD: $HEAD"

# Make absolutely sure we're releasing current origin/main.
ORIGIN_MAIN="$(git rev-parse origin/main)"
if [ "$HEAD" != "$ORIGIN_MAIN" ]; then
    echo "ERROR: local main is not origin/main"
    exit 1
fi

# Refuse to overwrite an existing tag/release.
if git ls-remote --exit-code --tags origin "refs/tags/$TAG" >/dev/null 2>&1; then
    echo "ERROR: tag $TAG already exists"
    exit 1
fi

if gh release view "$TAG" --repo "$REPO" >/dev/null 2>&1; then
    echo "ERROR: release $TAG already exists"
    exit 1
fi

# Reuse the Build Artifacts run for this exact commit if one already exists.
RUN_ID="$(
    gh run list \
        --repo "$REPO" \
        --workflow build-artifacts.yml \
        --branch main \
        --limit 30 \
        --json databaseId,headSha,event,createdAt \
        --jq ".[] |
              select(
                  .headSha == \"$HEAD\" and
                  (.event == \"push\" or .event == \"workflow_dispatch\")
              ) |
              .databaseId" |
    head -n1
)"

# If there is no build for this exact HEAD, start one.
if [ -z "$RUN_ID" ]; then
    echo "No artifact build found for $HEAD; starting one..."

    gh workflow run build-artifacts.yml \
        --repo "$REPO" \
        --ref main \
        -f python_version=3.14

    i=0
    while [ -z "$RUN_ID" ]; do
        i=$((i + 1))

        if [ "$i" -gt 30 ]; then
            echo "ERROR: could not locate newly started artifact workflow"
            exit 1
        fi

        sleep 2

        RUN_ID="$(
            gh run list \
                --repo "$REPO" \
                --workflow build-artifacts.yml \
                --branch main \
                --limit 30 \
                --json databaseId,headSha,event,createdAt \
                --jq ".[] |
                      select(
                          .headSha == \"$HEAD\" and
                          .event == \"workflow_dispatch\"
                      ) |
                      .databaseId" |
            head -n1
        )"
    done
fi

echo "Artifact build run: $RUN_ID"

# This is the hard release gate.
# Linux, Windows, macOS Intel and macOS Apple Silicon must all succeed.
gh run watch "$RUN_ID" \
    --repo "$REPO" \
    --exit-status

rm -rf release-assets
mkdir -p release-assets

gh run download "$RUN_ID" \
    --repo "$REPO" \
    --dir release-assets

echo
echo "Downloaded artifacts:"
find release-assets -type f -print

FILES="$(
    find release-assets -type f \( \
        -name '*.dmg' -o \
        -name '*.exe' -o \
        -name '*windows-standalone*.zip' -o \
        -name '*linux-x86_64.tar.gz' \
    \) -print
)"

COUNT="$(
    printf '%s\n' "$FILES" |
    sed '/^$/d' |
    wc -l |
    tr -d ' '
)"

if [ "$COUNT" -ne 5 ]; then
    echo "ERROR: expected exactly 5 release files, found $COUNT"
    printf '%s\n' "$FILES"
    exit 1
fi

echo
echo "All 5 release artifacts verified."

git tag "$TAG" "$HEAD"
git push origin "$TAG"

gh release create "$TAG" \
    --repo "$REPO" \
    --target "$HEAD" \
    --title "qutebrowser workspace $TAG" \
    --notes "Workspace command redesign.

- Add first-class :browser, :terminal and :filesystem commands
- Keep stock :open unchanged
- Support current-tab replacement
- Support -t foreground tabs and -b background tabs
- Support -t -v side-by-side splits
- Support -t -h stacked splits
- Preserve filesystem-to-terminal cwd inheritance
- Remove legacy -at/-ab/-af selectors
- Remove :workspace-split
- Remove automatic hh/vv bindings
- Preserve Windows ConPTY startup fixes
- Add packaged Linux workspace smoke coverage
- Add packaged Windows terminal/ConPTY smoke coverage" \
    $FILES

echo
echo "Release created:"
gh release view "$TAG" \
    --repo "$REPO" \
    --json url,targetCommitish,assets \
    --jq '{
        url: .url,
        target: .targetCommitish,
        assets: [.assets[].name]
    }'
