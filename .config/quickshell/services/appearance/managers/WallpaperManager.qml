import "../../../services"
import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

// Runtime owner of wallpaper
Item {
    property string currentWallpaper: CustomizationManager.wallpaper

    onCurrentWallpaperChanged: {
        console.log("ran");
        if (!currentWallpaper)
            return ;

        wallpaperSetter.command = [Quickshell.env("HOME") + "/.config/quickshell/scripts/set-wallpaper.sh", currentWallpaper];
        // Launch it detached so Quickshell doesn't wait for swaybg
        wallpaperSetter.startDetached();
    }

    Process {
        id: wallpaperSetter
    }

}
