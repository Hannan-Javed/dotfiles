import QtQuick
pragma Singleton

QtObject {
    property string currentBar: "SimpleBar"


    function update(barId) {
        if (!barId)
            return ;

        currentBar = barId;
    }

}
