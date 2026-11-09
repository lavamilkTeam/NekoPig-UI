// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic
import NekoPigUI 1.0 as NP

Basic.MenuItem {
    id: control
    implicitHeight: NP.Theme.controlHeight
    padding: 12
    spacing: 10
    font.pixelSize: NP.Theme.bodySize
    hoverEnabled: true
    // 保留原生勾选标记、子菜单箭头和 Action 绑定
    palette.windowText: enabled ? NP.Theme.text : NP.Theme.mutedText
    palette.text: enabled ? NP.Theme.text : NP.Theme.mutedText
    background: Rectangle {
        x: 2
        y: 2
        width: control.width - 4
        height: control.height - 4
        radius: 8
        color: control.highlighted || control.down ? NP.Theme.selectionSurface
            : control.hovered ? NP.Theme.disabled : "transparent"
    }
}
