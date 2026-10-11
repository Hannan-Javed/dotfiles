import "../theme"
import QtQuick
import Quickshell

Rectangle {
    id: root

    readonly property bool appIconIsImage: isImageSource(modelData.appIcon)
    required property var modelData
    readonly property int hiddenX: width + 50
    readonly property string previewImage: modelData.image !== "" ? modelData.image : (appIconIsImage ? modelData.appIcon : "")

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
        spacing: 6

        Row {
            spacing: 4

            Rectangle {
                width: Metrics.notificationAppIconSize
                height: Metrics.notificationAppIconSize
                radius: 6
                color: Colors.background
                visible: modelData.appIcon !== "" && !appIconIsImage

                Image {
                    anchors.fill: parent
                    anchors.margins: 2
                    source: Quickshell.iconPath(modelData.appIcon, true)
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
            wrapMode: Text.WordWrap
            visible: text !== ""
        }

        Text {
            text: modelData.body
            width: parent.width
            color: Colors.textSecondary
            font.pixelSize: 13
            wrapMode: Text.WordWrap
            visible: text !== ""
        }

        Rectangle {
            width: parent.width
            height: Metrics.notificationImageHeight
            radius: 12
            clip: true
            visible: previewImage !== ""

            Image {
                anchors.fill: parent
                source: previewImage
                fillMode: Image.PreserveAspectCrop
                asynchronous: true
            }

        }

    }

    MouseArea {
        anchors.fill: parent
        onClicked: {
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
