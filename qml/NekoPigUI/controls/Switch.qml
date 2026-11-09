// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import NekoPigUI 1.0 as NP
import QtQuick.Controls.Basic as Basic

Basic.Switch {
    id: control

    implicitWidth: Math.max(implicitIndicatorWidth, implicitContentWidth) + leftPadding + rightPadding
    implicitHeight: Math.max(NP.Theme.controlHeight, implicitContentHeight + topPadding + bottomPadding)
    padding: 0
    spacing: 10
    font.pixelSize: NP.Theme.bodySize
    hoverEnabled: true

    // 点击、拖动和键盘切换均由基础控件处理
    indicator: Rectangle {
        id: track
        implicitWidth: 48
        implicitHeight: 26
        x: control.mirrored ? control.width - control.rightPadding - width : control.leftPadding
        y: (control.height - height) / 2
        radius: height / 2
        color: !control.enabled ? NP.Theme.disabled
            : control.checked ? NP.Theme.accent
            : control.hovered ? Qt.darker(NP.Theme.disabled, 1.06) : NP.Theme.disabled

        Rectangle {
            anchors.fill: parent
            anchors.margins: -3
            radius: height / 2
            color: "transparent"
            border.width: 1
            border.color: NP.Theme.text
            visible: control.visualFocus
        }

        Rectangle {
            width: 20
            height: width
            radius: width / 2
            y: (track.height - height) / 2
            // visualPosition 同时处理拖动位置和从右到左的布局
            x: 3 + control.visualPosition * (track.width - width - 6)
            color: !control.enabled ? NP.Theme.mutedText
                : control.checked ? NP.Theme.accentText : NP.Theme.background
            opacity: control.down ? 0.8 : 1

            // 拖动时直接跟手，释放或点击后平滑滑动
            Behavior on x {
                enabled: !control.down
                NumberAnimation {
                    duration: 160
                    easing.type: Easing.OutCubic
                }
            }
        }
    }

    contentItem: Text {
        text: control.text
        font: control.font
        color: control.enabled ? NP.Theme.text : NP.Theme.mutedText
        leftPadding: control.text && !control.mirrored ? control.indicator.width + control.spacing : 0
        rightPadding: control.text && control.mirrored ? control.indicator.width + control.spacing : 0
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
}
