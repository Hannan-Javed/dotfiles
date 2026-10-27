import "../../../services"
import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

// scanner of themes in quickshell/themes/ directory
Item {
    id: root

    property var themes: ({
    })
    property var themeIndex: ({
    })

    function reload() {
        scanner.running = true;
    }

    function groups() {
        return Object.keys(themes);
    }

    function getThemes(group) {
        return themes[group] || [];
    }

    function getTheme(id) {
        return themeIndex[id] || null;
    }

    Component.onCompleted: {
        RegistryManager.register(root);
        reload();
    }

    Process {
        id: scanner

        command: ["python3", Quickshell.env("HOME") + "/.config/quickshell/scripts/scanners/scan-themes.py"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(text);
                    root.themes = data.themes;
                    root.themeIndex = data.index;
                } catch (e) {
                    console.error("Failed parsing theme registry:", e);
                }
            }
        }

    }

}
