# SPDX-FileCopyrightText: Alexander Cogneau (acogneau) <alexander.cogneau@gmail.com>:
# SPDX-FileCopyrightText: Freya Bruhin (The Compiler) <mail@qutebrowser.org>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for qutebrowser.misc.autoupdate."""

import json
import os
import pathlib
import subprocess
import time

import pytest
from qutebrowser.qt.core import QUrl

from qutebrowser.misc import autoupdate, httpclient

INVALID_JSON = ['{"invalid": { "json"}', '{"wrong": "keys"}']


class HTTPGetStub(httpclient.HTTPClient):

    """A stub class for HTTPClient.

    Attributes:
        url: the last url used by get()
        _success: Whether get() will emit a success signal.
    """

    def __init__(self, success=True, json=None):
        super().__init__()
        self.url = None
        self._success = success
        if json:
            self._json = json
        else:
            self._json = '{"info": {"version": "test"}}'

    def get(self, url):
        self.url = url
        if self._success:
            self.success.emit(self._json)
        else:
            self.error.emit("error")


def test_constructor(qapp):
    client = autoupdate.PyPIVersionClient()
    assert isinstance(client._client, httpclient.HTTPClient)


def test_get_version_success(qtbot):
    """Test get_version() when success is emitted."""
    http_stub = HTTPGetStub(success=True)
    client = autoupdate.PyPIVersionClient(client=http_stub)

    with qtbot.assert_not_emitted(client.error):
        with qtbot.wait_signal(client.success):
            client.get_version('test')

    assert http_stub.url == QUrl(client.API_URL.format('test'))


def test_get_version_error(qtbot):
    """Test get_version() when error is emitted."""
    http_stub = HTTPGetStub(success=False)
    client = autoupdate.PyPIVersionClient(client=http_stub)

    with qtbot.assert_not_emitted(client.success):
        with qtbot.wait_signal(client.error):
            client.get_version('test')


@pytest.mark.parametrize('json', INVALID_JSON)
def test_invalid_json(qtbot, json):
    """Test on_client_success() with invalid JSON."""
    http_stub = HTTPGetStub(json=json)
    client = autoupdate.PyPIVersionClient(client=http_stub)
    client.get_version('test')

    with qtbot.assert_not_emitted(client.success):
        with qtbot.wait_signal(client.error):
            client.get_version('test')


def test_fork_release_version_ordering():
    older = autoupdate.ForkReleaseVersion.from_tag('v3.7.0-xt9y.7')
    newer_revision = autoupdate.ForkReleaseVersion.from_tag('v3.7.0-xt9y.8')
    newer_upstream = autoupdate.ForkReleaseVersion.from_tag('v3.8.0-xt9y.1')

    assert older < newer_revision < newer_upstream


@pytest.mark.parametrize('tag', [
    'v3.7.0',
    '3.7.0-xt9y.7',
    'v3.7.0-other.7',
    'v3.7-xt9y.7',
])
def test_fork_release_version_rejects_invalid_tags(tag):
    with pytest.raises(ValueError):
        autoupdate.ForkReleaseVersion.from_tag(tag)


def test_latest_release_ignores_drafts_and_prereleases():
    releases = [
        autoupdate.ReleaseInfo(tag='v3.7.0-xt9y.8', assets=(), draft=True),
        autoupdate.ReleaseInfo(tag='v3.7.0-xt9y.9', assets=(), prerelease=True),
        autoupdate.ReleaseInfo(tag='v3.7.0-xt9y.7', assets=()),
        autoupdate.ReleaseInfo(tag='v3.7.0-xt9y.6', assets=()),
    ]

    release = autoupdate.latest_release(releases, current_tag='v3.7.0-xt9y.6')

    assert release is not None
    assert release.tag == 'v3.7.0-xt9y.7'


