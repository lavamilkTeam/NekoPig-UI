// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import NekoPigUI 1.0 as NP
import QtQuick.Controls.Basic as Basic

Basic.CheckBox {
    id: control

    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: Math.max(NP.Theme.controlHeight, implicitContentHeight + topPadding + bottomPadding)
    leftPadding: 32
    rightPadding: 8
    spacing: 10
    font.pixelSize: NP.Theme.bodySize
    hoverEnabled: true

    indicator: Rectangle {
        implicitWidth: 22
        implicitHeight: 22
        x: 0
        y: (control.height - height) / 2
        radius: 6
        color: !control.enabled ? NP.Theme.disabled
            : control.checkState !== Qt.Unchecked ? NP.Theme.accent : NP.Theme.surface
        border.width: control.visualFocus ? 2 : 1
        border.color: !control.visualFocus ? NP.Theme.border
            : control.checkState === Qt.Unchecked ? NP.Theme.accent : NP.Theme.accentText

        Text {
            anchors.centerIn: parent
            text: control.checkState === Qt.PartiallyChecked ? "−" : "✓"
            visible: control.checkState !== Qt.Unchecked
            color: control.enabled ? NP.Theme.accentText : NP.Theme.mutedText
            font.pixelSize: 16
        }
    }

    contentItem: Text {
        text: control.text
        font: control.font
        color: control.enabled ? NP.Theme.text : NP.Theme.mutedText
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
