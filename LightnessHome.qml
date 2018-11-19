import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

import AppManager 1.0
import NetworkManager 1.0
import "./js/Utils.js" as Utils

Rectangle {
    id: root
    width: parent.width
    height: parent.height
    color: "lightblue"

//    property int lightness: 25

    signal exit()

    AppManager{
        id: appManager


    }//end AppManager



    Keys.onPressed: {
        if(event.key === Utils.KEY_BACK){   //KEY BACK, back to system settings
            exit()
        }
    } //end Keys.onPressed
    Keys.onReleased: {

    }// end Keys.onReleased

    // qml content
    Column{
        padding: 8
        spacing: 100
        topPadding: 16
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width - 16
        height: parent.height
        // 屏幕亮度调节
        Item{
            width: parent.width
            height: 48

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 28
                text: qsTr("屏幕亮度")
            }

        }//end 屏幕亮度调节

        // 滑动条
        Item{
            width: parent.width
            height: 48

            Slider{
                id: light_slider
                width: parent.width / 2
                anchors.horizontalCenter: parent.horizontalCenter
                from: 25
                value: 25   // set "value" equals "from", valueChanged will not triggered
                to: 255
                onValueChanged: {
//                    lightness = Math.round(value)
                    appManager.setLightness(Math.round(value))
//                    console.log("------------", lightness)
                }
            }
            Component.onCompleted: {
                light_slider.value = appManager.getLightness()
                console.log('---------- init slider', light_slider.value)
            }

        }//end 滑动条

    }//end Column



}

