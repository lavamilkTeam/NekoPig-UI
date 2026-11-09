// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic
import NekoPigUI 1.0 as NP
import "../impl" as Impl

Basic.RadioButton {
    id: control

    implicitWidth: Math.max(implicitIndicatorWidth, implicitContentWidth) + leftPadding + rightPadding
    implicitHeight: Math.max(NP.Theme.controlHeight, implicitContentHeight + topPadding + bottomPadding)
    padding: 4
    spacing: 10
    font.pixelSize: NP.Theme.bodySize
    hoverEnabled: true

    // 未选中时保留圆点位置，切换选项不会让文字移动
    indicator: Rectangle {
        implicitWidth: 8
        implicitHeight: 8
        x: control.mirrored ? control.width - control.rightPadding - width : control.leftPadding
        y: (control.height - height) / 2
        radius: width / 2
        color: control.checked ? NP.Theme.radioDot : "transparent"
        opacity: control.enabled ? 1 : 0.4
    }

    contentItem: Text {
        text: control.text
        font: control.font
        color: control.enabled ? NP.Theme.text : NP.Theme.mutedText
        leftPadding: control.text && !control.mirrored ? control.indicator.width + control.spacing : 0
        rightPadding: control.text && control.mirrored ? control.indicator.width + control.spacing : 0
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Item {
        Impl.SelectionRipple {
            anchors.fill: parent
            selected: control.checked
        }

        Rectangle {
            anchors.fill: parent
            radius: 6
            color: "transparent"
            border.width: control.visualFocus ? 1 : 0
            border.color: NP.Theme.radioDot
        }
    }
}
