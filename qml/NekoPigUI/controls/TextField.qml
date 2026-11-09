// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import NekoPigUI 1.0 as NP
import QtQuick.Controls.Basic as Basic

Basic.TextField {
    id: control

    property bool invalid: false

    implicitWidth: 240
    implicitHeight: Math.max(NP.Theme.controlHeight, contentHeight + topPadding + bottomPadding)
    leftPadding: NP.Theme.padding
    rightPadding: NP.Theme.padding
    topPadding: 10
    bottomPadding: 10
    font.pixelSize: NP.Theme.bodySize
    color: enabled ? NP.Theme.text : NP.Theme.mutedText
    placeholderTextColor: NP.Theme.mutedText
    selectionColor: NP.Theme.accent
    selectedTextColor: NP.Theme.accentText

    background: Rectangle {
        radius: NP.Theme.radius
        color: control.enabled ? NP.Theme.surface : NP.Theme.disabled
        border.width: control.activeFocus || control.invalid ? 2 : 1
        border.color: control.invalid ? NP.Theme.danger
            : control.activeFocus ? NP.Theme.accent : NP.Theme.border
    }
}
