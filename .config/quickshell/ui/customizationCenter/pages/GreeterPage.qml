import "../../../services"
import "../../../theme"
import "../components"

StyleSelector {
    items: GreeterRegistry.greeters
    // previewRatio: Metrics.greeterPreviewRatio
    appliedStyle: GreeterRegistry.getGreeter(UserPreferences.greeterStyle)
    onActivated: (item) => {
        UserPreferences.setSetting("greeterStyle", item.id);
    }
}
