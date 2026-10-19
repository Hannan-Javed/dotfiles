import "../services"
import "./styles"
import QtQuick

Loader {
    id: barLoader

    anchors.fill: parent
    source: Qt.resolvedUrl(`styles/${UserPreferences.barStyle}.qml`)
    active: UserPreferences.barStyle !== "" // only force load when there is an actual value
}
