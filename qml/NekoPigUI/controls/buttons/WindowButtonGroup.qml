// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import NekoPigUI 1.0 as NP

Row {
    id: controls

    property bool maximized: false

    // 只发出操作请求，具体窗口行为由应用层处理
    signal closeRequested()
    signal minimizeRequested()
    signal maximizeRequested()
    signal restoreRequested()

    spacing: 2

    NP.WindowButton {
        operation: NP.WindowButton.Close
        onClicked: controls.closeRequested()
    }

    NP.WindowButton {
        operation: NP.WindowButton.Minimize
        onClicked: controls.minimizeRequested()
    }

    NP.WindowButton {
        operation: NP.WindowButton.Maximize
        maximized: controls.maximized
        onClicked: {
            if (controls.maximized)
                controls.restoreRequested();
            else
                controls.maximizeRequested();
        }
    }
}
