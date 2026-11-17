import qs.services.customization
import qs.modules.bar
import qs.modules.notifications
import qs.modules.appLauncher
import qs.modules.customizationCenter
import QtQuick
import Quickshell

ShellRoot {
    id: root

    // to awake background service singletons on startup, wrap it in onCompleted
    Component.onCompleted: {
        const awakeWallpaper = WallpaperManager;
        const awakeKitty = KittyManager;
        const awakeNiri = NiriManager;
        const awakeGreeter = GreeterManager;
    }

    Bar {
    }

    Notifications {
    }

    CustomizationCenterLoader {
    }

    AppLauncherLoader {
    }
    

}
