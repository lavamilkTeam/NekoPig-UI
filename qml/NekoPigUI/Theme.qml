// SPDX-License-Identifier: GPL-3.0-only
pragma Singleton
import QtQuick

QtObject {
    property bool dark: false
    property color accent: dark ? "#FFFFFF" : "#303030"
    property color onAccent: dark ? "#303030" : "#FFFFFF"

    readonly property color background: dark ? "#303030" : "#FFFFFF"
    readonly property color surface: dark ? "#383838" : "#F7F7F7"
    readonly property color text: dark ? "#FFFFFF" : "#303030"
    readonly property color mutedText: dark ? "#BFBFBF" : "#6B6B6B"
    readonly property color border: "#858585"
    readonly property color disabled: dark ? "#414141" : "#EDEDED"
    readonly property color danger: dark ? "#FFACAC" : "#B42332"
    readonly property color windowClose: "#FF5F57"
    readonly property color windowMinimize: "#FF9F0A"
    readonly property color windowMaximize: "#28C840"

    readonly property int controlHeight: 44
    readonly property int radius: 10
    readonly property int spacing: 12
    readonly property int padding: 16
    readonly property int bodySize: 15
}
