# SPDX-License-Identifier: GPL-3.0-only
"""确保纯 QML 组件库不依赖应用层或平台副作用"""

import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
MODULE = ROOT / "qml" / "NekoPigUI"
ALLOWED_IMPORTS = {
    "QtQuick", "QtQuick.Controls.Basic", "QtQuick.Shapes", "QtQuick.Effects", "NekoPigUI"
}


def main() -> int:
    errors = []
    # 递归检查职责子目录，避免组件移动后漏检
    for path in MODULE.rglob("*.qml"):
        source = path.read_text()
        relative = path.relative_to(MODULE).as_posix()
        for imported in re.findall(r"^import\s+(\S+)", source, re.MULTILINE):
            # 仅允许同一模块访问内部实现目录，使用方仍须走公开入口
            internal_import = (imported.startswith(('"', "'"))
                and (path.parent / imported.strip('\"\'')).resolve() == (MODULE / "impl").resolve())
            if imported not in ALLOWED_IMPORTS and not internal_import:
                errors.append(f"{relative}: forbidden library import {imported}")
            if relative.startswith("theme/") and imported != "QtQuick":
                errors.append(f"{relative}: theme must not depend on controls")
        if re.search(r"\b(XMLHttpRequest|WorkerScript)\b|Qt\.openUrlExternally", source):
            errors.append(f"{relative}: platform effects do not belong in controls")

    for directory in (ROOT / "gallery", ROOT / "tests"):
        for path in directory.rglob("*.qml"):
            if re.search(r'^import\s+["\']', path.read_text(), re.MULTILINE):
                errors.append(f"{path.name}: consumers must use named public modules")

    declarations = (MODULE / "qmldir").read_text().splitlines()
    for line in declarations:
        if line.endswith(".qml") and line.split()[-1].startswith("impl/") and not line.startswith("internal "):
            errors.append("impl components must be declared internal")
    exports = {line.split()[-1] for line in declarations if line.endswith(".qml")}
    sources = {path.relative_to(MODULE).as_posix() for path in MODULE.rglob("*.qml")}
    if exports != sources:
        errors.append("qmldir must match the public and internal component files")
    print("\n".join(errors) if errors else "QML module boundaries passed")
    return int(bool(errors))


if __name__ == "__main__":
    raise SystemExit(main())
