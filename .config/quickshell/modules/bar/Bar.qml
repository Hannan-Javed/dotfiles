import QtQuick
import qs.services.customization
import "styles"

Loader {
    anchors.fill: parent
    source: Qt.resolvedUrl(`styles/${UserPreferences.barStyle}.qml`)
    active: UserPreferences.barStyle !== "" // only force load when there is an actual value
}
