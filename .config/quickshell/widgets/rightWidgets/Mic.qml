import QtQuick
import Quickshell
import Quickshell.Io

Rectangle {
    id: root

    property bool muted: false

    width: 28
    height: 28
    radius: 8

    color: "#313244"

    Text {
        anchors.centerIn: parent
        text: muted ? "󰍭" : "󰍬"
        color: muted ? "#f38ba8" : "#a6e3a1"
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 16
    }

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: micCheck.running = true
    }

    Process {
        id: micCheck

        command: ["sh", "-c", "wpctl get-volume @DEFAULT_AUDIO_SOURCE@"]

        stdout: StdioCollector {
            onStreamFinished: {
                root.muted = text.includes("[MUTED]")
            }
        }
    }
}