// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic
import NekoPigUI 1.0 as NP

Basic.ScrollView {
    id: control
    clip: true
    background: null

    // 保留原生滚动和尺寸计算，仅替换两条滚动条的样式
    Basic.ScrollBar.vertical: NP.ScrollBar {
        parent: control
        x: control.mirrored ? 0 : control.width - width
        y: control.topPadding
        height: control.availableHeight
    }
    Basic.ScrollBar.horizontal: NP.ScrollBar {
        parent: control
        x: control.leftPadding
        y: control.height - height
        width: control.availableWidth
    }
}
