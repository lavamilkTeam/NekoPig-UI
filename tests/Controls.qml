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
}
