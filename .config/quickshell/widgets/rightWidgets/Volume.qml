import QtQuick
import Quickshell
import Quickshell.Io

Rectangle {
    id: root

    property int volumePercent: 0
    property bool muted: false

    width: volumeText.width + 32
    height: 28
    radius: 8

    color: "#313244"

    Row {
        anchors.centerIn: parent
        spacing: 4

        Text {
            id: volumeIcon

            font.family: "JetBrainsMono Nerd Font"
            font.pixelSize: 16
            color: "#cdd6f4"

            text: {
                if (root.muted || root.volumePercent === 0)
                    return "󰝟";

                if (root.volumePercent < 35)
                    return "󰕿";

                if (root.volumePercent < 70)
                    return "󰖀";

                return "󰕾";
            }
        }

        Text {
            id: volumeText
            text: root.volumePercent + "%"
            color: "#cdd6f4"
            font.pixelSize: 12
        }
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: volumeCheck.running = true
    }

    Process {
        id: volumeCheck

        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SINK@"]

        stdout: StdioCollector {
            onStreamFinished: {

                root.muted = text.includes("[MUTED]")

                let match = text.match(/Volume:\s*([0-9.]+)/)

                if (match) {
                    root.volumePercent =
                        Math.round(parseFloat(match[1]) * 100)
                }
            }
        }
    }
}