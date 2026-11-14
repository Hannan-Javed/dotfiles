pragma Singleton
import QtQuick

QtObject {
    id: root

    // Explicitly reference all background/external managers here
    // so shell.qml stays completely clean.
    readonly property var managers: [
        WallpaperManager,
        PaletteManager,
        PresetManager,
        KittyManager,
        NiriManager,
        GreeterManager
    ]

    function init() {
        // Trigger initial scans or state syncs if needed
        RegistryManager.scanAll()
    }
}
