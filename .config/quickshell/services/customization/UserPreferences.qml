// This is the Persistence Source of Truth. All changes using ThemeSwitcher are first reflected here
// Then each manager has a binding to values here. if the value changes, that manager does its own thing to reflect the change

import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

Item {
    id: root

    property string activePreset
    property string paletteStyle
    property string barStyle
    property string notificationStyle
    property string wallpaper
    property string kittyStyle
    property string niriStyle
    property string greetdStyle

    function restore() {
        load();
    }

    // central setter function to update state
    function setSetting(key, value) {
        if (!key)
            return ;

        if (root.hasOwnProperty(key)) {
            root[key] = value;
            save();
        } else {
            console.warn("Attempted to set an invalid configuration key:", key);
        }
    }

    function save() {
        saveProcess.command = ["python3", Quickshell.env("HOME") + "/.config/quickshell/scripts/settings/save-settings.py", paletteStyle, barStyle, notificationStyle, wallpaper, kittyStyle, greetdStyle];
        saveProcess.running = true;
    }

    function load() {
        loadProcess.running = true;
    }

    Component.onCompleted: {
        restore();
    }

    Process {
        id: saveProcess
    }

    Process {
        id: loadProcess

        command: ["python3", Quickshell.env("HOME") + "/.config/quickshell/scripts/settings/load-settings.py"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(text);
                    // enter default values here if file not found (or some properties not set yet)
                    root.paletteStyle = data.palette || "purple";
                    root.barStyle = data.bar || "SimpleBar/Bar";
                    root.notificationStyle = data.notification || "SimpleNotification/Notification";
                    root.wallpaper = data.wallpaper || "~/.config/quickshell/themes/arch/neon/wallpaper.jpg";
                    root.kittyStyle = data.kitty || "default-kitty";
                    root.niriStyle = data.kitty || "default-niri";
                    root.greetdStyle = data.greetd || "DefaultGreetd";
                } catch (e) {
                    console.error("Failed loading settings:", e);
                }
            }
        }

    }

}
