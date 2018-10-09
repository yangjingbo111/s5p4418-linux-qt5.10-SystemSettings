import QtQuick 2.7
import QtQuick.Controls 2.2


import AppManager 1.0
import "./js/Utils.js" as Utils

import "./content"
import QtQuick.VirtualKeyboard 2.2
import QtQuick.VirtualKeyboard.Settings 2.2

Rectangle {
    id: root
    width: parent.width
    height: parent.height
    color: "lightblue"
    property alias searchWifi: search
    property string ipValue: ""
    property string connectionStatusValue: ""

    signal exit()

    AppManager{
        id: appManager

        onSearchResultChanged: {
            var l = res.split("\t")
            model_contact.append(
                 {
                "ssid": l[4],
                "level": l[2],
                "connectionStatus": ""

            }
            )
        } // end onSearchResultChanged

        onIpChanged: {
            console.log("ip addr: ", ip)
            root.ipValue = ip
        } // end onIpChanged

        onConnectionStatusChanged: {

        }
    }

    Rectangle{
        id: pwdDialog
        visible: false
        z: 11
        width: parent.width / 2
        height: parent.height / 2
        anchors.top: head.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        color: "white"

        signal exitPwdDialog()

        onExitPwdDialog: {
            root.focus = true
            pwdDialog.visible = false
            pwdInput.text = ""
        } // end exit

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
                    id: pwdInput
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
                    Rectangle{
                        id: confirmBtn
                        width: 120
                        height: 48
                        radius: 4
                        color: focus ? "gray":"lightgray"
                        Text {
                            anchors.centerIn: parent
                            text: qsTr("Connect")
                        }


                    }
                    Rectangle{
                        id: cancelBtn
                        width: 120
                        height: 48
                        radius: 4
                        color: focus ? "gray":"lightgray"
                        Text {
                            anchors.centerIn: parent
                            text: qsTr("Cancel")
                        }
                    }
                }
            }




        }
    }// end pwdDialog

    Keys.onPressed: {
        if(pwdDialog.focus){
            console.log(event.key)
            if(event.key === Utils.KEY_CONFIRM){   //KEY 1, SELECT Data and Time
                console.log("connecting wifi...", ssidLabel.text)
                appManager.connectToWifi(ssidLabel.text)
            }
            if(event.key === Utils.KEY_DOT){   //KEY 1, SELECT Data and Time
                console.log("connecting wifi...", ssidLabel.text)
                appManager.getip()
            }
            else if(event.key === Utils.KEY_BACK){   //KEY BACK, back to system settings
                pwdDialog.visible = false
                wifihome.forceActiveFocus()
            }
            else if(event.key === Utils.KEY_MINUS){   //KEY MINUS, SEARCH WIFI!!!

            }
            else if(event.key === Utils.KEY_UP){   //KEY DOWN, SELECT THE DOWNSIDE ITEM


            }
            else if(event.key === Utils.KEY_DOWN){   //KEY DOWN, SELECT THE DOWNSIDE ITEM


            }
        }
        else if(root.focus){
            if(event.key === Utils.KEY_CONFIRM){   //KEY 1, SELECT Data and Time
                ssidLabel.text = wifilist.model.get(wifilist.currentIndex).ssid
    //            console.log(wifilist.model.get(wifilist.currentIndex).ssid)
                pwdDialog.visible = true
                wifilist.focus = false
                pwdDialog.forceActiveFocus()
                pwdInput.focus = true
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
        }// end if(root.focus)
        else if(pwdInput.focus){
            if(event.key === Utils.KEY_UP){
                cancelBtn.focus = true
            }
            else if(event.key === Utils.KEY_DOWN){   //KEY DOWN, SELECT THE DOWNSIDE ITEM
                confirmBtn.focus = true
            }
            else if(event.key === Utils.KEY_BACK){   //KEY BACK, back to system settings
                pwdDialog.exitPwdDialog()
            }
        }// if(root.focus)
        else if(confirmBtn.focus){
            if(event.key === Utils.KEY_UP){
                pwdInput.focus = true
            }
            else if(event.key === Utils.KEY_DOWN){   //KEY DOWN, SELECT THE DOWNSIDE ITEM
                cancelBtn.focus = true
            }
            else if(event.key === Utils.KEY_BACK){   //KEY BACK, back to system settings
                pwdDialog.exitPwdDialog()
            }
            else if(event.key === Utils.KEY_CONFIRM){   //KEY DOWN, SELECT THE DOWNSIDE ITEM
                appManager.connectToWifi(ssidLabel.text, pwdInput.text)
            }
        }// if(confirmBtn.focus)
        else if(cancelBtn.focus){
            if(event.key === Utils.KEY_UP){
                confirmBtn.focus = true
            }
            else if(event.key === Utils.KEY_DOWN){   //KEY DOWN, SELECT THE DOWNSIDE ITEM
                pwdInput.focus = true
            }
            else if(event.key === Utils.KEY_BACK){   //KEY BACK, back to system settings
                pwdDialog.exitPwdDialog()
            }
        }// if(cancelBtn.focus)

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
            id: ipaddr
            text: root.ipValue
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
    }// end ListView

    InputPanel {
        id: inputPanel
        z: 89
        y: root.height
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
                y: root.height - inputPanel.height
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

