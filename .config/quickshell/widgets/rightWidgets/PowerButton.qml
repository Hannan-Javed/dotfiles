import QtQuick
import Quickshell.Io

Rectangle {
    id: root

    required property string icon
    required property string command
    property color accent: "#f38ba8"

    width: 28
    height: 28
    radius: 8

    color: mouse.containsMouse ? accent : "#313244"
    border.color: accent
    border.width: 1

    Text {
        anchors.centerIn: parent
        text: root.icon
        color: "white"
        font.pixelSize: 17
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            proc.running = true
        }
    }

    Process {
        id: proc
        command: ["sh", "-c", root.command]
    }
}