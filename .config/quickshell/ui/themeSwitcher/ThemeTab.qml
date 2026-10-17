import "../../services"
import QtQuick
import QtQuick.Controls

ScrollView {
    anchors.margins: 20

    Column {
        spacing: 20
        width: parent.width

        Repeater {
            model: ThemeRegistry.groups()

            delegate: Column {
                required property string modelData

                spacing: 8

                Text {
                    text: modelData.toUpperCase()
                    color: ThemeManager.textPrimary
                    font.pixelSize: 18
                    font.bold: true
                }

                Repeater {
                    model: ThemeRegistry.getThemes(modelData)

                    delegate: Button {
                        required property var modelData

                        width: 200
                        text: modelData.name
                        onClicked: {
                            ThemeManager.applyTheme(modelData.id);
                        }
                    }

                }

            }

        }

    }

}
