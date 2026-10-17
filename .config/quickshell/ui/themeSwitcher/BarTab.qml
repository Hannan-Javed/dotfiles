// BarTab.qml
import "../../services"
import QtQuick
import QtQuick.Controls

ScrollView {

    anchors.margins: 20
    Column {
        spacing: 20

        Repeater {
            // Using the raw property list directly is safer for Repeaters than a function return
            model: BarRegistry.bars

            delegate: Button {
                required property var modelData
                width: 250
                text: modelData.name

                onClicked: {
                    BarManager.update(modelData.name)
                }
            }
        }
    }
}
