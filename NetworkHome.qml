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
    property string ipValue: ""
    property string connectionStatusValue: ""

    signal exit()

    AppManager{
        id: appManager

        onConnectionStatusChanged: {

        }
    }//end AppManager

    NetworkManager{
        id: networkManager

        onWifiListUpdate: {
            console.log("new wifi found",ssid)
            wifimodel.append({text: ssid})
        }
        onIpChanged: {
            console.log("ip addr: ", ip)
            connectionStatus.text = "已连接"
            ipvalue.text = ip
        } // end onIpChanged

    }//end NetworkManager


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
        spacing: 8
        topPadding: 8
        width: parent.width - 16
        height: parent.height
        // 网卡节点
        Item{
            width: parent.width
            height: 48

            Text {
                anchors.leftMargin: 8
                font.pixelSize: 28
                text: qsTr("网卡节点：")
            }
            ComboBox {
                anchors.rightMargin: 8
                width: 200
                anchors.right: parent.right
                model: [ "wlan0" ]
            }
        }//end 网卡节点
        //网络名称
        Item{
            width: parent.width
            height: 48

            Text {
                anchors.leftMargin: 8
                font.pixelSize: 28
                text: qsTr("网络名称：")
            }
            ComboBox {
                id: networkName
                anchors.rightMargin: 8
                width: 200
                anchors.right: parent.right
                model: ListModel{
                    id: wifimodel

//                    ListElement{text: "GULF-PC"}
                }
                currentIndex: 0

                Component.onCompleted: {
                    console.log("begin update wifi list")
                    networkManager.updateWifiList()
                }

                onCurrentTextChanged: {

                }
            }
        }//end 网络名称
        Item{
            width: parent.width
            height: 360
            TabBar {
                id: bar
                width: parent.width / 3
                TabButton {
                    width: parent/2
                    text: qsTr("信息")

                }
                TabButton {
                    width: parent/2
                    text: qsTr("管理")
                }

            }

            StackLayout {
                width: parent.width
                anchors.top: bar.bottom
                currentIndex: bar.currentIndex
                Rectangle {
                    id: infoTab
                    width: parent.width
                    height: 300
                    color: "white"
                    Column{
                        width: parent.width
                        topPadding: 32
                        spacing: 8
                        Item{
                            width: parent.width
                            height: 48

                            Text {
                                anchors.leftMargin: 8
                                font.pixelSize: 28
                                text: qsTr("状态：")
                            }
                            Text {
                                id: connectionStatus
                                anchors.rightMargin: 8
                                width: 400
                                anchors.right: parent.right
                                text: qsTr("未连接")
                            }
                        }

                        Item{
                            width: parent.width
                            height: 48

                            Text {
                                anchors.leftMargin: 8
                                font.pixelSize: 28
                                text: qsTr("网络名：")
                            }
                            Text {
                                anchors.rightMargin: 8
                                width: 400
                                anchors.right: parent.right
                                text: networkName.currentText
                            }
                        }

                        Item{
                            width: parent.width
                            height: 48

                            Text {
                                anchors.leftMargin: 8
                                font.pixelSize: 28
                                text: qsTr("IP地址：")
                            }
                            Text {
                                id: ipvalue
                                anchors.rightMargin: 8
                                width: 400
                                anchors.right: parent.right
                                text: qsTr("")
                            }
                        }

                        Item{
                            width: parent.width
                            height: 60
                            Row{
                                anchors.centerIn: parent
                                width: parent.width / 2
                                height: parent.height
                                spacing: 8
                                Button {
                                    id: connectbtn
                                    text: qsTr("连接")
                                    onClicked: {
                                        console.log("networkName", networkName.currentText)
                                        ipvalue.text = ""   //clear ip value
                                        connectionStatus.text = "正在连接..."
                                        networkManager.connectToWifi(networkName.currentText)
                                    }
                                }
                                Button {
                                    id: disconnectbtn
                                    text: qsTr("断开")
                                    onClicked: {
                                        connectionStatus.text = "未连接"
                                        ipvalue.text = ""   //clear ip value
                                        networkManager.disconnectWifi()

                                    }
                                }
                                Button {
                                    id: scanbtn
                                    text: qsTr("扫描")
                                    onClicked: {
                                        wifihome.visible = true
                                        wifihome.forceActiveFocus()
                                        wifihome.searchWifi.clicked()
                                    }
                                }
                            }


                        }
                    }// end Column
                }
                Rectangle {
                    id: manageTab

                    width: parent.width
                    height: 300
                    color: "white"
                    Column{
                        width: parent.width
                        topPadding: 32
                        spacing: 8
                        Item{
                            width: parent.width
                            height: 48

//                            Text {
//                                anchors.leftMargin: 8
//                                font.pixelSize: 28
//                                text: qsTr("状态：")
//                            }
//                            Text {
//                                id: connectionStatus
//                                anchors.rightMargin: 8
//                                width: 400
//                                anchors.right: parent.right
//                                text: qsTr("未连接")
//                            }
                        }

                        Item{
                            width: parent.width
                            height: 48

                            Text {
                                anchors.leftMargin: 8
                                font.pixelSize: 28
                                text: qsTr("网络名：")
                            }
                            Text {
                                anchors.rightMargin: 8
                                width: 400
                                anchors.right: parent.right
                                text: networkName.currentText
                            }
                        }

                        Item{
                            width: parent.width
                            height: 48

//                            Text {
//                                anchors.leftMargin: 8
//                                font.pixelSize: 28
//                                text: qsTr("IP地址：")
//                            }
//                            Text {
//                                id: ipvalue
//                                anchors.rightMargin: 8
//                                width: 400
//                                anchors.right: parent.right
//                                text: qsTr("")
//                            }
                        }

                        Item{
                            width: parent.width
                            height: 60
                            Row{
                                anchors.centerIn: parent
                                width: parent.width / 2
                                height: parent.height
                                spacing: 8
                                Button {
                                    // placeholder
                                    visible: false
                                }
                                Button {
                                    id: deleteBtn
                                    text: qsTr("删除")
                                    onClicked: {
                                        networkManager.removeWifi(networkName.currentText)
                                        wifimodel.clear()   // clear first!!!
                                        networkManager.updateWifiList()
                                    }
                                }

                            }


                        }
                    }// end Column
                }

            }
        }
    }//end Column

    // wifi sub page
    WifiHome {
        id: wifihome
        width: parent.width
        height: parent.height

        visible: false

        onExit: {
            wifihome.visible = false
            root.forceActiveFocus()

        }
        onUpdateWifiList: {
            wifimodel.clear()   // clear first!!!
            networkManager.updateWifiList()
        }
    }// end of wifi sub page


}

