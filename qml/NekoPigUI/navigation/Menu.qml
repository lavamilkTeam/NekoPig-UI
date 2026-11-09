// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic
import NekoPigUI 1.0 as NP

Basic.Menu {
    padding: 6
    margins: 12
    overlap: 4
    // 固定使用 QML 弹层，确保各平台显示同一套主题
    popupType: Basic.Popup.Item
    delegate: NP.MenuItem { }
    background: NP.Card { implicitWidth: 200; padding: 0 }
    enter: Transition { NumberAnimation { property: "opacity"; from: 0; to: 1; duration: 120 } }
    exit: Transition { NumberAnimation { property: "opacity"; to: 0; duration: 80 } }
}
