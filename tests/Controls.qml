// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic
import NekoPigUI 1.0 as NP

Basic.ApplicationWindow {
    id: window
    width: 400
    height: 600
    visible: true
    property int clicks: 0
    property color accent: NP.Theme.accent
    property color legacyAccentText: NP.Theme.onAccent
    property int closeRequests: 0
    property int minimizeRequests: 0
    property int maximizeRequests: 0
    property int restoreRequests: 0
    property bool testMaximized: false
    property int switchToggles: 0
    property bool switchMirrored: false
    property int comboActivations: 0
    property QtObject comboPopup: combo.popup
    property bool sliderMirrored: false
    property bool spinMirrored: false

    function setDark(value: bool) { NP.Theme.dark = value; }

    NP.TextArea {
        objectName: "textarea"
        x: 280
        y: 20
        width: 110
        height: 120
        Accessible.name: "Notes"
    }

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

    NP.Switch {
        objectName: "switch"
        x: 180
        y: 160
        text: "Wi-Fi"
        LayoutMirroring.enabled: window.switchMirrored
        onToggled: window.switchToggles += 1
    }

    NP.WindowButtonGroup {
        objectName: "windowButtonGroup"
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

    NP.ComboBox {
        id: combo
        objectName: "combo"
        x: 20
        y: 300
        model: ["First", "Second", "Third", "Fourth"]
        Accessible.name: "Options"
        onActivated: window.comboActivations += 1
    }

    NP.Slider {
        objectName: "slider"
        x: 20
        y: 440
        width: 240
        from: 0
        to: 100
        value: 50
        stepSize: 10
        LayoutMirroring.enabled: window.sliderMirrored
        Accessible.name: "Level"
    }

    NP.SpinBox {
        objectName: "spinbox"
        x: 20
        y: 370
        from: 0
        to: 100
        value: 50
        stepSize: 2
        LayoutMirroring.enabled: window.spinMirrored
        Accessible.name: "Quantity"
    }

    Row {
        x: 20
        y: 520
        spacing: 12

        NP.RadioButton {
            objectName: "radioFirst"
            text: "First"
            checked: true
        }

        NP.RadioButton {
            objectName: "radioSecond"
            text: "Second"
        }

        NP.RadioButton {
            objectName: "radioDisabled"
            text: "Disabled"
            enabled: false
        }
    }
}
