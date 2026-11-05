#!/usr/bin/env python3

from pathlib import Path
import sys

SCRIPT_DIR = Path(__file__).resolve().parent
sys.path.insert(0, str(SCRIPT_DIR.parent))

from utils.load_json import load_json

path = Path.home() / ".config/quickshell/user-preferences.json"

print(load_json(path))