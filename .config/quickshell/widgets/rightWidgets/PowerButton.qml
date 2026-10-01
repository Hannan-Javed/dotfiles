import QtQuick
import Quickshell.Io
import "../../theme"

Rectangle {
    id: root

    required property string icon
    required property string command
    property color accent: Colors.red

    width: Metrics.widgetWidth
    height: Metrics.widgetHeight
    radius: Metrics.widgetRadius

    color: mouse.containsMouse ? accent : Colors.rightWidgetIconBackground
    border.color: accent
    border.width: 1

    Text {
        anchors.centerIn: parent
        text: root.icon
        color: Colors.white
        font.pixelSize: Typography.boxedIconSize
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