#!/usr/bin/env python3

# SPDX-FileCopyrightText: 2026 Felix Jaschul
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Generate downstream packaged-build identity for xt9y releases."""

from __future__ import annotations

import argparse
import json
import os
import pathlib
import platform
import re
import subprocess
import sys

REPO_ROOT = pathlib.Path(__file__).resolve().parents[2]
sys.path.insert(0, str(REPO_ROOT))

import qutebrowser  # noqa: E402


DEFAULT_OUTPUT = REPO_ROOT / 'build' / 'release-info.json'
_TAG_RE = re.compile(r'^v\d+\.\d+\.\d+-xt9y\.\d+$')


def normalize_arch(arch: str) -> str:
    aliases = {
        'amd64': 'x86_64',
        'x64': 'x86_64',
        'aarch64': 'arm64',
    }
    return aliases.get(arch.lower(), arch.lower())


def detect_release_tag(*, env: dict[str, str] | None = None) -> str | None:
    """Return the exact downstream release tag for this build, if any."""
    environ = os.environ if env is None else env
    explicit = environ.get('QUTEBROWSER_RELEASE_TAG')
    if explicit is not None:
        if not _TAG_RE.fullmatch(explicit):
            raise ValueError(f'Invalid QUTEBROWSER_RELEASE_TAG: {explicit!r}')
        return explicit

    if environ.get('GITHUB_REF_TYPE') == 'tag':
        github_tag = environ.get('GITHUB_REF_NAME')
        if github_tag and _TAG_RE.fullmatch(github_tag):
            return github_tag

    proc = subprocess.run(
        ['git', 'describe', '--tags', '--exact-match', 'HEAD'],
        cwd=REPO_ROOT,
        check=False,
        capture_output=True,
        text=True,
    )
    tag = proc.stdout.strip()
    if proc.returncode == 0 and _TAG_RE.fullmatch(tag):
        return tag
    return None


def artifact_version() -> str:
    """Version segment to use for binary artifact filenames."""
    tag = detect_release_tag()
    return qutebrowser.__version__ if tag is None else tag.removeprefix('v')


def git_commit() -> str:
    proc = subprocess.run(
        ['git', 'rev-parse', 'HEAD'],
        cwd=REPO_ROOT,
        check=True,
        capture_output=True,
        text=True,
    )
    return proc.stdout.strip()


def write_release_info(
        *,
        platform_name: str,
        arch: str,
        package: str,
        output: pathlib.Path = DEFAULT_OUTPUT,
        release_tag: str | None = None,
        commit: str | None = None,
) -> bool:
    """Write release-info.json for a tagged xt9y build.

    Untagged builds intentionally do not get packaged self-update metadata.
    """
    tag = detect_release_tag() if release_tag is None else release_tag
    if tag is None:
        output.unlink(missing_ok=True)
        return False
    if not _TAG_RE.fullmatch(tag):
        raise ValueError(f'Invalid xt9y release tag: {tag!r}')

    payload = {
        'version': qutebrowser.__version__,
        'release': tag,
        'commit': git_commit() if commit is None else commit,
        'platform': platform_name,
        'arch': normalize_arch(arch),
        'package': package,
    }
    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text(json.dumps(payload, indent=2) + '\n', encoding='utf-8')
    return True


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument('--platform', required=True, dest='platform_name')
    parser.add_argument('--arch', default=platform.machine())
    parser.add_argument('--package', required=True)
    parser.add_argument('--output', type=pathlib.Path, default=DEFAULT_OUTPUT)
    args = parser.parse_args()
    write_release_info(
        platform_name=args.platform_name,
        arch=args.arch,
        package=args.package,
        output=args.output,
    )


if __name__ == '__main__':
    main()
