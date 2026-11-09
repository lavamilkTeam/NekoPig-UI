// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic
import NekoPigUI 1.0 as NP

Basic.ScrollBar {
    id: control
    padding: 2
    hoverEnabled: true
    minimumSize: Math.min(1, 28 / Math.max(1, horizontal ? width : height))
    background: null

    contentItem: Rectangle {
        implicitWidth: 6
        implicitHeight: 6
        radius: Math.min(width, height) / 2
        color: NP.Theme.mutedText
        opacity: control.policy === Basic.ScrollBar.AlwaysOff ? 0
            : control.size >= 1 && control.policy !== Basic.ScrollBar.AlwaysOn ? 0
            : !control.enabled ? 0.2
            : control.active || control.hovered || control.pressed ? 0.8 : 0.35
        Behavior on opacity { NumberAnimation { duration: 160 } }
    }
}
