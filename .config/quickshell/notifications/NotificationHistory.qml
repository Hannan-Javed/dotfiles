import QtQuick
pragma Singleton

QtObject {
    property var notifications: []

    function add(notification) {
        notifications.unshift({
            "appName": notification.appName,
            "summary": notification.summary,
            "body": notification.body,
            "urgency": notification.urgency,
            "appIcon": notification.appIcon,
            "timestamp": Date.now()
        });
    }

}
