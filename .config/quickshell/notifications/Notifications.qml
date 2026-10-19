import "../services"
import "./styles"
import QtQuick

Loader {
    id: notificationLoader

    anchors.fill: parent
    source: Qt.resolvedUrl(`styles/${UserPreferences.notificationStyle}.qml`)
    active: UserPreferences.notificationStyle !== "" // only force load when there is an actual value
}
