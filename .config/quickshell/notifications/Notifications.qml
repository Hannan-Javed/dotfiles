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

        keepOnReload: true
        onNotification: (notification) => {
            notification.tracked = true;
            notification.expireAt = Date.now() + Metrics.notificationInterval;
            notification.animatedIn = false;
            NotificationHistory.add(notification);
        }
    }

    Column {
        id: notificationsColumn

        spacing: 10

        Repeater {
            model: server.trackedNotifications.values

            delegate: NotificationCard {
            }

        }

    }

}
