import QtQuick
pragma Singleton

QtObject {
    readonly property string fontFamily: "JetBrains Mono"
    readonly property int small: 10
    readonly property int normal: 13
    readonly property int large: 16

    readonly property int windowIconSize: 26
    readonly property int boxedIconSize: 20
    readonly property int iconSize: 24
}
