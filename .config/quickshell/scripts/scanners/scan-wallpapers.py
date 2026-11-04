#!/usr/bin/env python3

import json
import sys
from pathlib import Path

IMAGE_EXTENSIONS = {".png", ".jpg", ".jpeg", ".webp", ".bmp"}


def is_image(path: Path) -> bool:
    return path.suffix.lower() in IMAGE_EXTENSIONS


def scan_directory(directory: Path):
    wallpapers = []

    for file in directory.rglob("*"):
        if not file.is_file():
            continue

        if not is_image(file):
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
        wallpapers.extend(scan_directory(directory))

    print(json.dumps(wallpapers))


if __name__ == "__main__":
    main()