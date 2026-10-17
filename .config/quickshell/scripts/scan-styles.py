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
        styles.append({
            "name": file.stem,
            "path": str(file)
        })

print(json.dumps(styles))