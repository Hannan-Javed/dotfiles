import "../../../services"
import "../../../theme"
import "../../../greeter"
import "../components"

StyleSelector {
    items: GreeterRegistry.greeters
    previewRatio: Metrics.presetPreviewRatio
    appliedStyle: GreeterRegistry.getGreeter(UserPreferences.greeterStyle)
    onActivated: (item) => {
        UserPreferences.setSetting("greeterStyle", item.id);
    }
}
