import QtQuick 2.0
import QtQuick.Controls 2.1

import AppManager 1.0
import "./js/Utils.js" as Utils
Rectangle {
    id: root
    width: parent.width
    height: parent.height
    color: "lightblue"


    signal exit()

    AppManager{
        id: appManager

        onSearchResultChanged: {
//            console.log(res)
//            wifi.append(res)
            var l = res.split("\t")
            model_contact.append(
                 {
                "ssid": l[4],
                "level": l[2]
            }
            )
        }
    }

    Keys.onPressed: {
        if(event.key === Utils.KEY_1){   //KEY 1, SELECT Data and Time

        }
        else if(event.key === Utils.KEY_BACK){   //KEY DOWN, SELECT THE DOWNSIDE ITEM
            exit()
        }
        else if(event.key === Utils.KEY_MINUS){   //KEY DOWN, SELECT THE DOWNSIDE ITEM
            search.clicked()
        }
    } //end Keys.onPressed
    Keys.onReleased: {

    }// end Keys.onReleased


    ListModel {
        id: model_contact

    }



    Rectangle{
        id: head
        width: parent.width
        height: 60
        color: "white"

        Text {
            text: qsTr("Wifi")
            font.pixelSize: 24
            anchors.centerIn: parent
        }

        Button{
            id: search
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Search")

            onClicked: {
                model_contact.clear()
                appManager.startSearchWifi()
//                console.log("clicked fired")
            }
        }

    }

    ListView {
        id: wifilist
        anchors.top: head.bottom
        width: parent.width
        height: parent.height - head.height

        model: model_contact
        delegate: Text {

            text: ssid + ": " + level
        }
    }

}

