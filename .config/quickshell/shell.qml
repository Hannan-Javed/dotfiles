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
        const awakeKitty = KittyManager;
    }

    Bar {
    }

    Notifications {
    }

    LazyLoader {
        id: appearanceCenterLoader

        active: UIManager.appearanceCenterVisible

        component: Window {
            id: appearanceCenterWindow
            color: "transparent"
            flags: Qt.Window | Qt.FramelessWindowHint
              // Provide a hardcoded or calculated fallback sizing if implicit values are 0
            width: switcherContent.implicitWidth
            height: switcherContent.implicitHeight

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
