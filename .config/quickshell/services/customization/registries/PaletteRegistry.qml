import ".."
import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

// Scanner of palettes in palettes directory
Item {
    id: root

    property var palettes: []
    property var paletteIndex: ({
    })

    function reload() {
        scanner.running = true;
    }

    function getPalette(id) {
        return paletteIndex[id] || null;
    }

    function rebuildIndex() {
        const index = {
        };
        for (let i = 0; i < palettes.length; i++) {
            const palette = palettes[i];
            if (palette.id)
                index[palette.id] = palette;

        }
        paletteIndex = index;
    }

    onPalettesChanged: rebuildIndex()
    Component.onCompleted: {
        RegistryManager.register(root);
        reload();
    }

    Process {
        id: scanner

        command: ["python3", Quickshell.env("HOME") + "/.config/quickshell/scripts/scanners/scan-styles.py", Quickshell.env("HOME") + "/.config/quickshell/assets/palettes", ".json"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.palettes = JSON.parse(text.trim());
                } catch (e) {
                    console.error("Failed parsing Palette registry:", e);
                }
            }
        }

    }

}
