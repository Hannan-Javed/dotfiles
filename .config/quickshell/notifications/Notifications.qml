import "../theme"
import QtQuick
import Quickshell
import Quickshell.Services.Notifications

PanelWindow {
    id: root

    exclusionMode: ExclusionMode.Ignore
    color: "transparent"
    implicitWidth: notificationsColumn.width
    implicitHeight: notificationsColumn.height

    anchors {
        top: true
        right: true
    }

    margins {
        top: Metrics.notificationTopMargin
        right: 14
    }

    NotificationServer {
        id: server

        // Crucial for Firefox, Chrome etc
        actionsSupported: true
        bodyImagesSupported: true
        actionIconsSupported: true
        persistenceSupported: true

        keepOnReload: true
        onNotification: (notification) => {
            notification.tracked = true;
            if (!notification.resident)
                notification.expireAt = Date.now() + Metrics.notificationInterval;

            notification.animatedIn = false;
            NotificationHistory.add(notification);
        }
    }

    Column {
        id: notificationsColumn

        // vertical spacing between multiple notifications
        spacing: 10

        Repeater {
            model: server.trackedNotifications.values

            delegate: NotificationCard {
            }

        }

    }

}
