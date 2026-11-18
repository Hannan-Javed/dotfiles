import QtQuick
import Quickshell
import qs.modules.appLauncher
import qs.modules.bar
import qs.modules.customizationCenter
import qs.modules.displaySettings
import qs.modules.notifications
import qs.services.customization

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
