import QtQuick
pragma Singleton

QtObject {
    // ========= SIZING =========
    readonly property int barHeight: 50
    readonly property int barRadius: 12
    readonly property int borderWidth: 1
    readonly property int widgetWidth: 30
    readonly property int widgetHeight: 30
    readonly property int widgetRadius: 8
    readonly property int notificationWidth: 450
    readonly property int notificationAppIconSize: 25

    // ========= THEME SWITCHER =========
    readonly property int themeSwitcherWidth: 1000
    readonly property int themeSwitcherHeight: 600
    readonly property real barPreviewRatio: 0.2
    readonly property real notificationPreviewRatio: 0.3
    readonly property real themePreviewRatio: 0.5
    readonly property int wallpaperTileWidth: 300
    readonly property int wallpaperTileHeight: 220
    readonly property int wallpaperTileSpacing: 16

    // ========= SPACING =========
    readonly property int widgetSpacing: 7
    readonly property int sideMargin: 16
    readonly property int panelMargin: 12
    readonly property int iconTextSpacing: 4
    readonly property int notificationTopMargin: 72

    // ========= ANIMATIONS =========
    readonly property int clockAnimation: 1000
    readonly property int windowTitleFadeAnimation: 200

    // ========= INTERVALS =========
    readonly property int updateInterval: 1000
    readonly property int longUpdateInterval: 5000
    readonly property int systemStatsUpdateInterval: 2000
    readonly property int notificationInterval: 5000
}
