// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import NekoPigUI 1.0 as NP
import QtQuick.Controls.Basic as Basic
import QtQuick.Shapes

Basic.Button {
    id: control

    enum Operation { Close, Minimize, Maximize }

    property int operation: WindowButton.Close
    property bool maximized: false
    property real diameter: 18

    implicitWidth: Math.max(32, diameter + 10)
    implicitHeight: Math.max(32, diameter + 10)
    padding: 0
    horizontalPadding: 0
    verticalPadding: 0
    hoverEnabled: true
    text: operation === WindowButton.Close ? qsTr("Close")
        : operation === WindowButton.Minimize ? qsTr("Minimize")
        : maximized ? qsTr("Restore") : qsTr("Maximize")
    Accessible.name: text

    NP.ToolTip {
        visible: control.hovered && control.enabled
        delay: 600
        text: control.text
    }

    background: Item {
        Rectangle {
            anchors.centerIn: parent
            anchors.alignWhenCentered: false
            width: control.diameter + 6
            height: width
            radius: width / 2
            color: "transparent"
            border.color: NP.Theme.text
            border.width: 1
            visible: control.visualFocus
            antialiasing: true
        }

        Shape {
            id: disc
            anchors.centerIn: parent
            anchors.alignWhenCentered: false
            width: control.diameter
            height: width
            antialiasing: true
            preferredRendererType: Shape.CurveRenderer

            readonly property color baseColor: control.operation === WindowButton.Close
                ? NP.Theme.windowClose : control.operation === WindowButton.Minimize
                ? NP.Theme.windowMinimize : NP.Theme.windowMaximize

            readonly property color color: !control.enabled ? NP.Theme.disabled
                : control.down ? Qt.darker(baseColor, 1.2)
                : control.hovered ? Qt.darker(baseColor, 1.08) : baseColor

            ShapePath {
                strokeColor: "transparent"
                fillColor: disc.color

                PathAngleArc {
                    centerX: disc.width / 2
                    centerY: disc.height / 2
                    radiusX: disc.width / 2
                    radiusY: disc.height / 2
                    startAngle: 0
                    sweepAngle: 360
                }
            }
        }
    }

    contentItem: Item {
        opacity: control.enabled ? 1 : 0.4

        Item {
            id: glyph
            anchors.centerIn: parent
            anchors.alignWhenCentered: false
            // 使用偶数尺寸，让方形轮廓在局部像素网格上保持对称
            width: Math.max(2, Math.round(control.diameter * 0.45 / 2) * 2)
            height: width

            Shape {
                anchors.fill: parent
                antialiasing: true
                preferredRendererType: Shape.CurveRenderer
                visible: control.operation === WindowButton.Minimize

                ShapePath {
                    strokeColor: "#000000"
                    strokeWidth: 2
                    capStyle: ShapePath.RoundCap
                    fillColor: "transparent"
                    startX: 1
                    startY: glyph.height / 2

                    PathLine {
                        x: glyph.width - 1
                        y: glyph.height / 2
                    }
                }
            }

            Item {
                anchors.fill: parent
                visible: control.operation === WindowButton.Close

                component DiagonalStroke: Shape {
                    id: stroke
                    antialiasing: true
                    preferredRendererType: Shape.CurveRenderer

                    ShapePath {
                        strokeColor: "#000000"
                        strokeWidth: 2
                        capStyle: ShapePath.RoundCap
                        fillColor: "transparent"
                        startX: 1
                        startY: 1

                        PathLine {
                            x: stroke.width - 1
                            y: stroke.height - 1
                        }
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

            component SquareOutline: Shape {
                id: square
                property color fill: "transparent"
                antialiasing: true
                preferredRendererType: Shape.CurveRenderer

                ShapePath {
                    strokeColor: "#000000"
                    strokeWidth: 1.3
                    fillColor: square.fill

                    PathRectangle {
                        x: 0.65
                        y: 0.65
                        width: square.width - 1.3
                        height: square.height - 1.3
                        radius: 1.2
                    }
                }
            }

            SquareOutline {
                x: 2
                width: glyph.width - 2
                height: glyph.height - 2
                visible: control.operation === WindowButton.Maximize && control.maximized
            }

            SquareOutline {
                y: control.maximized ? 2 : 0
                width: glyph.width - (control.maximized ? 2 : 0)
                height: glyph.height - (control.maximized ? 2 : 0)
                fill: disc.color
                visible: control.operation === WindowButton.Maximize
            }
        }
    }
}
