#!/usr/bin/env python3

import json
import sys
from pathlib import Path
if len(sys.argv) != 2:
    print(json.dumps([]))
    sys.exit(1)

root = Path(sys.argv[1]).expanduser()
styles = []

if root.exists():
    for file in root.glob("*.qml"):
        style = {
            "name": file.stem,
            "path": str(file)
        }
        for ext in ["png", "jpg", "jpeg"]:
            preview_path = file.with_suffix(f".{ext}")
            if preview_path.exists():
                style["preview"] = str(preview_path)
                break

        styles.append(style)

print(json.dumps(styles))