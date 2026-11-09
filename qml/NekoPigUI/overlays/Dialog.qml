// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic
import NekoPigUI 1.0 as NP

Basic.Dialog {
    id: control
    padding: NP.Theme.padding
    spacing: 8
    margins: 16
    modal: true
    focus: true
    popupType: Basic.Popup.Item
    closePolicy: Basic.Popup.CloseOnEscape
    background: NP.Card { padding: 0 }
    header: Basic.Label {
        text: control.title
        visible: text.length > 0
        padding: NP.Theme.padding
        bottomPadding: 0
        color: NP.Theme.text
        font.pixelSize: 18
        font.bold: true
        elide: Text.ElideRight
    }
    // Dialog 自动连接按钮组的接受和取消信号
    footer: NP.DialogButtonBox {
        standardButtons: control.standardButtons
        visible: count > 0
    }
    Basic.Overlay.modal: Rectangle { color: NP.Theme.overlayScrim }
    Basic.Overlay.modeless: Rectangle { color: "transparent" }
    enter: Transition {
        ParallelAnimation {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 160 }
            NumberAnimation { property: "scale"; from: 0.96; to: 1; duration: 160; easing.type: Easing.OutCubic }
        }
    }
    exit: Transition { NumberAnimation { property: "opacity"; to: 0; duration: 100 } }
}
