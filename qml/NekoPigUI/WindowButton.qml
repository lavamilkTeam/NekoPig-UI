// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic

Basic.Button {
    id: control

    enum Operation { Close, Minimize, Maximize }

    property int operation: WindowButton.Close
    property bool maximized: false
    property real diameter: 18

    implicitWidth: Math.max(32, diameter + 10)
    implicitHeight: Math.max(32, diameter + 10)
    padding: 0
    hoverEnabled: true
    text: operation === WindowButton.Close ? qsTr("Close")
        : operation === WindowButton.Minimize ? qsTr("Minimize")
        : maximized ? qsTr("Restore") : qsTr("Maximize")
    Accessible.name: text

    Basic.ToolTip.visible: hovered
    Basic.ToolTip.delay: 600
    Basic.ToolTip.text: text

    background: Item {
        Rectangle {
            anchors.centerIn: parent
            anchors.alignWhenCentered: false
            width: control.diameter + 6
            height: width
            radius: width / 2
            color: "transparent"
            border.color: Theme.text
            border.width: 1
            visible: control.visualFocus
            antialiasing: true
        }

        Rectangle {
            id: disc
            anchors.centerIn: parent
            anchors.alignWhenCentered: false
            width: control.diameter
            height: width
            radius: width / 2
            antialiasing: true

            readonly property color baseColor: control.operation === WindowButton.Close
                ? Theme.windowClose : control.operation === WindowButton.Minimize
                ? Theme.windowMinimize : Theme.windowMaximize

            color: !control.enabled ? Theme.disabled
                : control.down ? Qt.darker(baseColor, 1.2)
                : control.hovered ? Qt.darker(baseColor, 1.08) : baseColor
        }
    }

    contentItem: Item {
        opacity: control.enabled ? 1 : 0.4

        Item {
            id: glyph
            anchors.centerIn: parent
            anchors.alignWhenCentered: false
            width: control.diameter * 0.45
            height: width

            Rectangle {
                anchors.centerIn: parent
                anchors.alignWhenCentered: false
                width: glyph.width
                height: 1.5
                radius: height / 2
                color: "#000000"
                antialiasing: true
                visible: control.operation === WindowButton.Minimize
            }

            Item {
                anchors.fill: parent
                visible: control.operation === WindowButton.Close

                component DiagonalStroke: Item {
                    id: stroke

                    Rectangle {
                        anchors.centerIn: parent
                        anchors.alignWhenCentered: false
                        width: stroke.width
                        height: 1.5
                        radius: height / 2
                        rotation: 45
                        color: "#000000"
                        antialiasing: true
                    }
                }

                DiagonalStroke {
                    anchors.fill: parent
                }

                DiagonalStroke {
                    anchors.fill: parent
                    transform: Scale {
                        origin.x: glyph.width / 2
                        xScale: -1
                    }
                }
            }

            Rectangle {
                x: 2
                width: glyph.width - 2
                height: glyph.height - 2
                color: "transparent"
                border.color: "#000000"
                border.width: 1.3
                radius: 0.5
                antialiasing: true
                visible: control.operation === WindowButton.Maximize && control.maximized
            }

            Rectangle {
                y: control.maximized ? 2 : 0
                width: glyph.width - (control.maximized ? 2 : 0)
                height: glyph.height - (control.maximized ? 2 : 0)
                color: disc.color
                border.color: "#000000"
                border.width: 1.3
                radius: 0.5
                antialiasing: true
                visible: control.operation === WindowButton.Maximize
            }
        }
    }
}
