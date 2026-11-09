// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic
import NekoPigUI 1.0 as NP

Basic.ProgressBar {
    id: control
    implicitWidth: 240
    implicitHeight: 8
    padding: 0

    background: Rectangle {
        radius: height / 2
        color: NP.Theme.disabled
    }

    contentItem: Item {
        id: track
        scale: control.mirrored ? -1 : 1

        Rectangle {
            id: fill
            // 先计算轨道内可见的长度，再绘制圆弧，避免矩形裁切削平端点
            readonly property real segmentWidth: track.width * 0.3
            readonly property real segmentX: travel * (track.width + segmentWidth) - segmentWidth
            width: control.indeterminate
                ? Math.max(0, Math.min(track.width, segmentX + segmentWidth) - Math.max(0, segmentX))
                : control.position * track.width
            height: control.indeterminate ? Math.min(track.height, width) : track.height
            y: (track.height - height) / 2
            radius: height / 2
            color: control.enabled ? NP.Theme.sliderFill : NP.Theme.mutedText
            x: control.indeterminate ? Math.max(0, segmentX) : 0
            property real travel: 0

            // 不确定进度只在可见时播放，隐藏后停止占用动画帧
            NumberAnimation {
                target: fill
                property: "travel"
                from: 0
                to: 1
                duration: 1200
                loops: Animation.Infinite
                running: control.indeterminate && control.visible && control.enabled
                easing.type: Easing.InOutCubic
            }
        }
    }
}