@pytest.mark.parametrize('target, expected', [
    (
        autoupdate.PlatformTarget(
            os='windows', arch='x86_64',
            install_kind=autoupdate.InstallKind.windows_installer,
        ),
        'qutebrowser-3.7.0-xt9y.8-amd64.exe',
    ),
    (
        autoupdate.PlatformTarget(
            os='windows', arch='x86_64',
            install_kind=autoupdate.InstallKind.windows_standalone,
        ),
        'qutebrowser-3.7.0-xt9y.8-windows-standalone.zip',
    ),
    (
        autoupdate.PlatformTarget(
            os='macos', arch='arm64',
            install_kind=autoupdate.InstallKind.macos_app,
        ),
        'qutebrowser-3.7.0-xt9y.8-arm64.dmg',
    ),
    (
        autoupdate.PlatformTarget(
            os='macos', arch='x86_64',
            install_kind=autoupdate.InstallKind.macos_app,
        ),
        'qutebrowser-3.7.0-xt9y.8-x86_64.dmg',
    ),
    (
        autoupdate.PlatformTarget(
            os='linux', arch='x86_64',
            install_kind=autoupdate.InstallKind.linux_standalone,
        ),
        'qutebrowser-3.7.0-xt9y.8-linux-x86_64.tar.gz',
    ),
])
def test_release_asset_exact_platform_match(target, expected):
    release = autoupdate.ReleaseInfo(
        tag='v3.7.0-xt9y.8',
        assets=tuple(
            autoupdate.ReleaseAsset(name=name, download_url='https://example.invalid/' + name)
            for name in [
                'qutebrowser-3.7.0-xt9y.8-amd64.exe',
                'qutebrowser-3.7.0-xt9y.8-windows-standalone.zip',
                'qutebrowser-3.7.0-xt9y.8-arm64.dmg',
                'qutebrowser-3.7.0-xt9y.8-x86_64.dmg',
                'qutebrowser-3.7.0-xt9y.8-linux-x86_64.tar.gz',
            ]
        ),
    )

    asset = autoupdate.matching_asset(release, target)

    assert asset is not None
    assert asset.name == expected


def test_release_asset_does_not_approximate_architecture():
    release = autoupdate.ReleaseInfo(
        tag='v3.7.0-xt9y.8',
        assets=(autoupdate.ReleaseAsset(
            name='qutebrowser-3.7.0-xt9y.8-x86_64.dmg',
            download_url='https://example.invalid/qutebrowser.dmg',
        ),),
    )
    target = autoupdate.PlatformTarget(
        os='macos', arch='arm64',
        install_kind=autoupdate.InstallKind.macos_app,
    )

    assert autoupdate.matching_asset(release, target) is None


def test_parse_github_releases():
    payload = json.dumps([
        {
            'tag_name': 'v3.7.0-xt9y.8',
            'draft': False,
            'prerelease': False,
            'assets': [
                {
                    'name': 'qutebrowser-3.7.0-xt9y.8-arm64.dmg',
                    'browser_download_url': 'https://example.invalid/qute.dmg',
                },
            ],
        },
    ])

    releases = autoupdate.parse_github_releases(payload)

    assert releases == [autoupdate.ReleaseInfo(
        tag='v3.7.0-xt9y.8',
        assets=(autoupdate.ReleaseAsset(
            name='qutebrowser-3.7.0-xt9y.8-arm64.dmg',
            download_url='https://example.invalid/qute.dmg',
        ),),
    )]


@pytest.mark.parametrize('payload', ['{}', 'null', '[{"tag_name": 3}]'])
def test_parse_github_releases_rejects_malformed_data(payload):
    with pytest.raises(ValueError):
        autoupdate.parse_github_releases(payload)


def test_build_info_from_json():
    info = autoupdate.BuildInfo.from_json(json.dumps({
        'version': '3.7.0',
        'release': 'v3.7.0-xt9y.8',
        'commit': 'abc123',
        'platform': 'macos',
        'arch': 'arm64',
        'package': 'macos-app',
    }))

    assert info.release == 'v3.7.0-xt9y.8'
    assert info.platform == 'macos'
    assert info.arch == 'arm64'


def test_platform_target_from_build_info():
    mac = autoupdate.BuildInfo(
        version='3.7.0', release='v3.7.0-xt9y.8', commit='abc123',
        platform='macos', arch='arm64', package='macos-app')
    linux = autoupdate.BuildInfo(
        version='3.7.0', release='v3.7.0-xt9y.8', commit='abc123',
        platform='linux', arch='x86_64', package='linux-standalone')

    assert autoupdate.platform_target(mac) == autoupdate.PlatformTarget(
        'macos', 'arm64', autoupdate.InstallKind.macos_app)
    assert autoupdate.platform_target(linux) == autoupdate.PlatformTarget(
        'linux', 'x86_64', autoupdate.InstallKind.linux_standalone)


