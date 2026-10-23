import "../../notifications"
import "../../theme"
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

            //  notification card starts from here
            delegate: Rectangle {
                id: root

                required property var modelData
                readonly property int hiddenX: width + 50
                readonly property string previewImage: {
                    // make previewImage use appicon instead
                    if (modelData.appName === "niri" && modelData.appIcon !== "" && modelData.image === "")
                        return modelData.appIcon;

                    // make appIcon use previewImage instead
                    if ((modelData.appName === "NetworkManager Applet" || modelData.appName === "pcloud") && modelData.appIcon === "" && modelData.image !== "")
                        return "";

                    return modelData.image;
                }
                readonly property string finalAppIcon: {
                    // make previewImage use appicon instead
                    if (modelData.appName === "niri" && modelData.appIcon !== "" && modelData.image === "")
                        return "";

                    // make appIcon use previewImage instead
                    if ((modelData.appName === "NetworkManager Applet" || modelData.appName === "pcloud") && modelData.appIcon === "" && modelData.image !== "")
                        return modelData.image;

                    return modelData.appIcon;
                }

                function isImageSource(icon) {
                    return icon && icon !== "" && (icon.startsWith("/") || icon.startsWith("file://") || icon.startsWith("image://"));
                }

                function closeNotification() {
                    slide.x = root.hiddenX;
                    closeTimer.start();
                }

                width: Metrics.notificationWidth
                implicitHeight: content.implicitHeight + 20
                radius: 16
                color: Colors.background
                border.width: Metrics.borderWidth
                border.color: modelData.urgency === 2 ? Colors.red : Colors.border
                Component.onCompleted: {
                    timeoutTimer.interval = Math.max(0, modelData.expireAt - Date.now());
                    timeoutTimer.start();
                    if (!modelData.animatedIn) {
                        slide.x = 0;
                        modelData.animatedIn = true;
                    }
                }

                Column {
                    // Header
                    // Title
                    // Body
                    // Notification image

                    id: content

                    anchors.fill: parent
                    anchors.margins: 12
                    // vertical spacing within the notification
                    spacing: 6

                    Row {
                        // horizontal spacing between appIcon and the app
                        spacing: 4

                        Rectangle {
                            width: Metrics.notificationAppIconSize
                            height: Metrics.notificationAppIconSize
                            radius: 6
                            color: Colors.background
                            visible: finalAppIcon !== ""

                            Image {
                                anchors.fill: parent
                                anchors.margins: 2
                                source: isImageSource(finalAppIcon) ? finalAppIcon : Quickshell.iconPath(finalAppIcon, "fallback")
                                fillMode: Image.PreserveAspectFit
                            }

                        }

                        Text {
                            text: modelData.appName || "Notification"
                            color: Colors.textSecondary
                            font.pixelSize: 14
                            anchors.verticalCenter: parent.verticalCenter
                            font.bold: true
                        }

                    }

                    Text {
                        text: modelData.summary
                        width: parent.width
                        color: Colors.textPrimary
                        font.pixelSize: 15
                        font.bold: true
                        wrapMode: Text.NoWrap
                        elide: Text.ElideRight
                        maximumLineCount: 1
                        visible: text !== ""
                    }

                    Text {
                        text: modelData.body
                        width: parent.width
                        color: Colors.textSecondary
                        font.pixelSize: 13
                        wrapMode: Text.NoWrap
                        elide: Text.ElideRight
                        maximumLineCount: 10
                        visible: text !== ""
                    }

                    Rectangle {
                        width: parent.width
                        height: Math.min(width * preview.sourceSize.height / Math.max(preview.sourceSize.width, 1), 250)
                        color: Colors.background
                        visible: previewImage !== ""

                        Image {
                            id: preview

                            anchors.fill: parent
                            source: previewImage
                            fillMode: Image.PreserveAspectFit
                            smooth: true
                        }

                    }

                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        let action = modelData.actions.find((a) => {
                            return a.identifier === "default";
                        });
                        if (action)
                            action.invoke();

                        closeNotification();
                    }
                }

                Timer {
                    id: timeoutTimer

                    onTriggered: closeNotification()
                }

                Timer {
                    id: closeTimer

                    interval: 250
                    onTriggered: {
                        modelData.tracked = false;
                    }
                }

                transform: Translate {
                    id: slide

                    x: modelData.animatedIn ? 0 : root.hiddenX

                    Behavior on x {
                        NumberAnimation {
                            duration: 250
                            easing.type: Easing.OutCubic
                        }

                    }

                }

            }

        }

    }

}
