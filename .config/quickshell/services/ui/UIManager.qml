pragma Singleton

import QtQuick

QtObject {
    readonly property var overlay: ({
        none: "none",
        customizationCenter: "customizationCenter",
    })

    property string activeOverlay: overlay.none

    function showOverlay(name) {
        activeOverlay = name
    }

    function hideOverlay() {
        activeOverlay = overlay.none
    }

    // the overlays in Overlay are mutually exclusive - only one at a time
    function toggleOverlay(name) {
        activeOverlay =
            activeOverlay === name
            ? overlay.none
            : name
    }
}