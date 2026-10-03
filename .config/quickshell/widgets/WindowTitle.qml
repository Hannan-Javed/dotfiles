import "../services"
import "../theme"
import QtQuick
import Quickshell
import Quickshell.Widgets

Row {
    // Centered: Active Window Title (Fades smoothly out if empty)
    spacing: Metrics.iconTextSpacing
    opacity: Niri.focusedWindowTitle !== "" ? 1 : 0

    Row {
        opacity: Niri.focusedWindowTitle !== "" ? 1 : 0

        IconImage {
            source: Quickshell.iconPath(Niri.focusedIconName || "fallback")
            implicitWidth: Typography.boxedIconSize
            implicitHeight: Typography.boxedIconSize
        }

        Behavior on opacity {
            NumberAnimation {
                duration: Metrics.windowTitleFadeAnimation
            }

        }

    }

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
