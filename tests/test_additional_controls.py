# SPDX-License-Identifier: GPL-3.0-only
"""通过公开组件验证弹层、导航、状态和滚动行为"""

import unittest
from time import monotonic
from pathlib import Path

from PySide6.QtCore import Q_ARG, QMetaObject, QPoint, QPointF, Qt, QUrl
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuick import QQuickItem
from PySide6.QtTest import QTest

ROOT = Path(__file__).resolve().parents[1]
APP = QGuiApplication.instance() or QGuiApplication([])


class AdditionalControlsTest(unittest.TestCase):
    def setUp(self):
        self.engine = QQmlApplicationEngine()
        self.engine.addImportPath(str(ROOT / "qml"))
        self.qml_warnings = []
        self.engine.warnings.connect(lambda warnings: self.qml_warnings.extend(str(w) for w in warnings))
        self.engine.load(QUrl.fromLocalFile(str(ROOT / "tests" / "AdditionalControls.qml")))
        self.assertTrue(self.engine.rootObjects(), "Public module failed to load")
        self.window = self.engine.rootObjects()[0]
        self.assertTrue(QTest.qWaitForWindowExposed(self.window))

    def tearDown(self):
        self.window.close()
        self.engine.deleteLater()
        APP.processEvents()
        self.assertEqual(self.qml_warnings, [])

    def click(self, item):
        point = item.mapToScene(QPointF(item.width() / 2, item.height() / 2)).toPoint()
        QTest.mouseClick(self.window, Qt.LeftButton, pos=point)

    def open_popup(self, name, wait=260):
        popup = self.window.property(name)
        self.assertTrue(QMetaObject.invokeMethod(popup, "open"))
        QTest.qWait(wait)
        self.assertTrue(popup.property("opened"))
        return popup

    def test_tabs_click_and_keyboard(self):
        tabs = self.window.findChild(QQuickItem, "tabs")
        first = self.window.findChild(QQuickItem, "firstTab")
        second = self.window.findChild(QQuickItem, "secondTab")
        self.click(second)
        self.assertEqual(tabs.property("currentIndex"), 1)
        self.assertTrue(second.property("checked"))
        self.assertFalse(first.property("checked"))
        first.forceActiveFocus()
        QTest.keyClick(self.window, Qt.Key_Space)
        self.assertEqual(tabs.property("currentIndex"), 0)

    def test_popup_close_button_escape_and_outside(self):
        popup = self.open_popup("panel")
        self.click(self.window.findChild(QQuickItem, "closePopup"))
        QTest.qWait(150)
        self.assertFalse(popup.property("visible"))
        self.open_popup("panel")
        QTest.keyClick(self.window, Qt.Key_Escape)
        QTest.qWait(150)
        self.assertFalse(popup.property("visible"))
        self.open_popup("panel")
        QTest.mouseClick(self.window, Qt.LeftButton, pos=QPoint(550, 550))
        QTest.qWait(150)
        self.assertFalse(popup.property("visible"))

    def test_dialog_standard_buttons_and_modal_behavior(self):
        dialog = self.open_popup("dialogControl")
        QTest.mouseClick(self.window, Qt.LeftButton, pos=QPoint(30, 30))
        self.assertTrue(dialog.property("visible"))
        self.click(self.window.property("okButton"))
        QTest.qWait(180)
        self.assertEqual(self.window.property("acceptedCount"), 1)
        self.assertFalse(dialog.property("visible"))
        self.open_popup("dialogControl")
        self.click(self.window.property("cancelButton"))
        QTest.qWait(180)
        self.assertEqual(self.window.property("rejectedCount"), 1)
        self.assertFalse(dialog.property("visible"))

    def test_drawer_open_and_outside_close(self):
        drawer = self.open_popup("drawerControl", 320)
        self.assertAlmostEqual(drawer.property("position"), 1)
        content = drawer.property("contentItem")
        self.assertEqual(content.x(), drawer.property("padding"))
        self.assertEqual(content.y(), drawer.property("padding"))
        self.assertEqual(content.width(), drawer.property("width") - 2 * drawer.property("padding"))
        QTest.mouseClick(self.window, Qt.LeftButton, pos=QPoint(500, 400))
        QTest.qWait(260)
        self.assertFalse(drawer.property("visible"))
        self.assertAlmostEqual(drawer.property("position"), 0)

    def test_menu_checkable_and_keyboard_submenu(self):
        menu = self.open_popup("menuControl")
        item = self.window.findChild(QQuickItem, "checkableMenuItem")
        self.click(item)
        QTest.qWait(120)
        self.assertTrue(item.property("checked"))
        self.assertEqual(self.window.property("menuCount"), 1)
        self.assertFalse(menu.property("visible"))
        self.open_popup("menuControl")
        menu.setProperty("currentIndex", 0)
        QTest.keyClick(self.window, Qt.Key_Down)
        QTest.keyClick(self.window, Qt.Key_Right)
        QTest.qWait(200)
        self.assertTrue(self.window.property("nestedMenu").property("visible"))
        QTest.keyClick(self.window, Qt.Key_Down)
        QTest.keyClick(self.window, Qt.Key_Return)
        QTest.qWait(150)
        self.assertEqual(self.window.property("nestedCount"), 1)
        self.assertFalse(menu.property("visible"))

    def test_tooltip_timeout(self):
        tip = self.window.property("tipControl")
        self.assertTrue(QMetaObject.invokeMethod(tip, "show", Q_ARG(str, "Tip"), Q_ARG(int, 300)))
        QTest.qWait(150)
        self.assertTrue(tip.property("visible"))
        # 等待关闭状态，给计时器和退出动画留出调度余量
        deadline = monotonic() + 1.5
        while tip.property("visible") and monotonic() < deadline:
            QTest.qWait(20)
        self.assertFalse(tip.property("visible"))

    def test_scrollbar_drag_moves_content(self):
        bar = self.window.property("verticalBar")
        content = self.window.property("scrollContent")
        QTest.qWait(50)
        self.assertLess(bar.property("size"), 1)
        thumb = bar.property("contentItem")
        start = thumb.mapToScene(QPointF(thumb.width() / 2, thumb.height() / 2)).toPoint()
        end = bar.mapToScene(QPointF(bar.width() / 2, bar.height() - 5)).toPoint()
        QTest.mousePress(self.window, Qt.LeftButton, pos=start)
        QTest.mouseMove(self.window, end, delay=40)
        QTest.mouseRelease(self.window, Qt.LeftButton, pos=end)
        self.assertGreater(content.property("contentY"), 200)
        self.assertGreater(bar.property("position"), 0.4)

    def test_progress_and_loading_animation_lifecycle(self):
        progress = self.window.findChild(QQuickItem, "progress")
        fill = progress.property("contentItem").childItems()[0]
        self.assertAlmostEqual(progress.property("position"), 0.5)
        self.assertAlmostEqual(fill.width(), progress.width() / 2)
        progress.setProperty("value", 110)
        self.assertAlmostEqual(fill.width(), progress.width())
        progress.setProperty("indeterminate", True)
        QTest.qWait(60)
        before = (fill.x(), fill.width())
        QTest.qWait(100)
        self.assertNotEqual((fill.x(), fill.width()), before)
        busy = self.window.findChild(QQuickItem, "busy")
        spinner = busy.property("contentItem")
        rotation = spinner.rotation()
        QTest.qWait(100)
        self.assertNotEqual(spinner.rotation(), rotation)
        busy.setProperty("running", False)
        QTest.qWait(20)
        stopped = spinner.rotation()
        QTest.qWait(100)
        self.assertEqual(spinner.rotation(), stopped)
        self.assertEqual(spinner.opacity(), 0)


if __name__ == "__main__":
    unittest.main()
