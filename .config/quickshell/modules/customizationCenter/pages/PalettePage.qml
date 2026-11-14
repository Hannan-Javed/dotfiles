import "../components"
import qs.services.customization
import qs.theme

StyleSelector {
    items: PaletteRegistry.palettes
    previewRatio: Metrics.palettePreviewRatio
    appliedStyle: PaletteRegistry.getPalette(UserPreferences.paletteStyle)
    onActivated: (item) => {
        UserPreferences.setSetting("paletteStyle", item.id);
    }
}
