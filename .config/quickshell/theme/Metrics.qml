import QtQuick
pragma Singleton

QtObject {
    // ========= SIZING =========
    readonly property int barHeight: 50
    readonly property int barRadius: 12
    readonly property int borderWidth: 2
    readonly property int widgetWidth: 30
    readonly property int widgetHeight: 30
    readonly property int widgetRadius: 8

    // ========= SPACING =========
    readonly property int widgetSpacing: 7
    readonly property int sideMargin: 16
    readonly property int panelMargin: 12
    readonly property int iconTextSpacing: 4

    // ========= ANIMATIONS =========
    readonly property int clockAnimation: 1000
    readonly property int windowTitleFadeAnimation: 200
    
    // ========= INTERVALS =========
    readonly property int updateInterval: 1000
    readonly property int longUpdateInterval: 5000
    readonly property int systemStatsUpdateInterval: 2000
}
