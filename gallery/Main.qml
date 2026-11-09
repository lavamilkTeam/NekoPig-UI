// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic
import QtQuick.Layouts
import NekoPigUI 1.0 as NP

Basic.ApplicationWindow {
    id: window
    width: 800
    height: 760
    minimumWidth: 420
    minimumHeight: 480
    visible: true
    title: "NekoPigUI Gallery"
    color: NP.Theme.background

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: NP.Theme.spacing

        RowLayout {
            Layout.fillWidth: true
            spacing: NP.Theme.spacing
            NP.WindowButtonGroup {
                maximized: window.visibility === Window.Maximized
                onCloseRequested: window.close()
                onMinimizeRequested: window.showMinimized()
                onMaximizeRequested: window.showMaximized()
                onRestoreRequested: window.showNormal()
            }
            Basic.Label {
                text: "NekoPigUI"
                color: NP.Theme.text
                font.pixelSize: 24
                Layout.fillWidth: true
            }
            NP.Switch {
                text: "深色"
                checked: NP.Theme.dark
                onToggled: NP.Theme.dark = checked
            }
        }

        NP.TabBar {
            id: navigation
            objectName: "galleryTabs"
            Layout.fillWidth: true
            NP.TabButton { text: "基础控件" }
            NP.TabButton { text: "状态与滚动" }
            NP.TabButton { text: "弹层与菜单" }
        }

        StackLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: navigation.currentIndex
            BasicControls { }
            StatusControls { }
            OverlayControls { }
        }
    }
}
