import "../../services"
import "../../theme"
import QtQuick
import Quickshell

Rectangle {
    id: root

    width: contentRow.implicitWidth + 32
    height: Metrics.widgetHeight
    radius: Metrics.widgetRadius
    color: Colors.rightWidgetIconBackground

    Row {
        id: contentRow

        anchors.centerIn: parent
        spacing: Metrics.iconTextSpacing

        Item {
            width: wifiIcon.implicitWidth
            height: Metrics.widgetHeight

            Text {
                id: wifiIcon
                font.family: Typography.fontFamily
                font.pixelSize: Typography.iconSize
                color: Colors.textPrimary
                text: {
                    if (WifiMonitor.signal >= 75)
                        return "󰤨";

                    if (WifiMonitor.signal >= 50)
                        return "󰤥";

                    if (WifiMonitor.signal >= 25)
                        return "󰤢";

                    if (WifiMonitor.signal > 0)
                        return "󰤟";

                    return "󰤭";
                }
            }

        }

        Item {
            width: wifiText.implicitWidth
            height: Metrics.widgetHeight

            Text {
                id: wifiText
                text: WifiMonitor.ssid
                color: Colors.textPrimary
                font.family: Typography.fontFamily
                font.pixelSize: Typography.normal
                anchors.verticalCenter: parent.verticalCenter
            }

        }

        // Item {
        //     width: downArrow.implicitWidth
        //     height: Metrics.widgetHeight

        //     Text {
        //         id: downArrow
        //         text: "↓"
        //         color: "#4FC3F7"
        //         font.pixelSize: Typography.normal
        //         anchors.verticalCenter: parent.verticalCenter
        //     }

        // }

        // Item {
        //     width: rxRate.implicitWidth
        //     height: Metrics.widgetHeight

        //     Text {
        //         id: rxRate
        //         text: WifiMonitor.rxRate
        //         color: Colors.textPrimary
        //         font.pixelSize: Typography.normal
        //         anchors.verticalCenter: parent.verticalCenter
        //     }

        // }

        // Item {
        //     width: upArrow.implicitWidth
        //     height: Metrics.widgetHeight

        //     Text {
        //         id: upArrow
        //         text: "↑"
        //         color: "#81C784"
        //         font.pixelSize: Typography.normal
        //         anchors.verticalCenter: parent.verticalCenter
        //     }

        // }

        // Item {
        //     width: txRate.implicitWidth
        //     height: Metrics.widgetHeight

        //     Text {
        //         id: txRate
        //         text: WifiMonitor.txRate
        //         color: Colors.textPrimary
        //         font.pixelSize: Typography.normal
        //         anchors.verticalCenter: parent.verticalCenter
        //     }

        // }

    }

}
