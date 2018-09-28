import QtQuick 2.7
import QtQuick.Controls 2.2


import AppManager 1.0
import "./js/Utils.js" as Utils
Rectangle {
    id: root
    width: parent.width
    height: parent.height
    color: "lightblue"
    property alias searchWifi: search

    signal exit()

    AppManager{
        id: appManager

        onSearchResultChanged: {
            var l = res.split("\t")
            model_contact.append(
                 {
                "ssid": l[4],
                "level": l[2],
                "connectionStatus": "unconnected"

            }
            )
        }
    }

    Rectangle{
        id: pwdDialog
        visible: false
        z: 11
        width: parent.width / 2
        height: parent.height / 2
        anchors.centerIn: parent

        color: "white"
        Column{
            spacing: 8
            topPadding: 16
            Item{
                width: pwdDialog.width
                height: 48

                Text {
                    id: ssidLabel
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("SSID")
                }
            }
            Item{
                width: pwdDialog.width * 3 / 4
                anchors.horizontalCenter: parent.horizontalCenter
                height: 48

                TextField{
                    anchors.centerIn: parent
                    placeholderText: "Enter password"
                }
            }
            Item{
                width: parent.width
                height: 60

                Row{
                    anchors.centerIn: parent
                    spacing: 16
                    leftPadding: 16
                    rightPadding: 16
                    Button{
                        text: "Connect"
                    }
                    Button{
                        text: "Cancel"
                    }
                }
            }




        }
    }

    Keys.onPressed: {
        if(pwdDialog.focus){
            console.log(event.key)
            if(event.key === Utils.KEY_CONFIRM){   //KEY 1, SELECT Data and Time

            }
            else if(event.key === Utils.KEY_BACK){   //KEY BACK, back to system settings
                pwdDialog.visible = false
                wifilist.forceActiveFocus()
            }
            else if(event.key === Utils.KEY_MINUS){   //KEY MINUS, SEARCH WIFI!!!

            }
            else if(event.key === Utils.KEY_UP){   //KEY DOWN, SELECT THE DOWNSIDE ITEM


            }
            else if(event.key === Utils.KEY_DOWN){   //KEY DOWN, SELECT THE DOWNSIDE ITEM


            }
        }
        else{
            if(event.key === Utils.KEY_CONFIRM){   //KEY 1, SELECT Data and Time
                ssidLabel.text = wifilist.model.get(wifilist.currentIndex).ssid
    //            console.log(wifilist.model.get(wifilist.currentIndex).ssid)
                pwdDialog.visible = true
                wifilist.focus = false
                pwdDialog.forceActiveFocus()
            }
            else if(event.key === Utils.KEY_BACK){   //KEY BACK, back to system settings
                exit()
            }
            else if(event.key === Utils.KEY_MINUS){   //KEY MINUS, SEARCH WIFI!!!
                search.clicked()
            }
            else if(event.key === Utils.KEY_UP){   //KEY DOWN, SELECT THE DOWNSIDE ITEM

                wifilist.decrementCurrentIndex()

            }
            else if(event.key === Utils.KEY_DOWN){   //KEY DOWN, SELECT THE DOWNSIDE ITEM

                wifilist.incrementCurrentIndex()

            }
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
        color: "black"
        z: 10   // higher than listview is ok[not be covered by listview when moved]

        Text {
            text: qsTr("Wifi")
            font.pixelSize: 24
            anchors.centerIn: parent
            color: "white"
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
        spacing: 2



        header: Component{
            Rectangle{
                id: headerRect
                z: 9
                width: wifilist.width
                height: 50
                color: "#4EA4D0"
                visible: true
                Row{
                    spacing: 16
                    Item{
                        id: ssidHeader
                        height: headerRect.height
                        width: 380
                        Text{
                            id: ssid
                            anchors.centerIn: parent
                            text: "SSID"
//                            color: "white"
                        }
                    }
                    Item{
                        id: levelHeader
                        height: headerRect.height
                        width: 40
                        Text{
                            id: level
                            anchors.centerIn: parent
                            text: "Level"
//                            color: "white"
                        }
                    }
                    Item{
                        id: statusHeader
                        height: headerRect.height
                        width: 200
                        Text{
                            id: status
                            anchors.centerIn: parent
                            text: "Status"
//                            color: "white"
                        }
                    }
                }
            }
        } // end header
        headerPositioning: ListView.OverlayHeader

        model: model_contact
        delegate: WifiDelegate {
            id: wifiDelegate
        }

        highlight: Component{
            id: highlight
            Rectangle{
                z: 2
                color: "white"
                opacity: 0.2
                y: wifilist.currentItem.y
            }
        }
        focus: true
        highlightFollowsCurrentItem: true
        ScrollBar.vertical: ScrollBar{}
    }

}

