import QtQuick
import Quickshell.Services.UPower

Row {

    property var bat: UPower.displayDevice

    property real batteryPercent:
        bat ? bat.percentage * 100 : 0

    property bool batteryCharging:
        bat ? bat.state === UPowerDeviceState.Charging : false

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
        font.family: "JetBrainsMono Nerd Font"
        font.pixelSize: 17
        anchors.verticalCenter: parent.verticalCenter

        color: batteryPercent <= 20 && !batteryCharging ? "#f38ba8" : "#cdd6f4"
    }
    
    // to add a relatively small space between icon and percentage
    Text {
        text: " "
        font.pixelSize: 10
    }

    Text {
        text: Math.round(batteryPercent) + "%"
        color: "#cdd6f4"
        font.pixelSize: 13
        anchors.verticalCenter: parent.verticalCenter
    }
}