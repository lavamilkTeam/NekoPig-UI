// SPDX-License-Identifier: GPL-3.0-only
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Shapes
import QtQuick.Controls.Basic as Basic
import NekoPigUI 1.0 as NP

Basic.ComboBox {
    id: control

    implicitWidth: 240
    implicitHeight: Math.max(NP.Theme.controlHeight, implicitContentHeight + topPadding + bottomPadding)
    padding: NP.Theme.padding
    topPadding: 10
    bottomPadding: 10
    spacing: 10
    leftPadding: padding + (mirrored ? indicator.width + spacing : 0)
    rightPadding: padding + (mirrored ? 0 : indicator.width + spacing)
    font.pixelSize: NP.Theme.bodySize
    hoverEnabled: true

    indicator: Shape {
        width: 12
        height: 8
        x: control.mirrored ? control.padding : control.width - width - control.padding
        y: (control.height - height) / 2
        preferredRendererType: Shape.CurveRenderer
        rotation: menu.visible ? 180 : 0

        Behavior on rotation {
            NumberAnimation { duration: 160; easing.type: Easing.OutCubic }
        }

        ShapePath {
            strokeWidth: 2
            strokeColor: control.enabled ? NP.Theme.text : NP.Theme.mutedText
            fillColor: "transparent"
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            startX: 1
            startY: 1
            PathLine { x: 6; y: 6 }
            PathLine { x: 11; y: 1 }
        }
    }

    contentItem: Basic.TextField {
        padding: 0
        text: control.editable ? control.editText : control.displayText
        font: control.font
        enabled: control.editable
        autoScroll: control.editable
        readOnly: control.down
        inputMethodHints: control.inputMethodHints
        validator: control.validator
        selectByMouse: control.selectTextByMouse
        color: control.enabled ? NP.Theme.text : NP.Theme.mutedText
        selectionColor: NP.Theme.accent
        selectedTextColor: NP.Theme.accentText
        verticalAlignment: Text.AlignVCenter
        background: null
    }

    background: Rectangle {
        radius: NP.Theme.radiusLarge
        color: control.enabled ? NP.Theme.surface : NP.Theme.disabled
        // 用细浅边线区分轮廓，聚焦时仅略微加深
        border.width: 1
        border.color: control.enabled && (control.activeFocus || control.hovered)
            ? NP.Theme.borderFocus : NP.Theme.borderSubtle
    }

    delegate: Basic.ItemDelegate {
        id: option
        required property int index
        required property var model

        width: options.width
        height: NP.Theme.controlHeight
        text: model[control.textRole]
        font: control.font
        padding: 12
        highlighted: control.highlightedIndex === index
        hoverEnabled: true
        enabled: opacity > 0

        // 按当前可见行排序，长列表滚动时无需等待前面的所有选项
        readonly property int revealOrder: Math.max(0, index - Math.floor(options.contentY / height))
        opacity: menu.opened ? 1 : Math.max(0, Math.min(1,
            (menu.revealTime - revealOrder * menu.rowStagger) / menu.rowDuration))
        transform: Translate { y: -5 * (1 - option.opacity) }

        contentItem: Text {
            text: option.text
            font: option.font
            color: NP.Theme.text
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            x: 4
            y: 3
            width: option.width - 8
            height: option.height - 6
            radius: 8
            // 用浅灰色底色标识当前高亮项
            color: option.highlighted ? NP.Theme.selectionSurface
                : option.hovered ? NP.Theme.disabled : "transparent"
        }
    }

    popup: Basic.Popup {
        id: menu
        y: control.height + 6
        width: control.width
        height: Math.min(options.contentHeight + padding * 2,
            NP.Theme.controlHeight * 6 + padding * 2,
            Math.max(0, control.Window.height - topMargin - bottomMargin))
        padding: 6
        topMargin: 12
        bottomMargin: 12
        popupType: Basic.Popup.Item
        closePolicy: Basic.Popup.CloseOnEscape | Basic.Popup.CloseOnPressOutsideParent

        property real revealTime: 0
        readonly property int rowStagger: 55
        readonly property int rowDuration: 160

        onAboutToShow: revealTime = 0
        onClosed: revealTime = 0

        // 外框先完成淡入，再启动选项的逐行过渡
        enter: Transition {
            SequentialAnimation {
                NumberAnimation {
                    target: menu
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 120
                }
                NumberAnimation {
                    target: menu
                    property: "revealTime"
                    from: 0
                    to: Math.min(control.count, 7) * menu.rowStagger + menu.rowDuration
                    duration: Math.min(control.count, 7) * menu.rowStagger + menu.rowDuration
                }
            }
        }

        exit: Transition {
            NumberAnimation { property: "opacity"; to: 0; duration: 90 }
        }

        contentItem: ListView {
            id: options
            clip: true
            model: menu.visible ? control.delegateModel : null
            currentIndex: control.highlightedIndex
            highlightMoveDuration: 0
            boundsBehavior: Flickable.StopAtBounds
            Basic.ScrollIndicator.vertical: Basic.ScrollIndicator { }
        }

        background: Rectangle {
            radius: NP.Theme.radiusLarge
            color: NP.Theme.surface
            border.width: 1
            border.color: NP.Theme.borderSubtle
        }
    }
}
