import "../theme"
import QtQuick
import Quickshell

Rectangle {
    id: root

    required property var modelData
    readonly property int hiddenX: width + 50

    function closeNotification() {
        slide.x = root.hiddenX;
        closeTimer.start();
    }

    width: Metrics.notificationWidth
    implicitHeight: content.implicitHeight + 24
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

    Row {
        id: content

        anchors.fill: parent
        anchors.margins: 12
        spacing: 12

        Rectangle {
            width: 42
            height: 42
            radius: 10
            color: Colors.border
            visible: modelData.appIcon !== ""

            Image {
                anchors.centerIn: parent
                width: 24
                height: 24
                source: modelData.appIcon
                fillMode: Image.PreserveAspectFit
                visible: source !== ""
            }

        }

        Column {
            width: parent.width - 70
            spacing: 3

            Text {
                text: modelData.appName || "Notification"
                color: Colors.textPrimary
                font.pixelSize: 11
                font.bold: true
            }

            Text {
                text: modelData.summary
                color: Colors.textPrimary
                font.pixelSize: 14
                font.bold: true
                wrapMode: Text.WordWrap
                width: parent.width
            }

            Text {
                visible: modelData.body !== ""
                text: Colors.textSecondary
                color: "#bac2de"
                font.pixelSize: 12
                wrapMode: Text.WordWrap
                width: parent.width
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
