# SPDX-License-Identifier: GPL-3.0-only
"""Keep the pure QML library independent of applications and platform effects."""

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MODULE = ROOT / "qml" / "NekoPigUI"
ALLOWED_IMPORTS = {"QtQuick", "QtQuick.Controls.Basic"}


def main() -> int:
    errors = []
    for path in MODULE.glob("*.qml"):
        source = path.read_text()
        for imported in re.findall(r"^import\s+(\S+)", source, re.MULTILINE):
            if imported not in ALLOWED_IMPORTS:
                errors.append(f"{path.name}: forbidden library import {imported}")
        if re.search(r"\b(XMLHttpRequest|WorkerScript)\b|Qt\.openUrlExternally", source):
            errors.append(f"{path.name}: platform effects do not belong in controls")

    for directory in (ROOT / "gallery", ROOT / "tests"):
        for path in directory.rglob("*.qml"):
            if re.search(r'^import\s+["\']', path.read_text(), re.MULTILINE):
                errors.append(f"{path.name}: consumers must use named public modules")

    declarations = (MODULE / "qmldir").read_text().splitlines()
    exports = {line.split()[-1] for line in declarations if line.endswith(".qml")}
    sources = {path.name for path in MODULE.glob("*.qml")}
    if exports != sources:
        errors.append("qmldir must match the public component files")
    print("\n".join(errors) if errors else "QML module boundaries passed")
    return int(bool(errors))


if __name__ == "__main__":
    raise SystemExit(main())
