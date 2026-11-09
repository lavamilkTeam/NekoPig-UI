// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic
import NekoPigUI 1.0 as NP

Basic.MenuSeparator {
    padding: 6
    contentItem: Rectangle {
        implicitWidth: 180
        implicitHeight: 1
        color: NP.Theme.borderSubtle
    }
    background: null
}
