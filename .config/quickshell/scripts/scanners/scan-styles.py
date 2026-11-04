#!/usr/bin/env python3

import json
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
sys.path.insert(0, str(SCRIPT_DIR.parent))

from utils.file_search import find_metadata_file, find_preview_file
from utils.load_json import load_json

def scan_flat_style(file: Path):
    """
    To load all types of "styles" sitting flatly in a directory
    name of metadata and preview file must be same
    expected format:
        SimpleBar.qml
        SimpleBar.json
        SimpleBar.png
    """
    
    metadata_file = find_metadata_file(
        file.parent,
        file.stem,
        flat = True
    )

    metadata = load_json(metadata_file) if metadata_file else {}
    # combine both metadata and other things
    style = dict(metadata)
    
    # id is file name
    style["id"] = file.stem

    # set name as filename only if not provided in metadata
    style.setdefault("name", file.stem)

    style["path"] =str(file)

    preview = find_preview_file(
        file.parent,
        file.stem,
        flat = True
    )

    if preview:
        # set preview file path only if found and not provided in metadata
        style.setdefault("preview", preview)

    return style


def scan_directory_style(style_dir: Path, extension):
    """
    To load all bar sitting in its own directory in styles/
    name of metadata and preview file can be anything, however if more than one present, the lexographically smaller one will be selected
    expected format:
    SimpleBar/
        Bar.qml
        metadata.json
        preview.png
    """

    files = []

    files = sorted(style_dir.glob(f"*{extension}"))
    if not files:
        return None

    # assume only one style per directory
    style_file = files[0]
    metadata_file = find_metadata_file(
        style_dir,
        style_file.stem,
    )

    metadata = load_json(metadata_file) if metadata_file else {}

    # combine both metadata and other things
    style = dict(metadata)

    # id is combination of directory name and file nameflat and directory styling
    # this is for two things - prevent same name when using both 
    # and to dynamically load path of style whenever activeStyle changes
    style["id"] = f"{style_dir.stem}/{style_file.stem}"

    # set name as filename only if not provided in metadata
    style.setdefault("name", style_dir.name)

    style["path"] = str(style_file)

    preview = find_preview_file(
        style_dir,
        style_file.stem,
    )

    if preview:
        # set preview file path only if found and not provided in metadata
        style.setdefault("preview", preview)

    return style

def scan_styles(root: Path, extension: str):

    extension = extension.lower()
    styles = []

    found_flat = False
    found_directory = False
    for entry in sorted(root.iterdir()):
        if entry.is_file() and entry.suffix.lower() == extension:
            found_flat = True
            styles.append(scan_flat_style(entry))

        elif entry.is_dir():
            style = scan_directory_style(entry, extension)

            if style:
                found_directory = True
                styles.append(style)

    if found_flat and found_directory:
        print(
            f"WARNING: Mixed flat and directory style layouts detected in {root}",
            file=sys.stderr
        )

    return styles


def main():
    # if no target scan directory given, return empty
    if len(sys.argv) < 2:
        print(json.dumps([]))
        sys.exit(1)

    root = Path(sys.argv[1]).expanduser()

    if not root.exists():
        print(json.dumps([]))
        return

    # by default if not arg given, scan qml files
    styles = scan_styles(root, sys.argv[2] if len(sys.argv) > 2 else ".qml")
    print(json.dumps(styles))


if __name__ == "__main__":
    main()