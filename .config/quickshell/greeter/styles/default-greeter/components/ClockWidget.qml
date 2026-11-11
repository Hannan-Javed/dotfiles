import QtQuick

Column {
    spacing: 4

    property date now: new Date()

    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: parent.now = new Date()
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter

        text: Qt.formatTime(parent.now, "hh:mm")
        color: "white"
        font.pixelSize: 72
        font.bold: true
    }

    Text {
        anchors.horizontalCenter: parent.horizontalCenter

        text: Qt.formatDate(parent.now, "dddd, MMMM d")
        color: "#cccccc"
        font.pixelSize: 16
    }
}