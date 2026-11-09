# SPDX-License-Identifier: GPL-3.0-only
"""Exercise the installed-style module import and observable input behavior."""

import unittest
from itertools import product
from pathlib import Path

from PySide6.QtCore import Q_ARG, QMetaObject, QPoint, QPointF, Qt, QUrl
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

    def test_switch_mouse_keyboard_and_disabled(self):
        switch = self.window.findChild(QQuickItem, "switch")
        self.assertFalse(switch.property("checked"))
        QTest.mouseClick(self.window, Qt.LeftButton, pos=QPoint(204, 182))
        self.assertTrue(switch.property("checked"))
        switch.forceActiveFocus()
        QTest.keyClick(self.window, Qt.Key_Space)
        self.assertFalse(switch.property("checked"))
        self.assertEqual(self.window.property("switchToggles"), 2)
        switch.setEnabled(False)
        QTest.mouseClick(self.window, Qt.LeftButton, pos=QPoint(204, 182))
        QTest.keyClick(self.window, Qt.Key_Space)
        self.assertFalse(switch.property("checked"))
        self.assertEqual(self.window.property("switchToggles"), 2)

    def test_switch_drag_in_both_layout_directions(self):
        switch = self.window.findChild(QQuickItem, "switch")
        for mirrored in (False, True):
            with self.subTest(mirrored=mirrored):
                self.window.setProperty("switchMirrored", mirrored)
                APP.processEvents()
                indicator = switch.property("indicator")
                left = round(switch.x() + indicator.x())
                off_x, on_x = (left + 10, left + 38)
                if mirrored:
                    off_x, on_x = on_x, off_x
                for start, end, expected in ((off_x, on_x, True), (on_x, off_x, False)):
                    QTest.mousePress(self.window, Qt.LeftButton, pos=QPoint(start, 182))
                    for step in range(1, 5):
                        x = round(start + (end - start) * step / 4)
                        QTest.mouseMove(self.window, QPoint(x, 182), delay=20)
                    QTest.mouseRelease(self.window, Qt.LeftButton, pos=QPoint(end, 182))
                    self.assertEqual(switch.property("checked"), expected)
        self.assertEqual(self.window.property("switchToggles"), 4)

    def test_radio_exclusive_selection_keyboard_and_disabled(self):
        first = self.window.findChild(QQuickItem, "radioFirst")
        second = self.window.findChild(QQuickItem, "radioSecond")
        disabled = self.window.findChild(QQuickItem, "radioDisabled")

        def click(item):
            point = item.mapToScene(QPointF(item.width() / 2, item.height() / 2)).toPoint()
            QTest.mouseClick(self.window, Qt.LeftButton, pos=point)

        self.assertTrue(first.property("checked"))
        self.assertFalse(second.property("checked"))
        click(second)
        self.assertFalse(first.property("checked"))
        self.assertTrue(second.property("checked"))
        click(second)
        self.assertTrue(second.property("checked"))
        click(disabled)
        self.assertFalse(disabled.property("checked"))
        self.assertTrue(second.property("checked"))
        first.forceActiveFocus()
        QTest.keyClick(self.window, Qt.Key_Space)
        self.assertTrue(first.property("checked"))
        self.assertFalse(second.property("checked"))

    def test_radio_ripple_fills_from_top_left_and_clears(self):
        first = self.window.findChild(QQuickItem, "radioFirst")
        second = self.window.findChild(QQuickItem, "radioSecond")

        def click(item):
            point = item.mapToScene(QPointF(item.width() / 2, item.height() / 2)).toPoint()
            QTest.mouseClick(self.window, Qt.LeftButton, pos=point)

        def background_samples():
            image = self.window.grabWindow()
            ratio = image.width() / self.window.width()
            points = (QPointF(5, 5), QPointF(second.width() - 5, second.height() - 5))
            colors = []
            for point in points:
                scene = second.mapToScene(point)
                colors.append(image.pixelColor(round(scene.x() * ratio), round(scene.y() * ratio)))
            return colors

        QTest.qWait(30)
        before = background_samples()
        click(second)
        QTest.qWait(90)
        during = background_samples()
        self.assertNotEqual(during[0], before[0])
        self.assertEqual(during[1], before[1])
        QTest.qWait(350)
        after = background_samples()
        self.assertEqual(after[0], after[1])
        self.assertNotEqual(after[1], before[1])
        click(first)
        QTest.qWait(420)
        self.assertEqual(background_samples(), before)

    def test_slider_drag_keyboard_and_disabled(self):
        slider = self.window.findChild(QQuickItem, "slider")
        QTest.mousePress(self.window, Qt.LeftButton, pos=QPoint(140, 462))
        QTest.mouseMove(self.window, QPoint(230, 462), delay=30)
        QTest.mouseRelease(self.window, Qt.LeftButton, pos=QPoint(230, 462))
        self.assertGreater(slider.property("value"), 80)
        slider.setProperty("value", 50)
        slider.forceActiveFocus()
        QTest.keyClick(self.window, Qt.Key_Right)
        self.assertEqual(slider.property("value"), 60)
        QTest.keyClick(self.window, Qt.Key_Left)
        self.assertEqual(slider.property("value"), 50)
        slider.setEnabled(False)
        QTest.mouseClick(self.window, Qt.LeftButton, pos=QPoint(240, 462))
        QTest.keyClick(self.window, Qt.Key_Right)
        self.assertEqual(slider.property("value"), 50)

    def test_slider_endpoints_and_mirrored_direction(self):
        slider = self.window.findChild(QQuickItem, "slider")
        for mirrored in (False, True):
            self.window.setProperty("sliderMirrored", mirrored)
            APP.processEvents()
            for x, expected in ((21, 100 if mirrored else 0), (259, 0 if mirrored else 100)):
                QTest.mouseClick(self.window, Qt.LeftButton, pos=QPoint(x, 462))
                self.assertEqual(slider.property("value"), expected)

    def test_slider_fill_meets_handle_without_gray_gap(self):
        slider = self.window.findChild(QQuickItem, "slider")
        for vertical, mirrored in ((False, False), (False, True), (True, False)):
            self.assertTrue(slider.setProperty("orientation", (Qt.Vertical if vertical else Qt.Horizontal).value))
            slider.setWidth(44 if vertical else 240)
            slider.setHeight(240 if vertical else 44)
            slider.setX(340 if vertical else 20)
            slider.setY(320 if vertical else 440)
            self.window.setProperty("sliderMirrored", mirrored)
            for value in (10, 25, 50, 90):
                with self.subTest(vertical=vertical, mirrored=mirrored, value=value):
                    slider.setProperty("value", value)
                    QTest.qWait(30)
                    knob = slider.property("handle")
                    track = slider.property("background")
                    # 采样滑块外侧靠近轨道边缘的位置，确认圆角没有提前结束
                    point = QPointF(track.x() + 2, knob.y() + knob.height() + 1) if vertical else QPointF(
                        knob.x() + knob.width() + 1 if mirrored else knob.x() - 1, track.y() + 2)
                    scene = slider.mapToScene(point)
                    image = self.window.grabWindow()
                    ratio = image.width() / self.window.width()
                    color = image.pixelColor(round(scene.x() * ratio), round(scene.y() * ratio))
                    self.assertLess(color.red(), 30)
                    self.assertGreater(color.blue(), 150)

    def test_spinbox_click_hold_release_and_bounds(self):
        spin = self.window.findChild(QQuickItem, "spinbox")
        plus = QPoint(round(spin.x() + spin.width() - 22), 392)
        minus = QPoint(42, 392)
        QTest.mouseClick(self.window, Qt.LeftButton, pos=plus)
        self.assertEqual(spin.property("value"), 52)
        QTest.mouseClick(self.window, Qt.LeftButton, pos=minus)
        self.assertEqual(spin.property("value"), 50)
        for point, increasing in ((plus, True), (minus, False)):
            spin.setProperty("value", 50)
            QTest.mousePress(self.window, Qt.LeftButton, pos=point)
            QTest.qWait(900)
            held = spin.property("value")
            self.assertGreater(held, 52) if increasing else self.assertLess(held, 48)
            QTest.mouseRelease(self.window, Qt.LeftButton, pos=point)
            released = spin.property("value")
            QTest.qWait(250)
            self.assertEqual(spin.property("value"), released)
        for value, point in ((100, plus), (0, minus)):
            spin.setProperty("value", value)
            QTest.mouseClick(self.window, Qt.LeftButton, pos=point)
            self.assertEqual(spin.property("value"), value)

    def test_spinbox_text_keyboard_mirrored_and_disabled(self):
        spin = self.window.findChild(QQuickItem, "spinbox")
        field = spin.property("contentItem")
        field.forceActiveFocus()
        self.assertTrue(QMetaObject.invokeMethod(field, "selectAll"))
        QTest.keyClick(self.window, Qt.Key_4)
        QTest.keyClick(self.window, Qt.Key_2)
        QTest.keyClick(self.window, Qt.Key_Return)
        self.assertEqual(spin.property("value"), 42)
        QTest.keyClick(self.window, Qt.Key_Up)
        self.assertEqual(spin.property("value"), 44)
        QTest.keyClick(self.window, Qt.Key_Down)
        self.assertEqual(spin.property("value"), 42)
        self.window.setProperty("spinMirrored", True)
        APP.processEvents()
        QTest.mouseClick(self.window, Qt.LeftButton, pos=QPoint(42, 392))
        self.assertEqual(spin.property("value"), 44)
        spin.setEnabled(False)
        QTest.mousePress(self.window, Qt.LeftButton, pos=QPoint(42, 392))
        QTest.qWait(700)
        QTest.mouseRelease(self.window, Qt.LeftButton, pos=QPoint(42, 392))
        self.assertEqual(spin.property("value"), 44)

    def test_textarea_return_cursor_follows_curve_with_easing(self):
        area = self.window.findChild(QQuickItem, "textarea")
        area.setProperty("text", "Hello")
        area.setProperty("cursorPosition", 5)
        area.forceActiveFocus()
        QTest.qWait(20)
        start = area.property("cursorRectangle").topLeft()
        QTest.keyClick(self.window, Qt.Key_Return)
        self.assertEqual(area.property("text"), "Hello\n")
        APP.processEvents()
        end = area.property("cursorRectangle").topLeft()
        self.assertGreater(end.y(), start.y())

        # 检查实际绘制光标的坐标，不向组件公开动画内部状态
        caret = next(item for item in area.findChildren(QQuickItem)
                     if abs(item.width() - 1.5) < 0.01)
        points = []
        for _ in range(3):
            QTest.qWait(60)
            points.append(caret.mapToItem(area, QPointF(0, 0)))
        progress = [(start.x() - point.x()) / (start.x() - end.x()) for point in points]
        self.assertGreater(progress[0], 0)
        self.assertLess(progress[0], 0.2)
        self.assertGreater(progress[1], 0.2)
        self.assertLess(progress[1], 0.8)
        self.assertGreater(progress[2], 0.8)
        linear_y = start.y() + progress[1] * (end.y() - start.y())
        self.assertGreater(points[1].y(), linear_y + 2)
        QTest.qWait(100)
        final = caret.mapToItem(area, QPointF(0, 0))
        self.assertAlmostEqual(final.x(), end.x(), delta=0.1)
        self.assertAlmostEqual(final.y(), end.y(), delta=0.1)

    def test_textarea_typing_interrupts_animation_and_preserves_editing(self):
        area = self.window.findChild(QQuickItem, "textarea")
        area.setProperty("text", "Hello")
        area.setProperty("cursorPosition", 5)
        area.forceActiveFocus()
        QTest.keyClick(self.window, Qt.Key_Return)
        QTest.qWait(60)
        QTest.keyClick(self.window, Qt.Key_X)
        self.assertEqual(area.property("text"), "Hello\nx")
        caret = next(item for item in area.findChildren(QQuickItem)
                     if abs(item.width() - 1.5) < 0.01)
        self.assertEqual(caret.mapToItem(area, QPointF(0, 0)),
                         area.property("cursorRectangle").topLeft())
        QTest.keyClick(self.window, Qt.Key_Return)
        QTest.keyClick(self.window, Qt.Key_Enter)
        QTest.qWait(300)
        self.assertEqual(area.property("text"), "Hello\nx\n\n")
        self.assertEqual(caret.mapToItem(area, QPointF(0, 0)),
                         area.property("cursorRectangle").topLeft())
        self.assertTrue(QMetaObject.invokeMethod(area, "undo"))
        self.assertEqual(area.property("text"), "Hello\nx\n")
        area.setProperty("readOnly", True)
        QTest.keyClick(self.window, Qt.Key_Return)
        self.assertEqual(area.property("text"), "Hello\nx\n")
        self.assertEqual(caret.opacity(), 0)

    def test_textarea_return_animation_survives_growing_layout(self):
        self.engine.load(QUrl.fromLocalFile(str(ROOT / "gallery" / "Main.qml")))
        gallery = self.engine.rootObjects()[1]
        try:
            self.assertTrue(QTest.qWaitForWindowExposed(gallery))
            area = next(item for item in gallery.findChildren(QQuickItem)
                        if item.property("placeholderText") == "备注")
            area.forceActiveFocus()
            initial_height = area.height()
            for line in range(16):
                with self.subTest(line=line + 1):
                    for key in (Qt.Key_H, Qt.Key_E, Qt.Key_L, Qt.Key_L, Qt.Key_O):
                        QTest.keyClick(gallery, key)
                    QTest.qWait(20)
                    QTest.keyClick(gallery, Qt.Key_Return)
                    QTest.qWait(80)
                    caret = next(item for item in area.findChildren(QQuickItem)
                                 if abs(item.width() - 1.5) < 0.01)
                    destination = area.property("cursorRectangle").topLeft()
                    self.assertGreater(caret.mapToItem(area, QPointF()).x(), destination.x() + 1)
                    for _ in range(40):
                        if caret.mapToItem(area, QPointF()) == area.property("cursorRectangle").topLeft():
                            break
                        QTest.qWait(10)
                    self.assertEqual(caret.mapToItem(area, QPointF()),
                                     area.property("cursorRectangle").topLeft())
            self.assertGreater(area.height(), initial_height)
            self.assertEqual(area.property("text"), "hello\n" * 16)
        finally:
            gallery.close()

    def test_textarea_layout_change_keeps_animation_but_navigation_stops_it(self):
        area = self.window.findChild(QQuickItem, "textarea")
        area.setProperty("text", "Hello")
        area.setProperty("cursorPosition", 5)
        area.forceActiveFocus()
        QTest.keyClick(self.window, Qt.Key_Return)
        QTest.qWait(60)
        area.setHeight(area.height() + 20)
        QTest.qWait(30)
        caret = next(item for item in area.findChildren(QQuickItem)
                     if abs(item.width() - 1.5) < 0.01)
        self.assertGreater(caret.mapToItem(area, QPointF()).x(),
                           area.property("cursorRectangle").x() + 1)
        area.setProperty("cursorPosition", 0)
        self.assertEqual(caret.mapToItem(area, QPointF()),
                         area.property("cursorRectangle").topLeft())

    def test_theme_binding(self):
        before = self.window.property("accent")
        self.assertTrue(QMetaObject.invokeMethod(
            self.window, "setDark", Q_ARG(bool, True)
        ))
        self.assertNotEqual(self.window.property("accent"), before)

    def test_combo_selection_keyboard_and_disabled(self):
        combo = self.window.findChild(QQuickItem, "combo")
        popup = self.window.property("comboPopup")
        QTest.mouseClick(self.window, Qt.LeftButton, pos=QPoint(100, 322))
        QTest.qWait(600)
        self.assertTrue(popup.property("opened"))
        QTest.mouseClick(self.window, Qt.LeftButton, pos=QPoint(100, 422))
        self.assertEqual(combo.property("currentIndex"), 1)
        self.assertEqual(combo.property("currentText"), "Second")
        self.assertEqual(self.window.property("comboActivations"), 1)
        QTest.qWait(150)
        self.assertFalse(popup.property("visible"))
        combo.forceActiveFocus()
        QTest.keyClick(self.window, Qt.Key_Down)
        self.assertEqual(combo.property("currentIndex"), 2)
        combo.setEnabled(False)
        QTest.mouseClick(self.window, Qt.LeftButton, pos=QPoint(100, 322))
        self.assertFalse(popup.property("visible"))
        self.assertEqual(combo.property("currentIndex"), 2)

    def test_combo_frame_then_staggered_options_and_reopen(self):
        combo = self.window.findChild(QQuickItem, "combo")
        popup = self.window.property("comboPopup")
        for attempt in range(2):
            QTest.mouseClick(self.window, Qt.LeftButton, pos=QPoint(100, 322))
            QTest.qWait(40)
            self.assertTrue(popup.property("visible"))
            view = popup.property("contentItem")
            # 这里只检查动画中的行透明度，避免将内部动画状态暴露为组件接口
            rows = sorted(
                (item for item in view.property("contentItem").childItems()
                 if item.property("index") is not None),
                key=lambda item: item.property("index"),
            )
            self.assertEqual(len(rows), 4)
            self.assertGreater(popup.property("opacity"), 0)
            self.assertTrue(all(row.opacity() == 0 for row in rows))
            for _ in range(30):
                if rows[0].opacity() > 0:
                    break
                QTest.qWait(10)
            self.assertGreater(rows[0].opacity(), rows[1].opacity())
            self.assertEqual(rows[-1].opacity(), 0)
            if attempt == 1:
                QTest.qWait(600)
                self.assertTrue(all(row.opacity() == 1 for row in rows))
            QTest.keyClick(self.window, Qt.Key_Escape)
            QTest.qWait(150)
            self.assertFalse(popup.property("visible"))

    def test_window_button_group_requests_and_restore(self):
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

    def test_button_foreground_tracks_theme(self):
        button = self.window.findChild(QQuickItem, "button")
        label = button.property("contentItem")
        for dark, expected in ((False, "#ffffff"), (True, "#303030")):
            QMetaObject.invokeMethod(self.window, "setDark", Q_ARG(bool, dark))
            self.assertEqual(label.property("color").name(), expected)
            self.assertEqual(self.window.property("legacyAccentText").name(), expected)

    def test_window_button_keyboard_and_disabled_group(self):
        button = self.window.findChild(QQuickItem, "standaloneClose")
        self.assertEqual(button.property("text"), "Close")
        button.forceActiveFocus()
        QTest.keyClick(self.window, Qt.Key_Space)
        self.assertEqual(self.window.property("closeRequests"), 1)
        controls = self.window.findChild(QQuickItem, "windowButtonGroup")
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

    def test_window_symbols_are_centered_in_rendered_discs(self):
        button = self.window.findChild(QQuickItem, "standaloneClose")
        QTest.mouseMove(self.window, QPoint(350, 50))
        states = ((0, False), (1, False), (2, False), (2, True))
        for diameter, (operation, maximized), (left, top) in product(
            (18, 24), states, ((180, 230), (181, 231))
        ):
            with self.subTest(diameter=diameter, operation=operation,
                              maximized=maximized, position=(left, top)):
                button.setProperty("diameter", diameter)
                button.setProperty("operation", operation)
                button.setProperty("maximized", maximized)
                button.setX(left)
                button.setY(top)
                QTest.qWait(100)
                image = self.window.grabWindow()
                ratio = image.width() / self.window.width()
                disc, ink = [], []
                for y in range(round(top * ratio), round((top + button.height()) * ratio)):
                    for x in range(round(left * ratio), round((left + button.width()) * ratio)):
                        color = image.pixelColor(x, y)
                        rgb = (color.red(), color.green(), color.blue())
                        if max(rgb) - min(rgb) > 80:
                            disc.append((x + 0.5, y + 0.5))
                        if max(rgb) < 80:
                            ink.append((x + 0.5, y + 0.5))
                self.assertTrue(disc, "Colored disc was not rendered")
                self.assertTrue(ink, "Black symbol was not rendered")
                for axis in (0, 1):
                    disc_center = (min(p[axis] for p in disc) + max(p[axis] for p in disc)) / 2
                    ink_center = (min(p[axis] for p in ink) + max(p[axis] for p in ink)) / 2
                    self.assertAlmostEqual(ink_center, disc_center, delta=0.25,
                        msg=f"Symbol center differs on axis {axis} at scale {ratio}")


if __name__ == "__main__":
    unittest.main()
