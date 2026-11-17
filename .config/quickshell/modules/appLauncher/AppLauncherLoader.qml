import qs.services.ui
import Quickshell
import Quickshell.Io
import QtQuick

Item {    
    IpcHandler {
        target: "appLauncher"
        function toggleAppLauncher(): void { UIManager.toggleOverlay(UIManager.overlay.appLauncher) }
        function showAppLauncher(): void { UIManager.showOverlay(UIManager.overlay.appLauncher)}
        function hideAppLauncher(): void { UIManager.hideOverlay() }
    }

    LazyLoader {
        id: appLauncherLoader

        active: UIManager.activeOverlay === UIManager.overlay.appLauncher

        component: Window {
            id: appLauncherWindow

            color: "transparent"
            flags: Qt.Window | Qt.FramelessWindowHint
            // Provide a hardcoded or calculated fallback sizing if implicit values are 0
            width: switcherContent.implicitWidth
            height: switcherContent.implicitHeight
            title: "App Launcher"
            Component.onCompleted: show()

            AppLauncher {
                id: switcherContent

                anchors.fill: parent
            }

        }

    }

}