def test_windows_platform_target_uses_install_detection(monkeypatch):
    info = autoupdate.BuildInfo(
        version='3.7.0', release='v3.7.0-xt9y.8', commit='abc123',
        platform='windows', arch='x86_64', package='windows-bundle')

    monkeypatch.setattr(autoupdate, '_is_windows_installer_install', lambda: True)
    assert autoupdate.platform_target(info).install_kind == autoupdate.InstallKind.windows_installer

    monkeypatch.setattr(autoupdate, '_is_windows_installer_install', lambda: False)
    assert autoupdate.platform_target(info).install_kind == autoupdate.InstallKind.windows_standalone


def test_sha256sums_parser():
    sums = autoupdate.parse_sha256sums(
        'a' * 64 + '  qutebrowser-3.7.0-xt9y.8-arm64.dmg\n' +
        'b' * 64 + ' *qutebrowser-3.7.0-xt9y.8-amd64.exe\n')

    assert sums['qutebrowser-3.7.0-xt9y.8-arm64.dmg'] == 'a' * 64
    assert sums['qutebrowser-3.7.0-xt9y.8-amd64.exe'] == 'b' * 64


def test_checksum_asset_exact_match():
    release = autoupdate.ReleaseInfo(
        tag='v3.7.0-xt9y.8',
        assets=(
            autoupdate.ReleaseAsset('SHA256SUMS.txt', 'https://example.invalid/wrong'),
            autoupdate.ReleaseAsset('SHA256SUMS', 'https://example.invalid/right'),
        ),
    )

    asset = autoupdate.checksum_asset(release)

    assert asset is not None
    assert asset.download_url.endswith('/right')


def test_verify_sha256(tmp_path):
    path = tmp_path / 'artifact.bin'
    path.write_bytes(b'horse')

    assert autoupdate.verify_sha256(
        path,
        'fd62862b6dc213bee77c2badd6311528253c6cb3107e03c16051aa15584eca1c',
    )
    assert not autoupdate.verify_sha256(path, '0' * 64)


def test_stage_windows_installer(tmp_path):
    asset = tmp_path / 'qutebrowser-3.7.0-xt9y.8-amd64.exe'
    asset.write_bytes(b'installer')
    target = autoupdate.PlatformTarget(
        'windows', 'x86_64', autoupdate.InstallKind.windows_installer)

    staged = autoupdate.stage_update(asset, target, staging_dir=tmp_path / 'stage')

    assert staged.package_path.read_bytes() == b'installer'
    assert staged.staged_root is None


def test_stage_windows_standalone(tmp_path):
    import zipfile

    asset = tmp_path / 'update.zip'
    with zipfile.ZipFile(asset, 'w') as archive:
        archive.writestr('qutebrowser-3.7.0/qutebrowser.exe', b'new')
    target = autoupdate.PlatformTarget(
        'windows', 'x86_64', autoupdate.InstallKind.windows_standalone)

    staged = autoupdate.stage_update(asset, target, staging_dir=tmp_path / 'stage')

    assert staged.package_path.read_bytes() == asset.read_bytes()
    assert staged.staged_root is not None
    assert (staged.staged_root / 'qutebrowser.exe').read_bytes() == b'new'


def test_stage_linux_standalone(tmp_path):
    import io
    import tarfile

    asset = tmp_path / 'update.tar.gz'
    with tarfile.open(asset, 'w:gz') as archive:
        data = b'new'
        info = tarfile.TarInfo('qutebrowser/qutebrowser')
        info.size = len(data)
        info.mode = 0o755
        archive.addfile(info, io.BytesIO(data))
    target = autoupdate.PlatformTarget(
        'linux', 'x86_64', autoupdate.InstallKind.linux_standalone)

    staged = autoupdate.stage_update(asset, target, staging_dir=tmp_path / 'stage')

    assert staged.package_path.read_bytes() == asset.read_bytes()
    assert staged.staged_root is not None
    assert (staged.staged_root / 'qutebrowser').read_bytes() == b'new'


def test_stage_standalone_rejects_archive_escape(tmp_path):
    import zipfile

    asset = tmp_path / 'update.zip'
    with zipfile.ZipFile(asset, 'w') as archive:
        archive.writestr('../outside.txt', b'bad')
        archive.writestr('qutebrowser/qutebrowser.exe', b'new')
    target = autoupdate.PlatformTarget(
        'windows', 'x86_64', autoupdate.InstallKind.windows_standalone)

    with pytest.raises(ValueError, match='[Uu]nsafe'):
        autoupdate.stage_update(asset, target, staging_dir=tmp_path / 'stage')

    assert not (tmp_path / 'outside.txt').exists()


