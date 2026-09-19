# SPDX-FileCopyrightText: 2026 Felix Jaschul <felix@xt9y.de>
#
# SPDX-License-Identifier: GPL-3.0-or-later

"""Commands for moving and resizing workspace split panes."""

from qutebrowser.qt.widgets import QSplitter, QWidget

from qutebrowser.api import cmdutils
from qutebrowser.components import workspacepanes


_MIN_PANE_SIZE = 32


def move_relative(layout, pane: QWidget, offset: int) -> None:
    """Move ``pane`` through visual pane order."""
    leaves = layout.pane_widgets()
    if len(leaves) < 2:
        return
    current = leaves.index(pane)
    target = leaves[(current + offset) % len(leaves)]
    layout.swap(pane, target)


def resize_pane(pane: QWidget, amount: int) -> None:
    """Grow/shrink a pane along its immediate splitter orientation."""
    parent = pane.parentWidget()
    if not isinstance(parent, QSplitter) or parent.count() < 2:
        return

    index = parent.indexOf(pane)
    sizes = parent.sizes()
    if index < 0 or index >= len(sizes):
        return

    if index + 1 < len(sizes):
        neighbor = index + 1
    else:
        neighbor = index - 1

    maximum_growth = max(0, sizes[neighbor] - _MIN_PANE_SIZE)
    maximum_shrink = max(0, sizes[index] - _MIN_PANE_SIZE)
    applied = min(max(amount, -maximum_shrink), maximum_growth)
    if applied == 0:
        return

    sizes[index] += applied
    sizes[neighbor] -= applied
    parent.setSizes(sizes)


@cmdutils.register(instance="main-window", scope="window")
@cmdutils.argument("direction", choices=["next", "prev"])
def workspace_pane_move(self, direction="next"):
    """Move the active pane forward/backward in visual pane order.

    Args:
        direction: next or prev.
    """
    manager = workspacepanes._pane_manager(self)
    offset = 1 if direction == "next" else -1
    move_relative(manager, manager.active.widget, offset)
    manager.active.widget.setFocus()


@cmdutils.register(instance="main-window", scope="window")
def workspace_pane_resize(self, amount: int = 32):
    """Grow or shrink the active pane by a number of pixels.

    Positive values grow the pane, negative values shrink it.

    Args:
        amount: Pixel delta applied against the nearest sibling pane.
    """
    manager = workspacepanes._pane_manager(self)
    resize_pane(manager.active.widget, amount)
