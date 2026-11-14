import qs.services.customization
import qs.theme
import "styles"
import QtQuick

Loader {
    anchors.fill: parent
    source: Qt.resolvedUrl(`styles/${UserPreferences.notificationStyle}.qml`)
    active: UserPreferences.notificationStyle !== "" // only force load when there is an actual value
}
