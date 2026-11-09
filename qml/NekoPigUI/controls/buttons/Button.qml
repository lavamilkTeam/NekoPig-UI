// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import NekoPigUI 1.0 as NP
import QtQuick.Controls.Basic as Basic
import "../../impl" as Impl

Basic.Button {
    id: control

    property int horizontalAlignment: Text.AlignHCenter

    implicitWidth: Math.max(100, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(NP.Theme.controlHeight, implicitContentHeight + topPadding + bottomPadding)
    leftPadding: NP.Theme.padding
    rightPadding: NP.Theme.padding
    topPadding: 10
    bottomPadding: 10
    font.pixelSize: NP.Theme.bodySize
    hoverEnabled: true

    contentItem: Text {
        text: control.text
        font: control.font
        color: !control.enabled ? NP.Theme.mutedText
            : control.flat ? NP.Theme.text : NP.Theme.accentText
        horizontalAlignment: control.horizontalAlignment
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        radius: NP.Theme.radiusLarge
        // 扁平按钮的选中反馈复用单选按钮的涟漪动画
        color: control.flat ? "transparent"
            : !control.enabled ? NP.Theme.disabled
            : control.down ? Qt.darker(NP.Theme.accent, 1.15)
            : control.hovered ? Qt.darker(NP.Theme.accent, 1.08)
            : NP.Theme.accent
        Impl.SelectionRipple {
            anchors.fill: parent
            radius: NP.Theme.radiusLarge
            visible: control.flat
            selected: control.flat && (control.checked || control.down)
        }
        Rectangle {
            anchors.fill: parent
            radius: NP.Theme.radiusLarge
            color: "transparent"
            border.width: control.visualFocus ? 2 : 0
            border.color: control.flat ? NP.Theme.borderFocus : NP.Theme.accentText
        }
    }
}
