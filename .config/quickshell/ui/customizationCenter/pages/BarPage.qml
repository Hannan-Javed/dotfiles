import "../../../services"
import "../../../theme"
import "../components"

StyleSelector {
    items: BarRegistry.bars
    previewRatio: Metrics.barPreviewRatio
    onActivated: (item) => {
        UserPreferences.setSetting("barStyle", item.name);
    }
}
