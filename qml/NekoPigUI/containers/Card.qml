// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Effects
import NekoPigUI 1.0 as NP
import QtQuick.Controls.Basic as Basic

// 由 Pane 承载子内容，卡片统一提供内边距和背景
Basic.Pane {
    padding: NP.Theme.padding

    background: Rectangle {
        radius: NP.Theme.radiusLarge
        color: NP.Theme.surface

        // 阴影只作用于卡片背景，内容保持清晰
        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowColor: NP.Theme.cardShadow
            shadowOpacity: NP.Theme.dark ? 0.4 : 0.25
            shadowBlur: 0.8
            blurMax: 24
            shadowVerticalOffset: 4
            shadowHorizontalOffset: 0
        }
    }
}
