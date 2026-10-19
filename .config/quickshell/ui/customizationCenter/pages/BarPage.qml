import "../../../services"
import QtQuick
import QtQuick.Controls

ScrollView {
    anchors.margins: 20

    Column {
        spacing: 20

        Repeater {
            model: BarRegistry.bars

            delegate: Button {
                required property var modelData

                width: 250
                text: modelData.name
                onClicked: {
                    CustomizationManager.setSetting("barStyle", modelData.name);
                }
            }

        }

    }

}
