#!/usr/bin/env python3

import json
import sys
from pathlib import Path

IMAGE_EXTENSIONS = {".png", ".jpg", ".jpeg", ".webp", ".bmp"}


def is_image(path: Path) -> bool:
    return path.suffix.lower() in IMAGE_EXTENSIONS


def is_preview(path: Path) -> bool:
    return "preview" in path.stem.lower()


def scan_in_themes(themes_dir: Path):
    wallpapers = []

    for file in themes_dir.rglob("*"):
        if not file.is_file():
            continue

        if not is_image(file):
            continue

        if is_preview(file):
            continue

        try:
            relative = file.relative_to(themes_dir)
            parts = relative.parts

            # expect group/theme/file
            if len(parts) < 3:
                continue

            group = parts[0]
            theme = parts[1]

            wallpapers.append({
                "name": f"{group}/{theme}",
                "group": group,
                "theme": theme,
                "source": "theme",
                "path": str(file)
            })

        except Exception:
            pass

    return wallpapers


def scan_directory(directory: Path):
    wallpapers = []

    for file in directory.rglob("*"):
        if not file.is_file():
            continue

        if not is_image(file):
            continue

        if is_preview(file):
            continue

        wallpapers.append({
            "name": file.stem,
            "source": "user",
            "path": str(file)
        })

    return wallpapers


def main():
    if len(sys.argv) < 2:
        print("[]")
        return

    wallpapers = []

    for arg in sys.argv[1:]:
        directory = Path(arg).expanduser()

        if not directory.exists():
            continue

        if directory.name == "themes":
            wallpapers.extend(scan_in_themes(directory))
        else:
            wallpapers.extend(scan_directory(directory))

    print(json.dumps(wallpapers))


if __name__ == "__main__":
    main()