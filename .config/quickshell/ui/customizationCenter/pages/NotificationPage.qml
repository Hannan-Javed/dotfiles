import "../../../services"
import "../../../theme"
import "../components"

StyleSelector {
    items: NotificationRegistry.notifications
    previewRatio: Metrics.notificationPreviewRatio
    appliedStyle: NotificationRegistry.getNotification(UserPreferences.notificationStyle)
    onActivated: (item) => {
        UserPreferences.setSetting("notificationStyle", item.name);
    }
}
