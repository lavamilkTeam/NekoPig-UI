// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Shapes
import NekoPigUI 1.0 as NP

Item {
    id: backdrop
    property bool selected: false
    property real radius: 6
    property real reveal: selected ? 1 : 0

    Behavior on reveal {
        NumberAnimation { duration: 360; easing.type: Easing.OutQuad }
    }

    // 灰色波纹从左上角扩散，渐变始终限制在圆角背景内
    Shape {
        id: ripple
        anchors.fill: parent
        preferredRendererType: Shape.CurveRenderer
        visible: backdrop.reveal > 0
        opacity: backdrop.enabled ? 1 : 0.4

        ShapePath {
            strokeColor: "transparent"
            fillGradient: RadialGradient {
                centerX: 0
                centerY: 0
                focalX: 0
                focalY: 0
                centerRadius: Math.max(1, backdrop.reveal
                    * Math.sqrt(ripple.width * ripple.width + ripple.height * ripple.height) / 0.8)
                GradientStop { position: 0; color: NP.Theme.selectionSurface }
                GradientStop { position: 0.8; color: NP.Theme.selectionSurface }
                GradientStop { position: 1; color: "transparent" }
            }
            PathRectangle {
                width: ripple.width
                height: ripple.height
                radius: backdrop.radius
            }
        }
    }
}
