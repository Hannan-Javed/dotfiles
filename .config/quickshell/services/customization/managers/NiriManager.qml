import "../../../services"
import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

// runtime owner of niri theme
Item {
    property string currentNiriStyle: UserPreferences.niriStyle

    onCurrentNiriStyleChanged: {
        if (!currentNiriStyle)
            return ;
        niriStyleSetter.command = [Quickshell.env("HOME") + "/.config/quickshell/scripts/appearance/set-niri-theme.sh", currentNiriStyle];
        niriStyleSetter.startDetached();
    }

    Process {
        id: niriStyleSetter
    }

}
