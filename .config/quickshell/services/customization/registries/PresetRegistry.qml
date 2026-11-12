import "../../../services"
import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

Item {
    id: root

    property var presets: ({
    })
    property var presetIndex: ({
    })

    function reload() {
        scanner.running = true;
    }

    function groups() {
        return Object.keys(presets);
    }

    function getPresets(group) {
        return presets[group] || [];
    }

    function getPreset(id) {
        return presetIndex[id] || null;
    }

    Component.onCompleted: {
        RegistryManager.register(root);
        reload();
    }

    Process {
        id: scanner

        command: ["python3", Quickshell.env("HOME") + "/.config/quickshell/scripts/scanners/scan-presets.py", Quickshell.env("HOME") + "/.config/quickshell/presets"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(text);
                    root.presets = data.presets;
                    root.presetIndex = data.index;
                } catch (e) {
                    console.error("Failed parsing preset registry:", e);
                }
            }
        }

    }

}
