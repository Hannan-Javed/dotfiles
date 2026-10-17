import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

Item {
    id: root

    property var bars: []

    function reload() {
        scanner.running = true;
    }

    function getBars() {
        return bars;
    }

    function getBar(name) {
        for (let i = 0; i < bars.length; i++) {
            if (bars[i].name === name)
                return bars[i];

        }
        return null;
    }

    Component.onCompleted: reload()

    Process {
        id: scanner

        command: ["python3", Quickshell.env("HOME") + "/.config/quickshell/scripts/scan-styles.py", Quickshell.env("HOME") + "/.config/quickshell/bar/styles"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.bars = JSON.parse(text.trim());
                } catch (e) {
                    console.error("Failed parsing theme registry:", e);
                }
            }
        }

    }

}
