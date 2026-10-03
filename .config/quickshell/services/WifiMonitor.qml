import "../theme"
import QtQuick
import Quickshell.Io
pragma Singleton

Item {
    property string ssid
    property int signal
    // property string rxRate: "--"
    // property string txRate: "--"

    Process {
        id: wifiProc

        command: ["/home/hannan/.config/quickshell/scripts/wifi-info.sh"]

        stdout: SplitParser {
            onRead: (data) => {
                let parts = data.trim().split("|");
                ssid = parts[0] || "Disconnected";
                signal = parseInt(parts[1]) || 0;
                // rxRate = parts[2] || "--";
                // txRate = parts[3] || "--";
            }
        }

    }

    Timer {
        interval: Metrics.longUpdateInterval
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: wifiProc.running = true
    }

}
