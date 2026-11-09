// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic
import NekoPigUI 1.0 as NP

Basic.TabBar {
    spacing: 4
    padding: 4
    background: Rectangle {
        radius: NP.Theme.radiusLarge
        color: NP.Theme.surface
    }
}
