// This is the Persistence Source of Truth. All changes using ThemeSwitcher are first reflected here
// Then each manager has a binding to values here. if the value changes, that manager does its own thing to reflect the change

import QtQuick
import Quickshell
import Quickshell.Io
pragma Singleton

Item {
    id: root

    property string activeTheme
    property string barStyle
    property string notificationStyle
    property string wallpaper
    property string kittyTheme
    property string greetdTheme

    function restore() {
        load();
    }

    // Central Setter Function To Update State
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
        saveProcess.command = ["python3", Quickshell.env("HOME") + "/.config/quickshell/scripts/save-settings.py", activeTheme, barStyle, notificationStyle, wallpaper, kittyTheme, greetdTheme];
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

        command: ["python3", Quickshell.env("HOME") + "/.config/quickshell/scripts/load-settings.py"]

        stdout: StdioCollector {
            onStreamFinished: {
                try {
                    const data = JSON.parse(text);
                    // enter default values here if file not found (or some properties not set yet)
                    root.activeTheme = data.theme || "arch/neon";
                    root.barStyle = data.bar || "SimpleBar";
                    root.notificationStyle = data.notification || "SimpleNotification";
                    root.wallpaper = data.wallpaper || "~/.config/quickshell/themes/arch/neon/wallpaper.jpg";
                    root.kittyTheme = data.kitty || "DefaultKitty";
                    root.greetdTheme = data.greetd || "DefaultGreetd";
                } catch (e) {
                    console.error("Failed loading settings:", e);
                }
            }
        }

    }

}
