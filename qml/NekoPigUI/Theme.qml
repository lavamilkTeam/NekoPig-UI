// SPDX-License-Identifier: GPL-3.0-only
pragma Singleton
import QtQuick

QtObject {
    property bool dark: false
    property color accent: dark ? "#F5A7BC" : "#9F365D"
    property color onAccent: dark ? "#38212A" : "#FFFFFF"

    readonly property color background: dark ? "#201C20" : "#FFF8FA"
    readonly property color surface: dark ? "#2C252B" : "#FFFFFF"
    readonly property color text: dark ? "#F8EBF0" : "#35262E"
    readonly property color mutedText: dark ? "#C6B4BF" : "#76616D"
    readonly property color border: dark ? "#705C69" : "#A18B98"
    readonly property color disabled: dark ? "#40343C" : "#EADFE5"
    readonly property color danger: dark ? "#FFACAC" : "#B42332"

    readonly property int controlHeight: 44
    readonly property int radius: 10
    readonly property int spacing: 12
    readonly property int padding: 16
    readonly property int bodySize: 15
}
