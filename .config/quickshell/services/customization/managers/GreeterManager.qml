import ".."
import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

// runtime owner of greeter theme
Item {
    property string currentGreeterStyle: UserPreferences.greeterStyle

    onCurrentGreeterStyleChanged: {
        if (!currentGreeterStyle)
            return ;

        greeterStyleSetter.command = [Quickshell.shellDir + "/scripts/appearance/set-greeter.sh", currentGreeterStyle];
        greeterStyleSetter.startDetached();
    }

    Process {
        id: greeterStyleSetter
    }

}
