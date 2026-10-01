import "../../theme"
import QtQuick
import Quickshell
import Quickshell.Io

Rectangle {
    id: root

    property bool muted: false

    width: Metrics.widgetWidth
    height: Metrics.widgetHeight
    radius: Metrics.widgetRadius
    color: Colors.rightWidgetIconBackground

    Text {
        anchors.centerIn: parent
        text: muted ? "󰍭" : "󰍬"
        color: muted ? Colors.red : Colors.green
        font.family: Typography.fontFamily
        font.pixelSize: Typography.boxedIconSize
    }

    Timer {
        interval: Metrics.updateInterval
        running: true
        repeat: true
        onTriggered: micCheck.running = true
    }

    Process {
        id: micCheck

        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SOURCE@"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.muted = text.includes("[MUTED]");
            }
        }

    }

}
