// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic

Basic.CheckBox {
    id: control

    implicitWidth: implicitContentWidth + leftPadding + rightPadding
    implicitHeight: Math.max(Theme.controlHeight, implicitContentHeight + topPadding + bottomPadding)
    leftPadding: 32
    rightPadding: 8
    spacing: 10
    font.pixelSize: Theme.bodySize
    hoverEnabled: true

    indicator: Rectangle {
        implicitWidth: 22
        implicitHeight: 22
        x: 0
        y: (control.height - height) / 2
        radius: 6
        color: !control.enabled ? Theme.disabled
            : control.checkState !== Qt.Unchecked ? Theme.accent : Theme.surface
        border.width: control.visualFocus ? 2 : 1
        border.color: control.visualFocus ? Theme.accent : Theme.border

        Text {
            anchors.centerIn: parent
            text: control.checkState === Qt.PartiallyChecked ? "−" : "✓"
            visible: control.checkState !== Qt.Unchecked
            color: control.enabled ? Theme.onAccent : Theme.mutedText
            font.pixelSize: 16
        }
    }

    contentItem: Text {
        text: control.text
        font: control.font
        color: control.enabled ? Theme.text : Theme.mutedText
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
