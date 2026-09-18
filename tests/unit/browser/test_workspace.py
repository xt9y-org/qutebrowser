# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Tests for qutebrowser.browser.workspace."""

import dataclasses

import pytest

from qutebrowser.api import cmdutils
from qutebrowser.browser import workspace
from qutebrowser.commands import argparser


@pytest.mark.parametrize(
    ("kwargs", "expected"),
    [
        ({}, workspace.ContentKind.BROWSER),
        ({"application_browser": True}, workspace.ContentKind.BROWSER),
        ({"application_terminal": True}, workspace.ContentKind.TERMINAL),
        ({"application_filesystem": True}, workspace.ContentKind.FILESYSTEM),
    ],
)
def test_resolve_content_kind(kwargs, expected):
    assert workspace.resolve_content_kind(**kwargs) is expected


@pytest.mark.parametrize(
    "kwargs",
    [
        {"application_terminal": True, "application_browser": True},
        {"application_terminal": True, "application_filesystem": True},
        {"application_browser": True, "application_filesystem": True},
        {
            "application_terminal": True,
            "application_browser": True,
            "application_filesystem": True,
        },
    ],
)
def test_resolve_content_kind_rejects_conflicts(kwargs):
    with pytest.raises(
        cmdutils.CommandError,
        match=r"Only one of -at/-ab/-af can be given!",
    ):
        workspace.resolve_content_kind(**kwargs)


@pytest.mark.parametrize(
    ("flag", "expected"),
    [
        ("-at", workspace.ContentKind.TERMINAL),
        ("-ab", workspace.ContentKind.BROWSER),
        ("-af", workspace.ContentKind.FILESYSTEM),
        ("--application-terminal", workspace.ContentKind.TERMINAL),
        ("--application-browser", workspace.ContentKind.BROWSER),
        ("--application-filesystem", workspace.ContentKind.FILESYSTEM),
    ],
)
def test_application_selector_parser(flag, expected):
    parser = argparser.ArgumentParser("open")
    workspace.add_application_selector_arguments(parser)

    namespace = parser.parse_args([flag])

    assert workspace.selected_content_kind(namespace) is expected


def test_application_selector_defaults_to_browser():
    parser = argparser.ArgumentParser("open")
    workspace.add_application_selector_arguments(parser)

    namespace = parser.parse_args([])

    assert workspace.selected_content_kind(namespace) is workspace.ContentKind.BROWSER


def test_application_selector_rejects_conflicts():
    parser = argparser.ArgumentParser("open")
    workspace.add_application_selector_arguments(parser)

    with pytest.raises(
        argparser.ArgumentParserError,
        match=r"Only one of -at/-ab/-af can be given!",
    ):
        parser.parse_args(["-at", "-af"])


def test_application_selector_allows_duplicate_same_selector():
    parser = argparser.ArgumentParser("open")
    workspace.add_application_selector_arguments(parser)

    namespace = parser.parse_args(["-at", "-at"])

    assert workspace.selected_content_kind(namespace) is workspace.ContentKind.TERMINAL


def test_content_session_is_immutable():
    session = workspace.ContentSession(
        workspace.ContentKind.FILESYSTEM,
        {"path": "/tmp"},
    )

    with pytest.raises(dataclasses.FrozenInstanceError):
        session.kind = workspace.ContentKind.BROWSER


def test_filesystem_content_uses_native_widget(qtbot, tmp_path):
    content = workspace.FilesystemContent(tmp_path)
    qtbot.addWidget(content.widget)

    assert content.kind is workspace.ContentKind.FILESYSTEM
    assert content.widget is content
    assert content.current_path == tmp_path.resolve()
    assert content.title() == str(tmp_path.resolve())
    assert content.session_state() == workspace.ContentSession(
        workspace.ContentKind.FILESYSTEM,
        {"path": str(tmp_path.resolve())},
    )


def test_filesystem_content_changes_directory(qtbot, tmp_path):
    child = tmp_path / "child"
    child.mkdir()
    content = workspace.FilesystemContent(tmp_path)
    qtbot.addWidget(content.widget)

    content.set_path(child)

    assert content.current_path == child.resolve()
    assert content.model.filePath(content.view.rootIndex()) == str(child.resolve())


def test_filesystem_content_rejects_files(qtbot, tmp_path):
    file_path = tmp_path / "file.txt"
    file_path.write_text("x", encoding="utf-8")

    with pytest.raises(ValueError, match="not a directory"):
        workspace.FilesystemContent(file_path)
