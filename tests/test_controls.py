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

    def test_gallery_loads(self):
        self.engine.load(QUrl.fromLocalFile(str(ROOT / "gallery" / "Main.qml")))
        self.assertEqual(len(self.engine.rootObjects()), 2)
        self.engine.rootObjects()[1].close()


if __name__ == "__main__":
    unittest.main()
