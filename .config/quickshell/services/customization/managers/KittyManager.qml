import ".."
import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

// runtime owner of kitty theme
Item {
    property string currentKittyStyle: UserPreferences.kittyStyle

    onCurrentKittyStyleChanged: {
        if (!currentKittyStyle)
            return ;

        kittyStyleSetter.command = [Quickshell.shellDir + "/scripts/appearance/set-style.sh", currentKittyStyle, Quickshell.env("HOME") + "/.config/kitty"];
        kittyStyleSetter.startDetached();
    }

    Process {
        id: kittyStyleSetter
    }

}