def test_stage_macos_app(tmp_path):
    asset = tmp_path / 'update.dmg'
    asset.write_bytes(b'dmg')
    target = autoupdate.PlatformTarget(
        'macos', 'arm64', autoupdate.InstallKind.macos_app)

    staged = autoupdate.stage_update(asset, target, staging_dir=tmp_path / 'stage')

    assert staged.package_path.read_bytes() == b'dmg'
    assert staged.staged_root is None


@pytest.mark.skipif(os.name == 'nt', reason='POSIX helper test')
def test_linux_handoff_replaces_install_and_relaunches(tmp_path):
    install_root = tmp_path / 'install'
    install_root.mkdir()
    executable = install_root / 'qutebrowser'
    executable.write_text('#!/bin/sh\nprintf old\n', encoding='utf-8')
    executable.chmod(0o755)

    staged_root = tmp_path / 'stage' / 'payload' / 'qutebrowser'
    staged_root.mkdir(parents=True)
    marker = tmp_path / 'restarted.txt'
    replacement = staged_root / 'qutebrowser'
    replacement.write_text(
        '#!/bin/sh\nprintf "%s" "$*" > "$QUTE_UPDATE_TEST_MARKER"\n',
        encoding='utf-8',
    )
    replacement.chmod(0o755)
    package = tmp_path / 'stage' / 'update.tar.gz'
    package.write_bytes(b'verified package placeholder')
    staged = autoupdate.StagedUpdate(
        package_path=package,
        target=autoupdate.PlatformTarget(
            'linux', 'x86_64', autoupdate.InstallKind.linux_standalone),
        staged_root=staged_root,
    )

    handoff = autoupdate.create_update_handoff(
        staged,
        [str(executable), '--restore', '_restart'],
        current_pid=2_147_483_647,
        install_root=install_root,
    )
    env = os.environ.copy()
    env['QUTE_UPDATE_TEST_MARKER'] = str(marker)
    subprocess.run(handoff.command, env=env, check=True, timeout=5)

    assert 'QUTE_UPDATE_TEST_MARKER' in executable.read_text(encoding='utf-8')
    for _ in range(100):
        if marker.exists():
            break
        time.sleep(0.01)
    assert marker.read_text(encoding='utf-8') == '--restore _restart'
    assert not pathlib.Path(str(install_root) + '.update-old').exists()


@pytest.mark.skipif(os.name == 'nt', reason='POSIX helper test')
def test_linux_handoff_rolls_back_and_relaunches_on_failed_replace(tmp_path):
    install_root = tmp_path / 'install'
    install_root.mkdir()
    executable = install_root / 'qutebrowser'
    marker = tmp_path / 'old-restarted.txt'
    executable.write_text(
        '#!/bin/sh\nprintf "%s" "$*" > "$QUTE_UPDATE_TEST_MARKER"\n',
        encoding='utf-8',
    )
    executable.chmod(0o755)

    stage = tmp_path / 'stage'
    stage.mkdir()
    package = stage / 'update.tar.gz'
    package.write_bytes(b'verified package placeholder')
    staged = autoupdate.StagedUpdate(
        package_path=package,
        target=autoupdate.PlatformTarget(
            'linux', 'x86_64', autoupdate.InstallKind.linux_standalone),
        staged_root=stage / 'missing-payload',
    )

    handoff = autoupdate.create_update_handoff(
        staged,
        [str(executable), '--restore', '_restart'],
        current_pid=2_147_483_647,
        install_root=install_root,
    )
    env = os.environ.copy()
    env['QUTE_UPDATE_TEST_MARKER'] = str(marker)
    result = subprocess.run(handoff.command, env=env, check=False, timeout=5)

    assert result.returncode != 0
    assert executable.is_file()
    for _ in range(100):
        if marker.exists():
            break
        time.sleep(0.01)
    assert marker.read_text(encoding='utf-8') == '--restore _restart'
    assert not pathlib.Path(str(install_root) + '.update-old').exists()


