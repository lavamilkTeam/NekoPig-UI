// SPDX-License-Identifier: GPL-3.0-only
import QtQuick

Row {
    id: controls

    property bool maximized: false

    signal closeRequested()
    signal minimizeRequested()
    signal maximizeRequested()
    signal restoreRequested()

    spacing: 2

    WindowButton {
        operation: WindowButton.Close
        onClicked: controls.closeRequested()
    }

    WindowButton {
        operation: WindowButton.Minimize
        onClicked: controls.minimizeRequested()
    }

    WindowButton {
        operation: WindowButton.Maximize
        maximized: controls.maximized
        onClicked: {
            if (controls.maximized)
                controls.restoreRequested();
            else
                controls.maximizeRequested();
        }
    }
}
