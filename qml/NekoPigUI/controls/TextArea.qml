// SPDX-License-Identifier: GPL-3.0-only
pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.Basic as Basic
import NekoPigUI 1.0 as NP

Basic.TextArea {
    id: control

    implicitWidth: 320
    implicitHeight: Math.max(128, contentHeight + topPadding + bottomPadding)
    padding: NP.Theme.padding
    font.pixelSize: NP.Theme.bodySize
    textFormat: TextEdit.PlainText
    wrapMode: TextEdit.Wrap
    selectByMouse: true
    clip: true
    color: enabled ? NP.Theme.text : NP.Theme.mutedText
    placeholderTextColor: NP.Theme.mutedText
    selectionColor: NP.Theme.selectionSurface
    selectedTextColor: NP.Theme.text

    background: Rectangle {
        radius: NP.Theme.radiusLarge
        color: control.enabled ? NP.Theme.surface : NP.Theme.disabled
        border.width: 1
        border.color: control.activeFocus ? NP.Theme.borderFocus : NP.Theme.borderSubtle
    }

    // 只为真实回车换行动画，不接管文本插入、撤销或输入法确认
    Keys.priority: Keys.BeforeItem
    Keys.onPressed: function(event) {
        if ((event.key === Qt.Key_Return || event.key === Qt.Key_Enter)
                && !(event.modifiers & (Qt.ControlModifier | Qt.AltModifier | Qt.MetaModifier))
                && !control.readOnly && !control.inputMethodComposing) {
            motion.prepare();
        } else {
            motion.cancel();
        }
        event.accepted = false;
    }

    onCursorRectangleChanged: motion.updateGeometry()
    onCursorPositionChanged: {
        if (!motion.pendingReturn)
            motion.cancel();
    }
    onTextChanged: {
        if (motion.pendingReturn)
            motion.returnEdited = true;
        else
            motion.cancel();
    }
    onActiveFocusChanged: motion.cancel()
    onReadOnlyChanged: motion.cancel()
    onEnabledChanged: motion.cancel()
    onInputMethodComposingChanged: motion.cancel()

    TapHandler {
        onPressedChanged: {
            if (pressed)
                motion.cancel();
        }
    }

    QtObject {
        id: motion
        property bool pendingReturn: false
        property bool returnEdited: false
        property bool blinkOn: true
        property real progress: 1
        property real startX: 0
        property real startY: 0
        property real endX: 0
        property real endY: 0
        property real bendX: 0
        property real bendY: 0
        property real sourceX: 0
        property real sourceY: 0
        property int sourcePosition: 0
        readonly property real remaining: 1 - progress
        readonly property real drawX: remaining * remaining * startX
            + 2 * remaining * progress * bendX + progress * progress * endX
        readonly property real drawY: remaining * remaining * startY
            + 2 * remaining * progress * bendY + progress * progress * endY

        function cancel() {
            pendingReturn = false;
            flight.stop();
            blinkOn = true;
            if (blink.running)
                blink.restart();
        }

        function prepare() {
            const x = pendingReturn || flight.running ? drawX : control.cursorRectangle.x;
            const y = pendingReturn || flight.running ? drawY : control.cursorRectangle.y;
            cancel();
            startX = endX = bendX = x;
            startY = endY = bendY = y;
            sourceX = control.cursorRectangle.x;
            sourceY = control.cursorRectangle.y;
            sourcePosition = control.cursorPosition;
            returnEdited = false;
            progress = 0;
            pendingReturn = true;
            // 等原生编辑器完成换行和排版后，再读取准确的落点
            Qt.callLater(finishReturn);
        }

        function finishReturn() {
            if (!pendingReturn)
                return;
            const rect = control.cursorRectangle;
            if (!control.activeFocus || !control.enabled || control.readOnly
                    || !returnEdited || control.cursorPosition < 1
                    || control.getText(control.cursorPosition - 1, control.cursorPosition) !== "\n") {
                cancel();
                return;
            }
            // 换行可能同时滚动文本，起点需同步到新的显示坐标
            if (control.cursorPosition === sourcePosition + 1) {
                const previous = control.positionToRectangle(sourcePosition);
                startX += previous.x - sourceX;
                startY += previous.y - sourceY;
            }
            endX = rect.x;
            endY = rect.y;
            bendX = (startX + endX) / 2
                + (Math.abs(startX - endX) < 1 ? Math.min(12, rect.height / 2) : 0);
            bendY = endY + Math.min(10, rect.height * 0.45);
            pendingReturn = false;
            flight.restart();
        }

        function updateGeometry() {
            if (pendingReturn || !flight.running)
                return;
            // 自动增高和滚动只更新曲线坐标，不中断仍在进行的换行动画
            const rect = control.cursorRectangle;
            const dx = rect.x - endX;
            const dy = rect.y - endY;
            startX += dx;
            startY += dy;
            bendX += dx;
            bendY += dy;
            endX = rect.x;
            endY = rect.y;
        }
    }

    NumberAnimation {
        id: flight
        target: motion
        property: "progress"
        from: 0
        to: 1
        duration: 240
        easing.type: Easing.InOutCubic
    }

    Timer {
        id: blink
        interval: 500
        repeat: true
        running: control.activeFocus && control.cursorVisible && control.enabled
            && !control.readOnly && !flight.running && !motion.pendingReturn
        onTriggered: motion.blinkOn = !motion.blinkOn
        onRunningChanged: motion.blinkOn = true
    }

    cursorDelegate: Rectangle {
        width: 1.5
        color: NP.Theme.text
        opacity: control.activeFocus && control.enabled && !control.readOnly
            && control.selectionStart === control.selectionEnd
            && (flight.running || motion.pendingReturn || motion.blinkOn) ? 1 : 0

        // 原生光标位置保持准确，仅用位移绘制沿二次贝塞尔曲线运动的光标
        transform: Translate {
            x: flight.running || motion.pendingReturn ? motion.drawX - control.cursorRectangle.x : 0
            y: flight.running || motion.pendingReturn ? motion.drawY - control.cursorRectangle.y : 0
        }
    }
}
