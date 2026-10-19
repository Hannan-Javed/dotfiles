import "./bar"
import "./notifications"
import "./services"
import "./ui/customizationCenter"
import QtQuick
import Quickshell
import Quickshell.Io

ShellRoot {
    id: root

    IpcHandler {
        target: "appearance"
        function toggleAppearanceCenter(): void { UIManager.toggleAppearanceCenter() }
        function showAppearanceCenter(): void { UIManager.showAppearanceCenter() }
        function hideAppearanceCenter(): void { UIManager.hideAppearanceCenter() }
    }

    // to awake background service singletons on startup, wrap it in onCompleted
    Component.onCompleted: {
        const awakeWallpaper = WallpaperManager;
    }

    Bar {
    }

    Notifications {
    }

    LazyLoader {
        id: appearanceCenterLoader

        active: UIManager.appearanceCenterVisible

        component: FloatingWindow {
            id: appearanceCenterWindow

            implicitWidth: switcherContent.implicitWidth
            implicitHeight: switcherContent.implicitHeight
            visible: true
            onVisibleChanged: {
                if (!visible)
                    UIManager.hideAppearanceCenter();

            }

            CustomizationCenter {
                id: switcherContent
                anchors.fill: parent
            }

        }

    }

}
