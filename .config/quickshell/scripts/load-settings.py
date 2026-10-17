#!/usr/bin/env python3

import json
from pathlib import Path

path = Path.home() / ".config/quickshell/state.json"

if path.exists():
    print(path.read_text())
else:
    print("{}")