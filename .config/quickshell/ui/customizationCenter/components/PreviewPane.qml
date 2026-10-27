import "../../../theme"
import QtQuick
import QtQuick.Controls

Item {
    id: root

    property string previewSource: ""
    property string title: ""
    property real imageHeightRatio: 0.85

    Column {
        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        Image {
            width: parent.width
            height: parent.height * root.imageHeightRatio

            anchors.horizontalCenter: parent.horizontalCenter

            fillMode: Image.PreserveAspectFit
            smooth: true
            mipmap: true

            source: root.previewSource
        }

        Text {
            width: parent.width

            horizontalAlignment: Text.AlignHCenter

            text: root.title

            color: Colors.textSecondary
            font.family: Typography.fontFamily
            font.pixelSize: 13
        }
    }
}