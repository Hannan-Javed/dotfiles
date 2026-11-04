import json
import sys

def load_json(path: Path):
    try:
        if path.exists():
            return json.loads(path.read_text())
    except Exception as e:
        print(f"WARNING: Failed loading {path}: {e}", file=sys.stderr)

    return {}