# NekoPigUI 组件结构

所有组件由根目录的 qmldir 注册，使用方统一通过 `import NekoPigUI 1.0 as NP` 导入

```text
NekoPigUI/
├── qmldir
├── impl/
│   └── SelectionRipple.qml
├── containers/
│   ├── Card.qml
│   └── ScrollView.qml
├── controls/
│   ├── buttons/
│   │   ├── Button.qml
│   │   ├── DialogButtonBox.qml
│   │   ├── TabButton.qml
│   │   ├── WindowButton.qml
│   │   └── WindowButtonGroup.qml
│   ├── BusyIndicator.qml
│   ├── CheckBox.qml
│   ├── ComboBox.qml
│   ├── ProgressBar.qml
│   ├── RadioButton.qml
│   ├── ScrollBar.qml
│   ├── Slider.qml
│   ├── SpinBox.qml
│   ├── Switch.qml
│   ├── TextArea.qml
│   └── TextField.qml
├── navigation/
│   ├── Menu.qml
│   ├── MenuItem.qml
│   ├── MenuSeparator.qml
│   └── TabBar.qml
├── overlays/
│   ├── Dialog.qml
│   ├── Drawer.qml
│   ├── Popup.qml
│   └── ToolTip.qml
└── theme/
    └── Theme.qml
```

- `theme` 只提供设计参数，不依赖组件
- `impl` 存放模块内部实现，SelectionRipple 供按钮、单选按钮和页签复用，不对应用导出
- `controls` 提供输入、状态和滚动条，`buttons` 存放按钮及按钮组
- `containers` 承载内容，ScrollView 复用公开的 ScrollBar
- `navigation` 提供页签和菜单，Menu 复用 MenuItem 与 Card
- `overlays` 提供浮层，Dialog 复用 DialogButtonBox，Popup 和 Dialog 复用 Card
- 窗口按钮只发出操作意图，由应用层处理窗口行为
- 示例和测试通过公开模块访问组件，组件库不依赖应用或平台副作用

目录是同一模块内的职责分区，应用不直接导入子目录

WindowControls 已更名为 WindowButtonGroup，信号和属性保持不变

启动、用法与验证命令见 [项目说明](../../README.md)
