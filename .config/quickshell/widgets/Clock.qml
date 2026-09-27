import Quickshell
import QtQuick

Row {
    id: root
    property string currentDateTimeString: ""
    Timer {
        id: clockTimer
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: {
            let date = new Date();
            
            // Arrays to map short strings manually
            let days = ["SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT"];
            let months = ["JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC"];
            
            let dayName = days[date.getDay()];
            let monthName = months[date.getMonth()];
            
            // Zero padding formatting helpers
            let dd = String(date.getDate()).padStart(2, '0');
            let hh = String(date.getHours()).padStart(2, '0');
            let mm = String(date.getMinutes()).padStart(2, '0');
            let ss = String(date.getSeconds()).padStart(2, '0');
            
            // Output matches standard layout template: DAY, DD-MON, HH:MM:SS
            currentDateTimeString = `${dayName}, ${dd}-${monthName}, ${hh}:${mm}:${ss}`;
        }
    }
    // Smoothly Sliding Clock Component
    Text {
        id: dynamicClock
        text: currentDateTimeString
        color: '#ffffff'
        font.pixelSize: 14
        font.bold: true
        font.family: "monospace" // Fixed-width prevents text layout jittering
        anchors.verticalCenter: parent.verticalCenter// --- DYNAMIC ALIGNMENT CALCULATION ---// Target coordinates: Center of the bar vs Right margin offset
    }
}