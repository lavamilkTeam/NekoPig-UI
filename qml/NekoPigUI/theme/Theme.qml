// SPDX-License-Identifier: GPL-3.0-only
pragma Singleton
import QtQuick

QtObject {
    id: theme

    // 所有组件共享主题状态，主题层不引用具体控件
    property bool dark: false
    property color accent: dark ? "#FFFFFF" : "#303030"
    property color accentText: dark ? "#303030" : "#FFFFFF"
    // 保留旧属性名，颜色绑定统一使用 accentText
    property alias onAccent: theme.accentText

    readonly property color background: dark ? "#303030" : "#FFFFFF"
    readonly property color surface: dark ? "#383838" : "#F7F7F7"
    readonly property color selectionSurface: dark ? "#484848" : "#E8E8E8"
    readonly property color radioDot: dark ? "#0A84FF" : "#007AFF"
    readonly property color sliderFill: dark ? "#0A84FF" : "#0866D8"
    readonly property color sliderTrack: dark ? "#4A4A46" : "#E0DDD1"
    readonly property color sliderHandle: "#FFFFFF"
    readonly property color cardShadow: dark ? "#000000" : "#808080"
    readonly property color overlayScrim: dark ? "#80000000" : "#33000000"
    readonly property color text: dark ? "#FFFFFF" : "#303030"
    readonly property color mutedText: dark ? "#BFBFBF" : "#6B6B6B"
    readonly property color border: "#858585"
    readonly property color borderSubtle: dark ? "#555555" : "#D6D6D6"
    readonly property color borderFocus: dark ? "#888888" : "#B4B4B4"
    readonly property color disabled: dark ? "#414141" : "#EDEDED"
    readonly property color danger: dark ? "#FFACAC" : "#B42332"
    readonly property color windowClose: "#FF5F57"
    readonly property color windowMinimize: "#FF9F0A"
    readonly property color windowMaximize: "#28C840"

    readonly property int controlHeight: 44
    readonly property int radius: 10
    readonly property int radiusLarge: 12
    readonly property int spacing: 12
    readonly property int padding: 16
    readonly property int bodySize: 15
}
