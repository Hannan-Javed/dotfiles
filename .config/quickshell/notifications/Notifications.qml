import "../services"
import "./styles"
import QtQuick

Loader {
    id: notificationLoader

    anchors.fill: parent
    source: Qt.resolvedUrl(`styles/${CustomizationManager.notificationStyle}.qml`)
    active: CustomizationManager.notificationStyle !== "" // only force load when there is an actual value
}
