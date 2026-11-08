// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic
import NekoPigUI 1.0 as NP

Basic.ApplicationWindow {
    id: window
    width: 400
    height: 300
    visible: true
    property int clicks: 0
    property color accent: NP.Theme.accent
    property color legacyAccentText: NP.Theme.onAccent
    property int closeRequests: 0
    property int minimizeRequests: 0
    property int maximizeRequests: 0
    property int restoreRequests: 0
    property bool testMaximized: false

    function setDark(value: bool) { NP.Theme.dark = value; }

    NP.Button {
        objectName: "button"
        x: 20
        y: 20
        text: "Activate"
        onClicked: window.clicks += 1
    }

    NP.TextField {
        objectName: "field"
        x: 20
        y: 90
        Accessible.name: "Name"
    }

    NP.CheckBox {
        objectName: "checkbox"
        x: 20
        y: 160
        text: "Enabled"
    }

    NP.WindowControls {
        objectName: "windowControls"
        x: 20
        y: 230
        maximized: window.testMaximized
        onCloseRequested: window.closeRequests += 1
        onMinimizeRequested: window.minimizeRequests += 1
        onMaximizeRequested: {
            window.maximizeRequests += 1;
            window.testMaximized = true;
        }
        onRestoreRequested: {
            window.restoreRequests += 1;
            window.testMaximized = false;
        }
    }

    NP.WindowButton {
        objectName: "standaloneClose"
        x: 180
        y: 230
        operation: NP.WindowButton.Close
        onClicked: window.closeRequests += 1
    }
}
