import "../components"
import qs.modules.notifications
import qs.services.customization
import qs.theme

StyleSelector {
    items: NotificationRegistry.notifications
    previewRatio: Metrics.notificationPreviewRatio
    appliedStyle: NotificationRegistry.getNotification(UserPreferences.notificationStyle)
    onActivated: (item) => {
        UserPreferences.setSetting("notificationStyle", item.id);
    }
}
