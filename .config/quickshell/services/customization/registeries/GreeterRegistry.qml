import "../../../services"
import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

// scanner of greeter styles in greeter/styles directory
Item {
    id: root

    property var greeters: []

    function reload() {
        scanner.running = true;
    }

    function getGreeter(id) {        
        for (let i = 0; i < greeters.length; i++) {
            if (greeters[i].id === id)
                return greeters[i];

        }
        return null;
    }

    Component.onCompleted: {
        RegistryManager.register(root);
        reload();
    }

    Process {
        id: scanner

        command: ["python3", Quickshell.env("HOME") + "/.config/quickshell/scripts/scanners/scan-styles.py", Quickshell.env("HOME") + "/.config/quickshell/greeter/styles"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.greeters = JSON.parse(text.trim());
                } catch (e) {
                    console.error("Failed parsing Greeters registry:", e);
                }
            }
        }

    }

}
