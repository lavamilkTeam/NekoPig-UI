// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic
import NekoPigUI 1.0 as NP

Basic.ToolTip {
    id: control
    padding: 8
    horizontalPadding: 12
    delay: 500
    timeout: 4000
    margins: 8
    font.pixelSize: 13
    popupType: Basic.Popup.Item
    contentItem: Text {
        text: control.text
        font: control.font
        wrapMode: Text.Wrap
        color: NP.Theme.text
    }
    background: Rectangle {
        radius: 8
        color: NP.Theme.surface
        border.color: NP.Theme.borderSubtle
    }
    enter: Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 100 } }
    exit: Transition { NumberAnimation { property: "opacity"; to: 0; duration: 80 } }
}
