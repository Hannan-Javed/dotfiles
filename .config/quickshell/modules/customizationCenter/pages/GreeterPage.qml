import "../components"
import qs.services.customization
import qs.theme

StyleSelector {
    items: GreeterRegistry.greeters
    previewRatio: Metrics.presetPreviewRatio
    appliedStyle: GreeterRegistry.getGreeter(UserPreferences.greeterStyle)
    onActivated: (item) => {
        UserPreferences.setSetting("greeterStyle", item.id);
    }
}
