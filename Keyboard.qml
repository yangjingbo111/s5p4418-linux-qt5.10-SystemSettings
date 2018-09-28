import QtQuick 2.9
import QtQuick.Controls 2.2 as Controls
import QtQuick.VirtualKeyboard 2.2

Controls.TextField {
    id: control
    color: "#2B2C2E"
    selectionColor: Qt.rgba(0.0, 0.0, 0.0, 0.15)
    selectedTextColor: color
    font.pixelSize: Qt.application.font.pixelSize * 2

    property int enterKeyAction: EnterKeyAction.None
    readonly property bool enterKeyEnabled: enterKeyAction === EnterKeyAction.None || text.length > 0 || inputMethodComposing

    background: Rectangle {
        color: "#FFFFFF"
        border.width: 1
        border.color: control.activeFocus ? "#5CAA15" : "#BDBEBF"
    }
}
