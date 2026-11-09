// SPDX-License-Identifier: GPL-3.0-only
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.Basic as Basic
import QtQuick.Layouts
import NekoPigUI 1.0 as NP

NP.ScrollView {
    id: preview
    contentWidth: availableWidth
    contentHeight: body.implicitHeight + 24
    Basic.ScrollBar.horizontal.policy: Basic.ScrollBar.AlwaysOff

    ColumnLayout {
        id: body
        x: 12
        y: 12
        width: preview.availableWidth - 24
        spacing: NP.Theme.spacing

        NP.Card {
            Layout.fillWidth: true
            contentItem: ColumnLayout {
                spacing: NP.Theme.spacing
                Basic.Label { text: "进度"; color: NP.Theme.text; font.pixelSize: 18 }
                RowLayout {
                    Layout.fillWidth: true
                    NP.ProgressBar {
                        Layout.fillWidth: true
                        from: 0
                        to: 100
                        value: progress.value
                        Accessible.name: "完成进度"
                    }
                    Basic.Label { text: Math.round(progress.value) + "%"; color: NP.Theme.text }
                }
                NP.Slider {
                    id: progress
                    Layout.fillWidth: true
                    from: 0
                    to: 100
                    value: 45
                    stepSize: 1
                    Accessible.name: "调整进度"
                }
                RowLayout {
                    NP.BusyIndicator { running: loading.checked; Accessible.name: "加载中" }
                    NP.Switch { id: loading; text: "加载"; checked: true }
                }
                NP.ProgressBar {
                    Layout.fillWidth: true
                    indeterminate: loading.checked
                    value: loading.checked ? 0 : 1
                    Accessible.name: "不确定进度"
                }
            }
        }

        NP.Card {
            Layout.fillWidth: true
            contentItem: ColumnLayout {
                spacing: NP.Theme.spacing
                Basic.Label { text: "滚动容器"; color: NP.Theme.text; font.pixelSize: 18 }
                NP.ScrollView {
                    id: list
                    Layout.fillWidth: true
                    Layout.preferredHeight: 220
                    contentWidth: availableWidth
                    contentHeight: rows.implicitHeight
                    Basic.ScrollBar.vertical.policy: Basic.ScrollBar.AlwaysOn
                    Basic.ScrollBar.horizontal.policy: Basic.ScrollBar.AlwaysOff
                    Column {
                        id: rows
                        width: list.availableWidth - 14
                        spacing: 4
                        Repeater {
                            model: 16
                            NP.Button {
                                required property int index
                                width: rows.width
                                height: NP.Theme.controlHeight
                                padding: 12
                                text: "项目 " + (index + 1)
                                // 复用按钮的透明样式，列表中只保留一个选中项
                                flat: true
                                checkable: true
                                autoExclusive: true
                                horizontalAlignment: Text.AlignLeft
                            }
                        }
                    }
                }
            }
        }
    }
}
