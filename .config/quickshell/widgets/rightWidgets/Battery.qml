import QtQuick
import Quickshell.Services.UPower
import "../../theme"

Row {

    property var bat: UPower.displayDevice

    property real batteryPercent:
        bat ? bat.percentage * 100 : 0

    property bool batteryCharging:
        bat ? bat.state === UPowerDeviceState.Charging : false
    
    spacing: Metrics.iconTextSpacing

    function icon() {
        if (batteryCharging)
            return "󰂄";

        if (batteryPercent > 85)
            return "󰁹";

        if (batteryPercent > 60)
            return "󰂀";

        if (batteryPercent > 40)
            return "󰁾";

        if (batteryPercent > 20)
            return "󰁻";

        return "󰂎";
    }

    Text {
        text: icon()
        font.family: Typography.fontFamily
        font.pixelSize: Typography.iconSize
        anchors.verticalCenter: parent.verticalCenter

        color: batteryCharging ? Colors.green: batteryPercent <= 20? Colors.red : Colors.textPrimary
    }

    Text {
        text: Math.round(batteryPercent) + "%"
        color: Colors.textPrimary
        font.pixelSize: Typography.normal
        anchors.verticalCenter: parent.verticalCenter
    }
}