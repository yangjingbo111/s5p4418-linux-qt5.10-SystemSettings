import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Layouts 1.0
import QtQuick.Controls 2.1
import AppManager 1.0

import "./js/Utils.js" as Utils
import "./content"
import QtQuick.VirtualKeyboard 2.2
import QtQuick.VirtualKeyboard.Settings 2.2

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
            else if(event.key === Utils.KEY_2){   //KEY 2, enter wifi manage subpage
                wifihome.visible = true
                wifihome.forceActiveFocus()
                wifihome.searchWifi.clicked()   // search wifi when wifi page is shown for the 1st time
            }
            else if(event.key === Utils.KEY_3){   //KEY DOWN, end battery manage subpage
                batteryhome.visible = true
                batteryhome.forceActiveFocus()
            }
            else if(event.key === Utils.KEY_BACK){
                appManager.startApp("/opt/Launcher/bin/Launcher")
            }
            // for test purpose
            else if(event.key === Utils.KEY_DOT){
//                appManager.addNetwork()
//                appManager.setNetwork("gulf", "12345678", appManager.addNetwork())
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

            Column {
                topPadding: 8
                spacing: 30
                anchors.horizontalCenter: parent.horizontalCenter

                Button {
                    text: "1. Data and Time"
                    width: 300
                    onClicked: {

                    }
                }
                Button {
                    id: button
                    text: "2. Wifi Manage"
//                    highlighted: true
                    width: 300
                    onClicked: {

                    }
                }

                Button {
                    id: batteryBtn
                    visible: false
                    text: "3. Battery Manage"
                    width: 300
                    onClicked: {

                    }
                }
//                TextField {
//                    width: parent.width
//                    placeholderText: "One line field"
//                    enterKeyAction: EnterKeyAction.Next
////                    onAccepted: passwordField.focus = true
//                }

            }


        }
        Rectangle{
            width: parent.width
            height: 20
            color: "Purple"
        }

        InputPanel {
            id: inputPanel
            z: 89
            y: home.height
            anchors.left: parent.left
            anchors.right: parent.right
            states: State {
                name: "visible"
                /*  The visibility of the InputPanel can be bound to the Qt.inputMethod.visible property,
                    but then the handwriting input panel and the keyboard input panel can be visible
                    at the same time. Here the visibility is bound to InputPanel.active property instead,
                    which allows the handwriting panel to control the visibility when necessary.
                */
                when: inputPanel.active
                PropertyChanges {
                    target: inputPanel
                    y: home.height - inputPanel.height
                }
            }
            transitions: Transition {
                id: inputPanelTransition
                from: ""
                to: "visible"
                reversible: true
                enabled: !VirtualKeyboardSettings.fullScreenMode
                ParallelAnimation {
                    NumberAnimation {
                        properties: "y"
                        duration: 250
                        easing.type: Easing.InOutQuad
                    }
                }
            }
            Binding {
                target: InputContext
                property: "animating"
                value: inputPanelTransition.running
            }

        }
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
    }// end of wifi sub page

    // Battery sub page
    BatteryHome {
        id: batteryhome
        width: parent.width
        height: parent.height

        visible: false

        onExit: {
            batteryhome.visible = false
            settingslist.forceActiveFocus()
        }
    }// end of Battery sub page
}
