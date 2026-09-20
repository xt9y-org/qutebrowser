# SPDX-FileCopyrightText: 2026 Felix Jaschul
#
# SPDX-License-Identifier: GPL-3.0-or-later

import json

import pytest

import qutebrowser
from scripts.dev import release_metadata


@pytest.mark.parametrize('value, expected', [
    ('AMD64', 'x86_64'),
    ('x64', 'x86_64'),
    ('x86_64', 'x86_64'),
    ('aarch64', 'arm64'),
    ('arm64', 'arm64'),
])
def test_normalize_arch(value, expected):
    assert release_metadata.normalize_arch(value) == expected


def test_detect_release_tag_from_github(monkeypatch):
    monkeypatch.setattr(release_metadata.subprocess, 'run', pytest.fail)
    tag = release_metadata.detect_release_tag(env={
        'GITHUB_REF_TYPE': 'tag',
        'GITHUB_REF_NAME': 'v3.7.0-xt9y.8',
    })
    assert tag == 'v3.7.0-xt9y.8'


def test_detect_release_tag_rejects_explicit_invalid():
    with pytest.raises(ValueError, match='Invalid QUTEBROWSER_RELEASE_TAG'):
        release_metadata.detect_release_tag(env={
            'QUTEBROWSER_RELEASE_TAG': 'v3.7.0',
        })


def test_artifact_version_for_fork_release(monkeypatch):
    monkeypatch.setattr(
        release_metadata, 'detect_release_tag',
        lambda: 'v3.7.0-xt9y.8')
    assert release_metadata.artifact_version() == '3.7.0-xt9y.8'


def test_artifact_version_for_untagged_build(monkeypatch):
    monkeypatch.setattr(release_metadata, 'detect_release_tag', lambda: None)
    assert release_metadata.artifact_version() == qutebrowser.__version__


def test_write_release_info(tmp_path):
    path = tmp_path / 'release-info.json'
    created = release_metadata.write_release_info(
        platform_name='windows',
        arch='AMD64',
        package='windows-bundle',
        output=path,
        release_tag='v3.7.0-xt9y.8',
        commit='deadbeef',
    )

    assert created
    assert json.loads(path.read_text(encoding='utf-8')) == {
        'version': qutebrowser.__version__,
        'release': 'v3.7.0-xt9y.8',
        'commit': 'deadbeef',
        'platform': 'windows',
        'arch': 'x86_64',
        'package': 'windows-bundle',
    }


def test_write_release_info_untagged_removes_stale_file(tmp_path, monkeypatch):
    path = tmp_path / 'release-info.json'
    path.write_text('{}', encoding='utf-8')
    monkeypatch.setattr(release_metadata, 'detect_release_tag', lambda: None)

    created = release_metadata.write_release_info(
        platform_name='linux',
        arch='x86_64',
        package='linux-standalone',
        output=path,
    )

    assert not created
    assert not path.exists()
