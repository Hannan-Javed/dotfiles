import "../../../services"
import "../../../theme"
import "../components"

StyleSelector {
    items: PaletteRegistry.palettes
    previewRatio: Metrics.palettePreviewRatio
    appliedStyle: PaletteRegistry.getPalette(UserPreferences.paletteStyle)
    onActivated: (item) => {
        UserPreferences.setSetting("paletteStyle", item.id);
    }
}
