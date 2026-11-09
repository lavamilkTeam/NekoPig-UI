// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic
import NekoPigUI 1.0 as NP

Basic.DialogButtonBox {
    padding: NP.Theme.padding
    spacing: 8
    alignment: Qt.AlignRight
    delegate: NP.Button { }
    background: null
}
