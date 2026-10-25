import "../../../services"
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
        kittyStyleSetter.command = [Quickshell.env("HOME") + "/.config/quickshell/scripts/set-kitty-theme.sh", currentKittyStyle];
        kittyStyleSetter.startDetached();
    }

    Process {
        id: kittyStyleSetter
    }

}
