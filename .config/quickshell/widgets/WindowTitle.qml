import Quickshell
import QtQuick
import "../services"

Row {
    // Centered: Active Window Title (Fades smoothly out if empty)
    Text {
        id: windowTitleText
        text: Niri.focusedWindowTitle
        color: "#cdd6f4"
        font.pixelSize: 14
        font.bold: true
        elide: Text.ElideRight
        maximumLineCount: 1
        opacity: text !== "" ? 1.0 : 0.0
        Behavior on opacity { 
            NumberAnimation { 
                duration: 200 
            } 
        }
    }
}