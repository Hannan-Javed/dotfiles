#!/usr/bin/env bash
set -uo pipefail

CACHE_DIR="/var/cache/qs-greeter"
mkdir -p "$CACHE_DIR"

python3 - << 'EOF'
import configparser, glob, json, os, pwd, re

CACHE_DIR = "/var/cache/qs-greeter"

# 1. Generate users.json
users = []
for p in pwd.getpwall():
    if p.pw_uid < 1000 or p.pw_uid >= 60000:
        continue
    if p.pw_shell in ("/usr/bin/nologin", "/bin/false", "/sbin/nologin"):
        continue
    display_name = p.pw_gecos.split(",")[0].strip() or p.pw_name
    users.append({"username": p.pw_name, "displayName": display_name})

with open(f"{CACHE_DIR}/users.json", "w") as f:
    json.dump({"users": users}, f, indent=2)

# 2. Generate sessions.json
sessions = []
paths = glob.glob("/usr/share/wayland-sessions/*.desktop") + glob.glob("/usr/share/xsessions/*.desktop")
for path in sorted(paths):
    cp = configparser.ConfigParser(interpolation=None)
    try:
        cp.read(path)
        if "Desktop Entry" not in cp:
            continue
        entry = cp["Desktop Entry"]
        if entry.get("NoDisplay", "").lower() == "true" or entry.get("Hidden", "").lower() == "true":
            continue
        name = entry.get("Name", "").strip()
        exec_cmd = re.sub(r"\s+%[a-zA-Z]", "", entry.get("Exec", "")).strip()
        if name and exec_cmd:
            sessions.append({"name": name, "exec": exec_cmd})
    except Exception:
        continue

with open(f"{CACHE_DIR}/sessions.json", "w") as f:
    json.dump({"sessions": sessions}, f, indent=2)