def test_windows_handoff_uses_powershell_config(tmp_path):
    package = tmp_path / 'update.exe'
    package.write_bytes(b'installer')
    staged = autoupdate.StagedUpdate(
        package_path=package,
        target=autoupdate.PlatformTarget(
            'windows', 'x86_64', autoupdate.InstallKind.windows_installer),
    )
    executable = pathlib.Path(r'C:\Program Files\qutebrowser\qutebrowser.exe')

    handoff = autoupdate.create_update_handoff(
        staged,
        [str(executable), '--restore', '_restart'],
        current_pid=1234,
        install_root=executable.parent,
    )

    assert handoff.command[-3] == '-File'
    assert pathlib.Path(handoff.command[-2]).suffix == '.ps1'
    config = json.loads(handoff.config_path.read_text(encoding='utf-8'))
    assert config['kind'] == 'windows_installer'
    assert config['pid'] == 1234
    assert config['package_path'] == str(package.resolve())
    assert config['restart_executable'] == str(executable)
    assert '--restore' in config['restart_arguments']


def test_macos_handoff_targets_current_app_bundle(tmp_path):
    app = tmp_path / 'qutebrowser.app'
    executable = app / 'Contents' / 'MacOS' / 'qutebrowser'
    executable.parent.mkdir(parents=True)
    package = tmp_path / 'update.dmg'
    package.write_bytes(b'dmg')
    staged = autoupdate.StagedUpdate(
        package_path=package,
        target=autoupdate.PlatformTarget(
            'macos', 'arm64', autoupdate.InstallKind.macos_app),
    )

    handoff = autoupdate.create_update_handoff(
        staged,
        [str(executable), '--restore', '_restart'],
        current_pid=1234,
    )

    assert handoff.command[0] == '/bin/sh'
    assert str(app) in handoff.command
    assert str(package.resolve()) in handoff.command


def _build_info():
    return autoupdate.BuildInfo(
        version='3.7.0',
        release='v3.7.0-xt9y.7',
        commit='deadbeef',
        platform='macos',
        arch='arm64',
        package='macos-app',
    )


def _release_payload(*, digest):
    return json.dumps([{
        'tag_name': 'v3.7.0-xt9y.8',
        'draft': False,
        'prerelease': False,
        'assets': [
            {
                'name': 'qutebrowser-3.7.0-xt9y.8-arm64.dmg',
                'browser_download_url': 'https://example.invalid/qute.dmg',
            },
            {
                'name': 'SHA256SUMS',
                'browser_download_url': 'https://example.invalid/SHA256SUMS',
            },
        ],
    }])


def test_fork_update_client_check_only(qtbot):
    releases = HTTPGetStub(json=_release_payload(digest='unused'))
    checksums = HTTPGetStub(json='unused')
    downloads = []
    client = autoupdate.ForkUpdateClient(
        release_client=releases,
        checksum_client=checksums,
        download_func=lambda url: downloads.append(url),
        build_info=_build_info(),
    )

    with qtbot.wait_signal(client.update_available) as blocker:
        client.start(check_only=True)

    assert blocker.args == ['v3.7.0-xt9y.8']
    assert checksums.url is None
    assert downloads == []


def test_fork_update_client_rejects_unmanaged_install(qtbot):
    client = autoupdate.ForkUpdateClient(build_info=None)

    with qtbot.wait_signal(client.error) as blocker:
        client.start(check_only=True)

    assert 'packaged' in blocker.args[0].lower()


def test_fork_update_client_downloads_verifies_and_stages(qtbot, tmp_path):
    import hashlib
    import io
    from qutebrowser.qt.core import QObject, pyqtSignal

    payload = b'package data'
    digest = hashlib.sha256(payload).hexdigest()
    releases = HTTPGetStub(json=_release_payload(digest=digest))
    checksums = HTTPGetStub(
        json=f'{digest}  qutebrowser-3.7.0-xt9y.8-arm64.dmg\n')

    class FakeDownload(QObject):
        finished = pyqtSignal()

        def __init__(self):
            super().__init__()
            self.successful = True
            self.fileobj = io.BytesIO(payload)

    download = FakeDownload()
    client = autoupdate.ForkUpdateClient(
        release_client=releases,
        checksum_client=checksums,
        download_func=lambda _url: download,
        build_info=_build_info(),
        staging_dir=tmp_path / 'staged',
    )

    with qtbot.wait_signal(client.staged) as blocker:
        client.start(check_only=False)
        download.finished.emit()

    assert blocker.args[0] == 'v3.7.0-xt9y.8'
    staged_path = blocker.args[1]
    assert staged_path.endswith('qutebrowser-3.7.0-xt9y.8-arm64.dmg')
    assert (tmp_path / 'staged' / 'qutebrowser-3.7.0-xt9y.8-arm64.dmg').read_bytes() == payload
