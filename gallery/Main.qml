// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic
import QtQuick.Layouts
import NekoPigUI 1.0 as NP

Basic.ApplicationWindow {
    id: window
    width: 720
    height: 540
    minimumWidth: 360
    minimumHeight: 480
    visible: true
    title: "NekoPigUI Gallery"
    color: NP.Theme.background

    property int clickCount: 0

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: NP.Theme.spacing

        RowLayout {
            Layout.fillWidth: true
            spacing: NP.Theme.spacing

            NP.WindowControls {
                maximized: window.visibility === Window.Maximized
                onCloseRequested: window.close()
                onMinimizeRequested: window.showMinimized()
                onMaximizeRequested: window.showMaximized()
                onRestoreRequested: window.showNormal()
            }

            Basic.Label {
                Layout.fillWidth: true
                text: "NekoPigUI"
                color: NP.Theme.text
                font.pixelSize: 28
            }
        }

        NP.CheckBox {
            text: "Dark theme"
            checked: NP.Theme.dark
            onToggled: NP.Theme.dark = checked
        }

        NP.Card {
            Layout.fillWidth: true

            contentItem: ColumnLayout {
                spacing: NP.Theme.spacing

                Basic.Label {
                    text: "Name"
                    color: NP.Theme.text
                }

                NP.TextField {
                    Layout.fillWidth: true
                    placeholderText: "NekoPig"
                    Accessible.name: "Name"
                }

                NP.CheckBox {
                    text: "Enable notifications"
                    checked: true
                }

                NP.Button {
                    text: "Click count: " + window.clickCount
                    onClicked: window.clickCount += 1
                }

                NP.Button {
                    text: "Disabled"
                    enabled: false
                }
            }
        }

        Item { Layout.fillHeight: true }
    }
}
