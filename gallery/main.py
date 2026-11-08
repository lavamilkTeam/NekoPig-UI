# SPDX-License-Identifier: GPL-3.0-only
"""Launch the gallery using only the library's public QML module."""

import sys
from pathlib import Path

from PySide6.QtCore import QUrl
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine


def main() -> int:
    app = QGuiApplication(sys.argv)
    gallery = Path(__file__).resolve().parent
    engine = QQmlApplicationEngine()
    engine.addImportPath(str(gallery.parent / "qml"))
    engine.load(QUrl.fromLocalFile(str(gallery / "Main.qml")))
    if not engine.rootObjects():
        return 1
    return app.exec()


if __name__ == "__main__":
    raise SystemExit(main())
