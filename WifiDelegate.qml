import QtQuick 2.7
import QtQuick.Controls 2.0

ItemDelegate{
    id: wifiDelegate
    width: parent.width
    height: 48
    spacing: 4

    signal itemChoosed()

    onItemChoosed: {
        console.log(model.ssid)
    }

    Rectangle{
        id: wrap
        anchors.fill: parent
        color: Qt.rgba(0,49/255,104/255,1)

        Row{
            spacing: 16
            Item{
                id: ssidContainer
                height: wrap.height
                width: 380
                Text{
                    id: ssid
                    anchors.centerIn: parent
                    text: model.ssid
                    color: "white"
                }
            }
            Item{
                id: levelContainer
                height: wrap.height
                width: 40
                Text{
                    id: level
                    anchors.centerIn: parent
                    text: model.level
                    color: "white"
                }
            }
            Item{
                id: statusContainer
                height: wrap.height
                width: 200
                Text{
                    id: status
                    anchors.centerIn: parent
                    text: model.connectionStatus
                    color: "white"
                }
            }
        }
    }
}
