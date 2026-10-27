import "../../../services"
import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

// scanner of wallpapers in themes/ and /Pictures/Wallpapers/ directory
Item {
    id: root

    property var wallpapers: []

    function reload() {
        scanner.running = true;
    }

    function getWallpapers() {
        return wallpapers;
    }

    function getWallpaper(name) {
        for (let i = 0; i < wallpapers.length; i++) {
            if (wallpapers[i].name === name)
                return wallpapers[i];

        }
        return null;
    }

    Component.onCompleted: {
        RegistryManager.register(root)
        reload()
    }
    Process {
        id: scanner

        command: ["python3", Quickshell.env("HOME") + "/.config/quickshell/scripts/scanners/scan-wallpapers.py", Quickshell.env("HOME") + "/.config/quickshell/themes",Quickshell.env("HOME") + "/Pictures/Wallpapers",]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.wallpapers = JSON.parse(text.trim());
                } catch (e) {
                    console.error("Failed parsing Wallpaper registry:", e);
                }
            }
        }

    }

}
