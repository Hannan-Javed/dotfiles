import "../../services"
import "../../theme"
import QtQuick
import Quickshell

Row {
    spacing: Metrics.widgetSpacing

    Row {
        spacing: Metrics.iconTextSpacing

        Text {
            text: "󰍛"
            font.family: Typography.fontFamily
            color: Colors.cpuIcon
            font.pixelSize: Typography.iconSize
        }

        Text {
            text: `${SystemMonitor.cpuUsage}%`
            color: Colors.textPrimary
            font.pixelSize: Typography.normal
            anchors.verticalCenter: parent.verticalCenter
        }

    }

    // Memory
    Row {
        spacing: Metrics.iconTextSpacing

        Text {
            text: "󰘚"
            font.family: Typography.fontFamily
            color: Colors.memoryIcon
            font.pixelSize: Typography.iconSize
        }

        Text {
            text: `${SystemMonitor.memUsage}%`
            color: Colors.textPrimary
            font.pixelSize: Typography.normal
            anchors.verticalCenter: parent.verticalCenter
        }

    }

}
