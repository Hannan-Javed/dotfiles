#!/usr/bin/env python3

import json
from pathlib import Path

ROOT = Path.home() / ".config/quickshell/themes"

themes = {}
index = {}

for group_dir in ROOT.iterdir():
    if not group_dir.is_dir():
        continue

    group_name = group_dir.name
    themes[group_name] = []

    for theme_dir in group_dir.iterdir():
        if not theme_dir.is_dir():
            continue

        theme_json = theme_dir / "theme.json"

        if not theme_json.exists():
            continue

        try:
            metadata = json.loads(theme_json.read_text())

            theme = {
                "id": f"{group_name}/{theme_dir.name}",
                "name": metadata.get("name", theme_dir.name),
                "colors": metadata["colors"],
                "suggestions": metadata["suggestions"] if metadata["suggestions"] else {},
                "group": group_name,
                "path": str(theme_dir),
            }

            for ext in ["png", "jpg", "jpeg"]:
                wallpaper_path = theme_dir / f"wallpaper.{ext}"
                if wallpaper_path.exists() and not "wallpaper" in theme["suggestions"]:
                    theme["suggestions"]["wallpaper"] = str(wallpaper_path)
                preview_path = theme_dir / f"preview.{ext}"
                if preview_path.exists() and not "preview" in theme["suggestions"]:
                    theme["preview"] = str(preview_path)
                

            themes[group_name].append(theme)
            index[theme["id"]] = theme

        except Exception as e:
            print(f"Failed loading {theme_json}: {e}")

print(json.dumps({
    "themes": themes,
    "index": index
}))