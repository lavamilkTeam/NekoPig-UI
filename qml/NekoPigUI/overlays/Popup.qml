// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic
import NekoPigUI 1.0 as NP

Basic.Popup {
    padding: NP.Theme.padding
    margins: 12
    focus: true
    popupType: Basic.Popup.Item
    closePolicy: Basic.Popup.CloseOnEscape | Basic.Popup.CloseOnPressOutside
    background: NP.Card { padding: 0 }
    Basic.Overlay.modal: Rectangle { color: NP.Theme.overlayScrim }
    Basic.Overlay.modeless: Rectangle { color: "transparent" }
    enter: Transition {
        ParallelAnimation {
            NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 140 }
            NumberAnimation { property: "scale"; from: 0.97; to: 1; duration: 140; easing.type: Easing.OutCubic }
        }
    }
    exit: Transition { NumberAnimation { property: "opacity"; to: 0; duration: 90 } }
}
