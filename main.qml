import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.1
import AppManager 1.0

import "./js/Utils.js" as Utils

Window {
    id: home
    visible: true
    width: 640
    height: 480
    color: "green"
    title: qsTr("SystemSettings")

    property date currentTime: new Date()
    property string timeStr: Qt.formatDateTime(currentTime, "yyyy-MM-dd hh:mm:ss")
    AppManager{
        id: appManager
    }

    Timer{
        interval: 500
        repeat: true
        running: true

        onTriggered: {
            currentTime = new Date()
            timeStr = Qt.formatDateTime(currentTime, "yyyy-MM-dd hh:mm:ss")
        }
    }



    Column{
        id: settingslist
        spacing: 0
        width: parent.width
        focus: true

        Keys.onPressed: {
            if(event.key === Utils.KEY_1){   //KEY 1, SELECT Data and Time

            }
            else if(event.key === Utils.KEY_2){   //KEY DOWN, SELECT THE DOWNSIDE ITEM
                wifihome.visible = true
                wifihome.forceActiveFocus()
            }
        } //end Keys.onPressed
        Keys.onReleased: {

        }// end Keys.onReleased

        Rectangle{
            width: parent.width
            height: 60
            color: "gray"
            Text {
                id: time
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
                text: timeStr
            }

            Button{
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                text: "exit"

                onClicked: {
                    appManager.startApp("/opt/Launcher/bin/Launcher")
                }
            }
        }
        Rectangle{
            width: parent.width
            height: 400
            color: "lightblue"

            ColumnLayout {
                spacing: 30
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    text: "1. Data and Time"
                    Layout.fillWidth: true
                    onClicked: {

                    }
                }
                Button {
                    id: button
                    text: "2. Wifi Manage"
//                    highlighted: true
                    Layout.fillWidth: true
                    onClicked: {

                    }
                }
                Button {
                    text: "3. Connect Wifi"
                    highlighted: true
                    Layout.fillWidth: true
                    onClicked: {
                        console.log("connect wifi")
//                        appManager.startApp("/bin/sh", 1)

                    }
                }

            }
        }
        Rectangle{
            width: parent.width
            height: 20
            color: "Purple"
        }
    }

    Text {
        id: name
        anchors.centerIn: parent
        text: qsTr("System Settings App")
    }


    // wifi sub page
    WifiHome {
        id: wifihome
        width: parent.width
        height: parent.height

        visible: false

        onExit: {
            wifihome.visible = false
            settingslist.forceActiveFocus()
        }
    }
    // end of wifi sub page
}
