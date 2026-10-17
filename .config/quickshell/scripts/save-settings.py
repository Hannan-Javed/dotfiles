#!/usr/bin/env python3

import json
import sys
from pathlib import Path

settings = {
    "theme": sys.argv[1],
    "bar": sys.argv[2],
    "notification": sys.argv[3],
    "wallpaper": sys.argv[4],
    "kitty": sys.argv[5],
    "greetd": sys.argv[6]
}

path = Path.home() / ".config/quickshell/state.json"

path.write_text(
    json.dumps(settings, indent=4)
)