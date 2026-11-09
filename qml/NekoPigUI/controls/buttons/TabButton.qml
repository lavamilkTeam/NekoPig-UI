// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic
import NekoPigUI 1.0 as NP
import "../../impl" as Impl

Basic.TabButton {
    id: control
    implicitWidth: Math.max(88, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: NP.Theme.controlHeight
    horizontalPadding: NP.Theme.padding
    verticalPadding: 8
    font.pixelSize: NP.Theme.bodySize
    hoverEnabled: true
    contentItem: Text {
        text: control.text
        font: control.font
        color: control.enabled ? NP.Theme.text : NP.Theme.mutedText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
    background: Item {
        // 页签与列表共用选中涟漪，切换时旧背景反向收回
        Impl.SelectionRipple {
            anchors.fill: parent
            radius: NP.Theme.radius
            selected: control.checked || control.down
        }
        Rectangle {
            anchors.fill: parent
            radius: NP.Theme.radius
            color: "transparent"
            border.width: control.visualFocus ? 1 : 0
            border.color: NP.Theme.borderFocus
        }
    }
}
