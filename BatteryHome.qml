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

    property string info: ""
    property string adcval: ""
    property int recordcnt: 0
    signal exit()



    AppManager{
        id: appManager

        onAdcReceived: {
//            voltage.text = "Voltage:"+val;
            adcval = val
        }

    }

    Timer{
        id: adctimer
        interval: 2*60*1000  //2min
        repeat: true
        running: false
        onTriggered: {
            appManager.getadc(0)
            info = "recording in every 2 min... "+recordcnt+": "+adcval
            recordcnt++
        }
    }

    Keys.onPressed: {
        if(event.key === Utils.KEY_CONFIRM){
            console.log("enter")
        }
        else if(event.key === Utils.KEY_1){
            console.log("1")
            info = "start recording in every 2 min... "

            // write file header "-----------------start-----------------"
            appManager.writeHeader("/opt/battery.txt")
            adctimer.restart()
            recordcnt = 0
        }
        else if(event.key === Utils.KEY_2){
            console.log("2")
            adctimer.stop()
            appManager.writeFooter("/opt/battery.txt")
            status.text = "stopped"
        }
        else if(event.key === Utils.KEY_3){
            console.log("3")
            var usbnode = appManager.getUsbDiskNode()
            if(usbnode === "no usb"){
                status.text = "no usb"
                return
            }
            appManager.downloadFileToUsbDisk(usbnode, "/opt/battery.txt")
            status.text = "download battery.txt at usb disk root directory"
        }
        else if(event.key === Utils.KEY_BACK){   //KEY BACK, back to system settings
            exit()
        }
    }//end Keys.onPressed



    Column{
        topPadding: 8
        spacing: 30
        width: 300
        anchors.horizontalCenter: parent.horizontalCenter

        Text {
            text: qsTr("Battery Manage")
        }

        Button{
            id: startbtn
            text: "1. Start record"
            width: 300
        }

        Button{
            id: stopbtn
            text: "2. Stop record"
            width: 300
        }

        Button{
            id: downloadbtn
            text: "3. Download record"
            width: 300
        }

        Text {
            id: status
            anchors.horizontalCenter: parent.horizontalCenter
            text: root.info
        }
    }// end Column



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

