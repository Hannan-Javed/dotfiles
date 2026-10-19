import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

// scanner of notifications in notifications/styles directory
Item {
    id: root

    property var notifications: []

    function reload() {
        scanner.running = true;
    }

    function getNotifications() {
        return notifications;
    }

    function getNotification(name) {
        for (let i = 0; i < notifications.length; i++) {
            if (notifications[i].name === name)
                return notifications[i];

        }
        return null;
    }

    Component.onCompleted: reload()

    Process {
        id: scanner

        command: ["python3", Quickshell.env("HOME") + "/.config/quickshell/scripts/scan-styles.py", Quickshell.env("HOME") + "/.config/quickshell/notifications/styles"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    root.notifications = JSON.parse(text.trim());
                } catch (e) {
                    console.error("Failed parsing Notification registry:", e);
                }
            }
        }

    }

}
