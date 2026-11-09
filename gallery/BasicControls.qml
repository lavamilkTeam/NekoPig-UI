// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic
import QtQuick.Layouts
import NekoPigUI 1.0 as NP

NP.ScrollView {
    id: preview
    property int clickCount: 0
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

                Basic.Label {
                    text: "Name"
                    color: NP.Theme.text
                }

                NP.TextField {
                    Layout.fillWidth: true
                    placeholderText: "NekoPig"
                    Accessible.name: "Name"
                }

                NP.CheckBox {
                    text: "Enable notifications"
                    checked: true
                }

                NP.TextArea {
                    Layout.fillWidth: true
                    placeholderText: "备注"
                    Accessible.name: "备注"
                }

                NP.ComboBox {
                    Layout.fillWidth: true
                    model: ["跟随系统", "浅色外观", "深色外观", "自定义外观"]
                    Accessible.name: "外观选项预览"
                }

                RowLayout {
                    spacing: NP.Theme.spacing

                    NP.RadioButton {
                        text: "标准"
                        checked: true
                    }

                    NP.RadioButton { text: "紧凑" }
                    NP.RadioButton { text: "宽松" }
                }

                NP.Slider {
                    Layout.fillWidth: true
                    Layout.maximumWidth: 320
                    from: 0
                    to: 100
                    value: 50
                    stepSize: 1
                    Accessible.name: "滑块样式预览"
                }

                NP.SpinBox {
                    from: 0
                    to: 100
                    value: 5
                    Accessible.name: "数量"
                }

                NP.Button {
                    text: "Click count: " + preview.clickCount
                    onClicked: preview.clickCount += 1
                }

                NP.Button {
                    text: "Disabled"
                    enabled: false
                }
            }
        }
    }
}
