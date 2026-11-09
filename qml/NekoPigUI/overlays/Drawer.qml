// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic
import NekoPigUI 1.0 as NP

Basic.Drawer {
    id: control
    padding: NP.Theme.padding
    // 覆盖 Basic 按抽屉方向设置的边距，让内容保留统一留白
    topPadding: control.padding
    bottomPadding: control.padding
    leftPadding: control.padding
    rightPadding: control.padding
    modal: true
    focus: true
    background: Rectangle {
        color: NP.Theme.surface
        border.width: 1
        border.color: NP.Theme.borderSubtle
    }
    Basic.Overlay.modal: Rectangle { color: NP.Theme.overlayScrim }
    Basic.Overlay.modeless: Rectangle { color: "transparent" }
    enter: Transition { NumberAnimation { property: "position"; duration: 220; easing.type: Easing.OutCubic } }
    exit: Transition { NumberAnimation { property: "position"; duration: 180; easing.type: Easing.InOutCubic } }
}
