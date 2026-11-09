// SPDX-License-Identifier: GPL-3.0-only
import QtQuick
import QtQuick.Controls.Basic as Basic
import QtQuick.Layouts
import NekoPigUI 1.0 as NP

NP.ScrollView {
    id: preview
    property string feedback: ""
    property string savedName: "NekoPig"
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
                Basic.Label { text: "弹层与菜单"; color: NP.Theme.text; font.pixelSize: 18 }
                Flow {
                    Layout.fillWidth: true
                    spacing: 12
                    NP.Button { text: "弹出面板"; onClicked: settings.open() }
                    NP.Button { text: "对话框"; onClicked: editor.open() }
                    NP.Button { text: "侧边抽屉"; onClicked: drawer.open() }
                    NP.Button {
                        id: menuButton
                        text: "操作菜单"
                        onClicked: actions.open()
                        NP.Menu {
                            id: actions
                            y: menuButton.height + 6
                            NP.MenuItem {
                                text: "查看名称"
                                onTriggered: preview.feedback = preview.savedName
                            }
                            NP.MenuItem {
                                text: "紧凑模式"
                                checkable: true
                                onTriggered: preview.feedback = checked ? "紧凑模式已开启" : "紧凑模式已关闭"
                            }
                            NP.MenuSeparator { }
                            NP.Menu {
                                title: "外观"
                                NP.MenuItem { text: "浅色"; onTriggered: NP.Theme.dark = false }
                                NP.MenuItem { text: "深色"; onTriggered: NP.Theme.dark = true }
                            }
                            NP.MenuItem { text: "不可用操作"; enabled: false }
                        }
                    }
                    NP.Button {
                        id: tipButton
                        text: "悬停提示"
                        NP.ToolTip {
                            text: "这是提示内容"
                            visible: tipButton.hovered
                        }
                    }
                }
                Basic.Label {
                    visible: preview.feedback.length > 0
                    text: preview.feedback
                    color: NP.Theme.text
                    wrapMode: Text.Wrap
                    Layout.fillWidth: true
                }
            }
        }
    }

    NP.Popup {
        id: settings
        parent: Basic.Overlay.overlay
        anchors.centerIn: parent
        width: Math.min(320, parent ? parent.width - 48 : 320)
        contentItem: ColumnLayout {
            spacing: NP.Theme.spacing
            Basic.Label { text: "快捷设置"; color: NP.Theme.text; font.pixelSize: 18 }
            NP.Switch { text: "通知"; checked: true }
            NP.Button { text: "关闭"; onClicked: settings.close() }
        }
    }

    NP.Dialog {
        id: editor
        parent: Basic.Overlay.overlay
        anchors.centerIn: parent
        width: Math.min(360, parent ? parent.width - 48 : 360)
        title: "编辑名称"
        standardButtons: Basic.Dialog.Ok | Basic.Dialog.Cancel
        onOpened: nameField.text = preview.savedName
        onAccepted: {
            preview.savedName = nameField.text;
            preview.feedback = "已保存：" + preview.savedName;
        }
        contentItem: NP.TextField { id: nameField; Accessible.name: "名称" }
    }

    NP.Drawer {
        id: drawer
        width: Math.min(280, parent ? parent.width * 0.8 : 280)
        height: parent ? parent.height : 0
        contentItem: ColumnLayout {
            spacing: NP.Theme.spacing
            Basic.Label { text: "导航"; color: NP.Theme.text; font.pixelSize: 20 }
            NP.Button { text: "首页"; Layout.fillWidth: true; onClicked: { preview.feedback = "首页"; drawer.close(); } }
            NP.Button { text: "收藏"; Layout.fillWidth: true; onClicked: { preview.feedback = "收藏"; drawer.close(); } }
            NP.Button { text: "设置"; Layout.fillWidth: true; onClicked: { preview.feedback = "设置"; drawer.close(); } }
            Item { Layout.fillHeight: true }
            NP.Button { text: "关闭"; Layout.fillWidth: true; onClicked: drawer.close() }
        }
    }
}
