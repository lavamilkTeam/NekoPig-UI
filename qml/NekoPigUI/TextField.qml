// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic

Basic.TextField {
    id: control

    property bool invalid: false

    implicitWidth: 240
    implicitHeight: Math.max(Theme.controlHeight, contentHeight + topPadding + bottomPadding)
    leftPadding: Theme.padding
    rightPadding: Theme.padding
    topPadding: 10
    bottomPadding: 10
    font.pixelSize: Theme.bodySize
    color: enabled ? Theme.text : Theme.mutedText
    placeholderTextColor: Theme.mutedText
    selectionColor: Theme.accent
    selectedTextColor: Theme.onAccent

    background: Rectangle {
        radius: Theme.radius
        color: control.enabled ? Theme.surface : Theme.disabled
        border.width: control.activeFocus || control.invalid ? 2 : 1
        border.color: control.invalid ? Theme.danger
            : control.activeFocus ? Theme.accent : Theme.border
    }
}
