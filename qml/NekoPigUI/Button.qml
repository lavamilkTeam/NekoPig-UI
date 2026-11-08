// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic

Basic.Button {
    id: control

    implicitWidth: Math.max(100, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(Theme.controlHeight, implicitContentHeight + topPadding + bottomPadding)
    leftPadding: Theme.padding
    rightPadding: Theme.padding
    topPadding: 10
    bottomPadding: 10
    font.pixelSize: Theme.bodySize
    hoverEnabled: true

    contentItem: Text {
        text: control.text
        font: control.font
        color: control.enabled ? Theme.accentText : Theme.mutedText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }

    background: Rectangle {
        radius: Theme.radius
        color: !control.enabled ? Theme.disabled
            : control.down ? Qt.darker(Theme.accent, 1.15)
            : control.hovered ? Qt.darker(Theme.accent, 1.08)
            : Theme.accent
        border.width: control.visualFocus ? 2 : 0
        border.color: Theme.accentText
    }
}
