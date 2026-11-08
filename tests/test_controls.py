# SPDX-License-Identifier: GPL-3.0-only
"""Exercise the installed-style module import and observable input behavior."""

import unittest
from pathlib import Path

from PySide6.QtCore import Q_ARG, QMetaObject, QPoint, Qt, QUrl
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuick import QQuickItem
from PySide6.QtTest import QTest

ROOT = Path(__file__).resolve().parents[1]
APP = QGuiApplication.instance() or QGuiApplication([])


class ControlsTest(unittest.TestCase):
    def setUp(self):
        self.engine = QQmlApplicationEngine()
        self.engine.addImportPath(str(ROOT / "qml"))
        self.engine.load(QUrl.fromLocalFile(str(ROOT / "tests" / "Controls.qml")))
        self.assertTrue(self.engine.rootObjects(), "Public module failed to load")
        self.window = self.engine.rootObjects()[0]
        self.assertTrue(QTest.qWaitForWindowExposed(self.window))

    def tearDown(self):
        self.window.close()
        self.engine.deleteLater()
        APP.processEvents()

    def test_button_mouse_keyboard_and_disabled(self):
        button = self.window.findChild(QQuickItem, "button")
        QTest.mouseClick(self.window, Qt.LeftButton, pos=QPoint(50, 40))
        self.assertEqual(self.window.property("clicks"), 1)
        button.forceActiveFocus()
        QTest.keyClick(self.window, Qt.Key_Space)
        self.assertEqual(self.window.property("clicks"), 2)
        button.setEnabled(False)
        QTest.mouseClick(self.window, Qt.LeftButton, pos=QPoint(50, 40))
        self.assertEqual(self.window.property("clicks"), 2)

    def test_text_input_and_checkbox(self):
        field = self.window.findChild(QQuickItem, "field")
        field.forceActiveFocus()
        for key in (Qt.Key_N, Qt.Key_E, Qt.Key_K, Qt.Key_O):
            QTest.keyClick(self.window, key)
        self.assertEqual(field.property("text"), "neko")
        checkbox = self.window.findChild(QQuickItem, "checkbox")
        QTest.mouseClick(self.window, Qt.LeftButton, pos=QPoint(30, 180))
        self.assertTrue(checkbox.property("checked"))

    def test_theme_binding(self):
        before = self.window.property("accent")
        self.assertTrue(QMetaObject.invokeMethod(
            self.window, "setDark", Q_ARG(bool, True)
        ))
        self.assertNotEqual(self.window.property("accent"), before)

    def test_window_controls_requests_and_restore(self):
        QTest.mouseClick(self.window, Qt.LeftButton, pos=QPoint(36, 246))
        self.assertEqual(self.window.property("closeRequests"), 1)
        self.assertTrue(self.window.isVisible())
        QTest.mouseClick(self.window, Qt.LeftButton, pos=QPoint(70, 246))
        self.assertEqual(self.window.property("minimizeRequests"), 1)
        QTest.mouseClick(self.window, Qt.LeftButton, pos=QPoint(104, 246))
        self.assertEqual(self.window.property("maximizeRequests"), 1)
        self.assertTrue(self.window.property("testMaximized"))
        QTest.mouseClick(self.window, Qt.LeftButton, pos=QPoint(104, 246))
        self.assertEqual(self.window.property("restoreRequests"), 1)
        self.assertFalse(self.window.property("testMaximized"))

    def test_window_button_keyboard_and_disabled_group(self):
        button = self.window.findChild(QQuickItem, "standaloneClose")
        self.assertEqual(button.property("text"), "Close")
        button.forceActiveFocus()
        QTest.keyClick(self.window, Qt.Key_Space)
        self.assertEqual(self.window.property("closeRequests"), 1)
        controls = self.window.findChild(QQuickItem, "windowControls")
        controls.setEnabled(False)
        for x in (36, 70, 104):
            QTest.mouseClick(self.window, Qt.LeftButton, pos=QPoint(x, 246))
        self.assertEqual(self.window.property("closeRequests"), 1)
        self.assertEqual(self.window.property("minimizeRequests"), 0)
        self.assertEqual(self.window.property("maximizeRequests"), 0)

    def test_gallery_loads(self):
        self.engine.load(QUrl.fromLocalFile(str(ROOT / "gallery" / "Main.qml")))
        self.assertEqual(len(self.engine.rootObjects()), 2)
        gallery = self.engine.rootObjects()[1]
        self.assertTrue(QTest.qWaitForWindowExposed(gallery))
        previews = ROOT / "build" / "previews"
        previews.mkdir(parents=True, exist_ok=True)
        for dark, name in ((False, "light"), (True, "dark")):
            QMetaObject.invokeMethod(self.window, "setDark", Q_ARG(bool, dark))
            QTest.qWait(100)
            image = gallery.grabWindow()
            self.assertFalse(image.isNull())
            self.assertTrue(image.save(str(previews / f"gallery-{name}.png")))
        gallery.close()


if __name__ == "__main__":
    unittest.main()
