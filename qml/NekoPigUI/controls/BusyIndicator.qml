// SPDX-License-Identifier: GPL-3.0-only
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.Basic as Basic
import NekoPigUI 1.0 as NP

Basic.BusyIndicator {
    id: control
    implicitWidth: 32
    implicitHeight: 32
    padding: 0
    background: null

    contentItem: Item {
        id: spinner
        opacity: control.running ? (control.enabled ? 1 : 0.4) : 0

        Repeater {
            model: 8
            Rectangle {
                required property int index
                readonly property real diameter: Math.min(spinner.width, spinner.height)
                width: diameter * 0.14
                height: width
                radius: width / 2
                x: spinner.width / 2 + Math.cos(index * Math.PI / 4) * diameter * 0.36 - width / 2
                y: spinner.height / 2 + Math.sin(index * Math.PI / 4) * diameter * 0.36 - height / 2
                opacity: (index + 1) / 8
                color: NP.Theme.text
            }
        }

        RotationAnimation on rotation {
            from: 0
            to: 360
            duration: 900
            loops: Animation.Infinite
            running: control.running && control.visible && control.enabled
        }
    }
}
