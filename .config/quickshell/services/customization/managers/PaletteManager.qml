import "../../../services"
import QtQuick
pragma Singleton

// Runtime owner of palette colors
QtObject {
    id: root

    property color background
    property color border
    property color textPrimary: "#ffffff"
    property color textSecondary: "#6c757d"
    // current palette selected by the user
    property string currentPalette: UserPreferences.paletteStyle
    // registry lookup
    property var registryIndex: PaletteRegistry.paletteIndex

    function updatePalette() {
        // exit early if data is not ready yet
        if (!currentPalette || !registryIndex || Object.keys(registryIndex).length === 0)
            return ;
        
        const palette = registryIndex[currentPalette];
        if (!palette) {
            console.warn("Palette not found in registry yet:", currentPalette);
            return ;
        }
        // apply palette colors dynamically
        for (const key in palette.colors) {
            if (root.hasOwnProperty(key))
                root[key] = palette.colors[key];

        }
    }

    onCurrentPaletteChanged: updatePalette()
    onRegistryIndexChanged: updatePalette()
}
