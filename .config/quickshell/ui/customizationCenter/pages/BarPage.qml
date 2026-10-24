import "../../../services"
import "../../../theme"
import "../components"

StyleSelector {
    items: BarRegistry.bars
    previewRatio: Metrics.barPreviewRatio
    appliedStyle: BarRegistry.getBar(UserPreferences.barStyle)
    onActivated: (item) => {
        UserPreferences.setSetting("barStyle", item.name);
    }
}
