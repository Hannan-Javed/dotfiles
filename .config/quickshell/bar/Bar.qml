import "../services"
import "./styles"
import QtQuick

Loader {
    id: barLoader

    anchors.fill: parent
    // Wrap the string paths inside Qt.resolvedUrl()
    source: BarManager.currentBar ? Qt.resolvedUrl(`styles/${BarManager.currentBar}.qml`) : Qt.resolvedUrl("styles/SimpleBar.qml")
    onStatusChanged: {
        if (status === Loader.Error) {
            console.error("Failed to load layout:", source);
            // Also resolve the fallback path here
            source = Qt.resolvedUrl("styles/SimpleBar.qml");
        }
    }
}
