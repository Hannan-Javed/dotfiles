import "../services"
import "./styles"
import QtQuick

Loader {
    id: barLoader

    anchors.fill: parent
    source: Qt.resolvedUrl(`styles/${CustomizationManager.barStyle}.qml`)
    active: CustomizationManager.barStyle !== "" // only force load when there is an actual value
}
