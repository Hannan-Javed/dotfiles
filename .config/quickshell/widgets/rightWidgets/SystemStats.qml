import Quickshell
import QtQuick

import "../../services"

Row {
    // spacing between system stats
    spacing: 10
    
    // CPU
    Row {
        anchors.verticalCenter: parent.verticalCenter
        Text {
            text: "󰍛"
            font.family: "JetBrainsMono Nerd Font"
            color: "#89b4fa"
            font.pixelSize: 18
        }
        Text {
            text: ` ${SystemMonitor.cpuUsage}%`
            color: "#cdd6f4"
            font.pixelSize: 12

            anchors.verticalCenter: parent.verticalCenter
        }
    }
    // Memory
    Row {
        spacing: 4
        anchors.verticalCenter: parent.verticalCenter
        Text {
            text: "󰘚"
            font.family: "JetBrainsMono Nerd Font"
            color: "#f9e2af"
            font.pixelSize: 18
        }

        Text {
            text: `${SystemMonitor.memUsage}%`
            color: "#cdd6f4"
            font.pixelSize: 12

            anchors.verticalCenter: parent.verticalCenter
        }
    }
}