import "../components"
import qs.modules.bar
import qs.services.customization
import qs.theme

StyleSelector {
    items: BarRegistry.bars
    previewRatio: Metrics.barPreviewRatio
    appliedStyle: BarRegistry.getBar(UserPreferences.barStyle)
    onActivated: (item) => {
        UserPreferences.setSetting("barStyle", item.id);
    }
}
