import "../theme"
import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

Item {
    property int cpuUsage: 0
    property int memUsage: 0
    property real lastIdle: 0
    property real lastTotal: 0
    property bool cpuInitialized: false

    Process {
        id: cpuProc

        command: ["head", "-n", "1", "/proc/stat"]

        stdout: SplitParser {
            onRead: (data) => {
                if (!data)
                    return ;

                let parts = data.trim().split(/\s+/);
                let idle = parseFloat(parts[4]) + parseFloat(parts[5]);
                let total = 0;
                for (let i = 1; i < parts.length; i++) {
                    total += parseFloat(parts[i]);
                }
                if (cpuInitialized) {
                    lastIdle = idle;
                    lastTotal = total;
                    cpuInitialized = true;
                    return ;
                }
                let diffIdle = idle - lastIdle;
                let diffTotal = total - lastTotal;
                if (diffTotal > 0)
                    cpuUsage = Math.round(100 * (1 - diffIdle / diffTotal));

                lastIdle = idle;
                lastTotal = total;
            }
        }

    }

    Process {
        id: memProc

        command: ["sh", "-c", "free | grep Mem"]

        stdout: SplitParser {
            onRead: (data) => {
                if (!data)
                    return ;

                let parts = data.trim().split(/\s+/);
                let total = parseInt(parts[1]) || 1;
                let used = parseInt(parts[2]) || 0;
                memUsage = Math.round((used * 100) / total);
            }
        }

    }

    // update every 2 seconds
    Timer {
        interval: Metrics.systemStatsUpdateInterval
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            cpuProc.running = true;
            memProc.running = true;
        }
    }

}
