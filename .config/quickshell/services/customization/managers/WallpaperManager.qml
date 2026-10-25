import "../../../services"
import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

// runtime owner of wallpaper
Item {
    property string currentWallpaper: UserPreferences.wallpaper

    onCurrentWallpaperChanged: {
        if (!currentWallpaper)
            return ;

        wallpaperSetter.command = [Quickshell.env("HOME") + "/.config/quickshell/scripts/appearance/set-wallpaper.sh", currentWallpaper];
        // Launch it detached so Quickshell doesn't wait for swaybg
        wallpaperSetter.startDetached();
    }

    Process {
        id: wallpaperSetter
    }

}
