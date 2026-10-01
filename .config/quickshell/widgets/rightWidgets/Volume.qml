import QtQuick
import Quickshell
import Quickshell.Io
import "../../theme"

Rectangle {
    id: root

    property int volumePercent: 0
    property bool muted: false

    width: volumeText.width + 32
    height: Metrics.widgetHeight
    radius: Metrics.widgetRadius

    color: Colors.rightWidgetIconBackground

    Row {
        anchors.centerIn: parent
        spacing: Metrics.iconTextSpacing

        Text {
            id: volumeIcon

            font.family: Typography.fontFamily
            font.pixelSize: Typography.boxedIconSize
            color: Colors.textPrimary

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
            color: Colors.textPrimary
            font.pixelSize: Typography.normal
        }
    }

    Timer {
        interval: Metrics.updateInterval
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