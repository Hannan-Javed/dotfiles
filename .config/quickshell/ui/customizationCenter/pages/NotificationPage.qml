import "../../../services"
import "../../../theme"
import "../components"

StyleSelector {
    items: NotificationRegistry.notifications
    previewRatio: Metrics.notificationPreviewRatio
    onActivated: (item) => {
        UserPreferences.setSetting("notificationStyle", item.name);
    }
}
