import QtQuick
import qs.services.customization
pragma Singleton

QtObject {
    readonly property color background: PaletteManager.background
    readonly property color border: PaletteManager.border
    readonly property color textPrimary: PaletteManager.textPrimary
    readonly property color textSecondary: PaletteManager.textSecondary
    readonly property color white: "#ffffff"
    readonly property color red: "#f38ba8"
    readonly property color yellow: "#f9e2af"
    readonly property color green: "#a6e3a1"
    readonly property color blue: '#318aff'
    readonly property color peach: "#fab387"
    readonly property color workspaceInactive: "#45475a"
    readonly property color workspaceActive: border
    readonly property color cpuIcon: "#89b4fa"
    readonly property color memoryIcon: "#f9e2af"
    readonly property color rightWidgetIconBackground: "#313244"
}
