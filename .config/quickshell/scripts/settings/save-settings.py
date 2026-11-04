#!/usr/bin/env python3

import json
import sys
from pathlib import Path

settings = {
    "activePreset": sys.argv[1],
    "palette": sys.argv[2],
    "bar": sys.argv[3],
    "notification": sys.argv[4],
    "wallpaper": sys.argv[5],
    "kitty": sys.argv[6],
    "greetd": sys.argv[7]
}

path = Path.home() / ".config/quickshell/user-preferences.json"

path.write_text(
    json.dumps(settings, indent=4)
)