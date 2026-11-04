#!/usr/bin/env python3

import json
from pathlib import Path
import sys
SCRIPT_DIR = Path(__file__).resolve().parent
sys.path.insert(0, str(SCRIPT_DIR.parent))

from utils.file_search import find_metadata_file, find_preview_file
from utils.load_json import load_json

ROOT = Path.home() / ".config/quickshell/presets"

presets = {}
index = {}

for group_dir in ROOT.iterdir():
    if not group_dir.is_dir():
        continue

    group_name = group_dir.name
    presets[group_name] = []

    for preset_dir in group_dir.iterdir():
        if not preset_dir.is_dir():
            continue

        preset_json = find_metadata_file(preset_dir)

        if not preset_json.exists():
            continue

        try:
            preset = load_json(preset_json)
            preset["id"] = f"{group_name}/{preset_dir.name}"
            preset["group"] = group_name
            preset["path"] = str(preset_dir)

            preset.setdefault("name", preset_dir.name)

            preview = find_preview_file(preset_dir)
            if preview:
                preset["preview"] = preview

            presets[group_name].append(preset)
            index[preset["id"]] = preset

        except Exception as e:
            print(f"Failed loading {preset_json}: {e}")

print(json.dumps({
    "presets": presets,
    "index": index
}))