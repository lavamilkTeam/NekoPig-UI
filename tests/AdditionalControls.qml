// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic
import NekoPigUI 1.0 as NP

Basic.ApplicationWindow {
    id: window
    width: 600
    height: 620
    visible: true
    color: NP.Theme.background
    property int acceptedCount: 0
    property int rejectedCount: 0
    property int menuCount: 0
    property int nestedCount: 0
    property QtObject panel: panel
    property QtObject dialogControl: dialog
    property QtObject drawerControl: drawer
    property QtObject menuControl: menu
    property QtObject nestedMenu: nested
    property QtObject tipControl: tip
    property QtObject verticalBar: scroll.Basic.ScrollBar.vertical
    property QtObject scrollContent: scroll.contentItem
    property Item okButton: null
    property Item cancelButton: null

    function setDark(value: bool) { NP.Theme.dark = value; }

    NP.TabBar {
        id: tabs
        objectName: "tabs"
        x: 20
        y: 20
        width: 400
        NP.TabButton { objectName: "firstTab"; text: "First" }
        NP.TabButton { objectName: "secondTab"; text: "Second" }
        NP.TabButton { text: "Disabled"; enabled: false }
    }

    NP.ProgressBar {
        objectName: "progress"
        x: 20
        y: 100
        width: 300
        from: 10
        to: 110
        value: 60
    }
    NP.BusyIndicator { objectName: "busy"; x: 340; y: 85; running: true }

    NP.ScrollView {
        id: scroll
        x: 20
        y: 160
        width: 240
        height: 120
        contentWidth: availableWidth
        contentHeight: 600
        Basic.ScrollBar.vertical.policy: Basic.ScrollBar.AlwaysOn
        Basic.ScrollBar.horizontal.policy: Basic.ScrollBar.AlwaysOff
        Rectangle { width: scroll.availableWidth; height: 600; color: NP.Theme.selectionSurface }
    }

    NP.Popup {
        id: panel
        parent: window.contentItem
        x: 40
        y: 300
        width: 220
        height: 120
        contentItem: NP.Button { objectName: "closePopup"; text: "Close"; onClicked: panel.close() }
    }

    NP.Dialog {
        id: dialog
        parent: window.contentItem
        x: 150
        y: 100
        width: 300
        title: "Confirm"
        standardButtons: Basic.Dialog.Ok | Basic.Dialog.Cancel
        contentItem: Basic.Label { text: "Name"; color: NP.Theme.text }
        onOpened: {
            window.okButton = standardButton(Basic.Dialog.Ok);
            window.cancelButton = standardButton(Basic.Dialog.Cancel);
        }
        onAccepted: window.acceptedCount += 1
        onRejected: window.rejectedCount += 1
    }

    NP.Drawer {
        id: drawer
        width: 200
        height: window.height
        contentItem: NP.Button { text: "Close"; onClicked: drawer.close() }
    }

    NP.Menu {
        id: menu
        parent: window.contentItem
        x: 300
        y: 240
        NP.MenuItem { objectName: "checkableMenuItem"; text: "Toggle"; checkable: true; onTriggered: window.menuCount += 1 }
        NP.MenuItem { text: "Disabled"; enabled: false }
        NP.MenuSeparator { }
        NP.Menu {
            id: nested
            title: "Nested"
            NP.MenuItem { text: "Child"; onTriggered: window.nestedCount += 1 }
        }
    }

    NP.ToolTip {
        id: tip
        parent: window.contentItem
        x: 20
        y: 300
        delay: 0
        text: "Tip"
    }
}
