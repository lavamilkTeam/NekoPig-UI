// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Shapes
import QtQuick.Controls.Basic as Basic
import NekoPigUI 1.0 as NP

Basic.Slider {
    id: control

    implicitWidth: horizontal ? 240 : NP.Theme.controlHeight
    implicitHeight: horizontal ? NP.Theme.controlHeight : 240
    padding: 0
    hoverEnabled: true

    background: Rectangle {
        id: track
        x: control.leftPadding + (control.horizontal ? 0 : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal ? (control.availableHeight - height) / 2 : 0)
        width: control.horizontal ? control.availableWidth : 24
        height: control.horizontal ? 24 : control.availableHeight
        radius: Math.min(width, height) / 2
        color: NP.Theme.sliderTrack
        opacity: control.enabled ? 1 : 0.45
        // 镜像布局时翻转轨道，进度方向与滑块保持一致
        scale: control.horizontal && control.mirrored ? -1 : 1

        Rectangle {
            y: control.horizontal ? 0 : track.height - height
            // 按滑块中心计算填充，并将末端圆弧藏在滑块下，避免低数值时出现灰色缝隙
            width: control.horizontal
                ? control.position * (track.width - knob.width) + knob.width / 2 + track.radius
                : track.width
            height: control.horizontal ? track.height
                : control.position * (track.height - knob.height) + knob.height / 2 + track.radius
            radius: track.radius
            color: NP.Theme.sliderFill
        }
    }

    handle: Item {
        id: knob
        implicitWidth: 28
        implicitHeight: 28
        x: control.leftPadding + (control.horizontal
            ? control.visualPosition * (control.availableWidth - width) : (control.availableWidth - width) / 2)
        y: control.topPadding + (control.horizontal
            ? (control.availableHeight - height) / 2 : control.visualPosition * (control.availableHeight - height))
        opacity: control.enabled ? 1 : 0.65
        // 直接渲染圆形曲线，避免离屏纹理和模糊投影软化边缘
        Shape {
            anchors.fill: parent
            preferredRendererType: Shape.CurveRenderer

            ShapePath {
                id: outline
                strokeWidth: control.visualFocus ? 2 : 1
                strokeColor: control.visualFocus ? NP.Theme.sliderFill : NP.Theme.borderSubtle
                fillColor: NP.Theme.sliderHandle

                PathAngleArc {
                    centerX: knob.width / 2
                    centerY: knob.height / 2
                    radiusX: (knob.width - outline.strokeWidth) / 2
                    radiusY: (knob.height - outline.strokeWidth) / 2
                    startAngle: 0
                    sweepAngle: 360
                }
            }
        }
    }
}
