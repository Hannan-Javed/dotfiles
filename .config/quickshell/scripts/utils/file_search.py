from pathlib import Path

IMAGE_EXTENSIONS = ["png", "jpg", "jpeg", "webp"]


def find_metadata_file(directory: Path, preferred_name: str = None, flat: bool = False):
    # priority is metadata.json file
    if not flat and (directory / "metadata.json").exists():
        return directory / "metadata.json"

    # if not found, find same file name file
    if preferred_name and (directory / f"{preferred_name}.json").exists():
        return directory / f"{preferred_name}.json"
    
    if flat:
        return None
    # efficiently return the first match of any json or None if empty
    return next(directory.glob("*.json"), None)

def find_preview_file(directory: Path, preferred_name: str = None, flat: bool = False):
    if not flat:
        # preview.ext   
        for ext in IMAGE_EXTENSIONS:
            candidate = directory / f"preview.{ext}"
            if candidate.exists():
                return str(candidate)

    # preferred.ext
    if preferred_name:
        for ext in IMAGE_EXTENSIONS:
            candidate = directory / f"{preferred_name}.{ext}"
            if candidate.exists():
                return str(candidate)
    if flat:
        return None
    # any image
    images = []

    for ext in IMAGE_EXTENSIONS:
        images.extend(directory.glob(f"*.{ext}"))

    return str(images[0]) if images else None
