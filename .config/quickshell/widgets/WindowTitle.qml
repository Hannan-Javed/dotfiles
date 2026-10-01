import "../services"
import "../theme"
import QtQuick
import Quickshell

Row {
    // Centered: Active Window Title (Fades smoothly out if empty)
    Text {
        id: windowTitleText

        text: Niri.focusedWindowTitle
        color: Colors.textPrimary
        font.pixelSize: Typography.large
        font.bold: true
        elide: Text.ElideRight
        maximumLineCount: 1
        opacity: text !== "" ? 1 : 0

        Behavior on opacity {
            NumberAnimation {
                duration: Metrics.windowTitleFadeAnimation
            }

        }

    }

}
