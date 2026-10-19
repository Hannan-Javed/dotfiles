import "../../services"
import QtQuick
import QtQuick.Controls

ScrollView {
    anchors.margins: 20

    Column {
        spacing: 20

        Repeater {
            model: NotificationRegistry.notifications

            delegate: Button {
                required property var modelData

                width: 250
                text: modelData.name
                onClicked: {
                    CustomizationManager.setSetting("notificationStyle", modelData.name);
                }
            }

        }

    }

}
