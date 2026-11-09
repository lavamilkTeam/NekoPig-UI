// SPDX-License-Identifier: GPL-3.0-only
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.Basic as Basic
import NekoPigUI 1.0 as NP

Basic.SpinBox {
    id: control

    implicitWidth: Math.max(160, implicitContentWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(NP.Theme.controlHeight, implicitContentHeight + topPadding + bottomPadding)
    padding: 0
    topPadding: 4
    bottomPadding: 4
    leftPadding: mirrored ? up.indicator.width : down.indicator.width
    rightPadding: mirrored ? down.indicator.width : up.indicator.width
    font.pixelSize: NP.Theme.bodySize
    editable: true
    hoverEnabled: true
    inputMethodHints: Qt.ImhFormattedNumbersOnly
    background: null

    contentItem: TextInput {
        z: 2
        text: control.displayText
        font: control.font
        color: control.enabled ? NP.Theme.text : NP.Theme.mutedText
        selectionColor: NP.Theme.selectionSurface
        selectedTextColor: NP.Theme.text
        horizontalAlignment: Qt.AlignHCenter
        verticalAlignment: Qt.AlignVCenter
        readOnly: !control.editable
        selectByMouse: control.editable
        validator: control.validator
        inputMethodHints: control.inputMethodHints
        clip: true

        // 仅用细线标识键盘焦点，数字区域保持透明
        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 1
            color: NP.Theme.borderFocus
            visible: control.visualFocus
        }
    }

    // 指示器只绘制符号，单击与长按连发由 SpinBox 统一处理
    component StepIndicator: Item {
        id: indicator
        property bool plus: false
        property bool pressed: false
        readonly property color glyphColor: !enabled ? NP.Theme.mutedText
            : pressed ? NP.Theme.radioDot : NP.Theme.text

        implicitWidth: NP.Theme.controlHeight
        implicitHeight: NP.Theme.controlHeight
        height: control.height
        opacity: enabled ? 1 : 0.4

        Rectangle {
            anchors.centerIn: parent
            width: 12
            height: 2
            radius: 1
            color: indicator.glyphColor
        }

        Rectangle {
            anchors.centerIn: parent
            width: 2
            height: 12
            radius: 1
            color: indicator.glyphColor
            visible: indicator.plus
        }
    }

    up.indicator: StepIndicator {
        x: control.mirrored ? 0 : control.width - width
        plus: true
        pressed: control.up.pressed
    }

    down.indicator: StepIndicator {
        x: control.mirrored ? control.width - width : 0
        pressed: control.down.pressed
    }
}
