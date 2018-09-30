#include "appmanager.h"
#include <QProcess>
#include <QApplication>
#include <QDebug>

#define WPA_CLI         "/usr/sbin/wpa_cli"
#define UDHCPC          "/sbin/udhcpc"
#define IFCONFIG        "/sbin/ifconfig"

AppManager::AppManager(QObject *parent) : QObject(parent)
{
//    connect()
}

AppManager::~AppManager()
{

}

void AppManager::startApp(QString appname)
{
//    QString program = "/path/to/Qt/examples/widgets/analogclock";
    QStringList arguments;
//    arguments << "-style" << "fusion";

//    QProcess myProcess;
//    myProcess.start(appname, arguments, QIODevice::ReadWrite);
    QProcess::startDetached(appname);
    qApp->quit();
}

void AppManager::startApp(QString appname, bool running)
{
    QStringList arguments;
//    arguments << "HUAWEIP20Pro" << "yangjingbo";
    arguments << "/opt/connect-wifi.sh";
    qDebug()<<"startApp is called: "+appname;
//    QProcess myProcess;
//    myProcess.start(appname, arguments, QIODevice::ReadWrite);
//    int res = QProcess::execute(appname);
    int res = QProcess::execute(appname,arguments);
    qDebug()<<"startApp is called: "+ QString(res);

}

void AppManager::startSearchWifi()
{
    QString appname(WPA_CLI);
    QList<QByteArray> commands = {"scan", "scan_results", "quit"};
    QListIterator<QByteArray> itr (commands);

    QStringList arg0, arg1, arg2;
    QProcess wpa_cli;
    wpa_cli.setProgram(appname);
    wpa_cli.setArguments(arg0);

    QObject::connect(&wpa_cli, &QProcess::readyReadStandardError, [&wpa_cli](){
       qDebug()<<wpa_cli.readAllStandardError();
    });
    QObject::connect(&wpa_cli, &QProcess::readyReadStandardOutput, [&wpa_cli, &itr, this](){
        QString result = wpa_cli.readAll();
        QStringList list = result.split("\n");
        foreach (QString e, list) {

            if(e.contains("[")){
    //            qDebug()<<e;
    //            QStringList l = e.split("\t");
    //            foreach (QString i, l) {
    //                qDebug()<<i;
    //            }
                emit searchResultChanged(e);
            }

        }

        qDebug().noquote()<<"Results:\n"<<result;
        if(itr.hasNext()){
            const QByteArray & command = itr.next();
            wpa_cli.write(command+"\n");
            qDebug()<< "command: " << command;
        }

    });


    wpa_cli.start();

    wpa_cli.waitForFinished();

    // test

//    listNetworks();
//    listNetworks_();
//    qDebug().noquote()<< getNetworkId("GULF-PC")<<getNetworkId("HUAWEIP20Pro");
//    getCurrentNetworkStatus();



}

void AppManager::connectToWifi(QString ssid)
{
    int networkid = getNetworkId(ssid);
    qDebug().noquote()<<networkid;
    selectNetwork(networkid);

    enableNetwork(networkid);

    dhcp();
}

void AppManager::connectToWifi(QString ssid, QString psk)
{

}

void AppManager::getip()
{
    QProcess ifconfig;
    QStringList arg;
    arg << "wlan0";
    ifconfig.setProgram(IFCONFIG);
    ifconfig.setArguments(arg);

    QObject::connect(&ifconfig, &QProcess::readyReadStandardError, [&ifconfig](){
       qDebug()<<ifconfig.readAllStandardError();
    });
    QObject::connect(&ifconfig, &QProcess::readyReadStandardOutput, [&ifconfig, this](){
        QString result = ifconfig.readAll();
        QStringList list = result.split("\n");
        foreach (QString e, list) {
            if(e.contains("inet addr:")){
                QString ip = e.split("Bcast").at(0).split(":").at(1).trimmed();

                emit ipChanged(ip);
            }

        }

    });

    ifconfig.start();
    ifconfig.waitForFinished();
}

QList<QMap<QString, int>> AppManager::listNetworks()
{
    QList<QMap<QString, int> > networkList;
    QProcess wpa_cli;
    QStringList arg;
    arg << "list_networks";
    wpa_cli.setProgram(WPA_CLI);
    wpa_cli.setArguments(arg);
    wpa_cli.start();
    wpa_cli.waitForStarted();
    wpa_cli.waitForReadyRead();
    QString res = wpa_cli.readAll();
    QStringList list = res.split("\n");
    wpa_cli.waitForFinished();

    foreach (QString e, list) {
//        qDebug().noquote()<<e;
        /*
        network id / ssid / bssid / flags
         0	GULF-PC	any	[CURRENT]
        */

        if(e.contains("[")){
            QMap<QString, int> m;
            m[e.split("\t").at(1)] = e.split("\t").at(0).toInt();
            networkList.append(m);

        }
    }

    for (int i =0; i < networkList.size();i++) {
        qDebug().noquote()<<networkList.at(i).firstKey()<<networkList.at(i).first();
    }

    return networkList;
}

QMap<QString, int> AppManager::listNetworks_()
{
    QMap<QString, int> networkMap;
    QProcess wpa_cli;
    QStringList arg;
    arg << "list_networks";
    wpa_cli.setProgram(WPA_CLI);
    wpa_cli.setArguments(arg);
    wpa_cli.start();
    wpa_cli.waitForStarted();
    wpa_cli.waitForReadyRead();
    QString res = wpa_cli.readAll();
    QStringList list = res.split("\n");
    wpa_cli.waitForFinished();

    foreach (QString e, list) {
//        qDebug().noquote()<<e;
        /*
        network id / ssid / bssid / flags
         0	GULF-PC	any	[CURRENT]
        */

        if(e.contains("[")){
            networkMap[e.split("\t").at(1)] = e.split("\t").at(0).toInt();
        }
    }

    QMapIterator<QString, int> i(networkMap);
    while (i.hasNext()) {
        i.next();
        qDebug().noquote() << i.key() << ": " << i.value();
    }



    return networkMap;
}

QMap<QString, QString> AppManager::getCurrentNetworkStatus()
{
    QMap<QString, QString> status;
    QProcess wpa_cli;
    QStringList arg;
    arg << "status";
    wpa_cli.setProgram(WPA_CLI);
    wpa_cli.setArguments(arg);
    wpa_cli.start();
    wpa_cli.waitForStarted();
    wpa_cli.waitForReadyRead();
    QString res = wpa_cli.readAll();
    QStringList list = res.split("\n");
    wpa_cli.waitForFinished();

    foreach (QString e, list) {
//        qDebug().noquote()<<e;
        /*
Selected interface 'wlan0'
bssid=08:10:79:18:00:42
freq=0
ssid=GULF-PC
id=0
mode=station
pairwise_cipher=CCMP
group_cipher=CCMP
key_mgmt=WPA2-PSK
wpa_state=COMPLETED
ip_address=192.168.137.81
address=cc:b8:a8:27:1c:66
uuid=05a45e4b-419e-50ac-b042-1cfafc3a1786
        */

        if(e.contains("=")){
            status[e.split("=").at(0)] = e.split("=").at(1);
        }
    }

    QMapIterator<QString, QString> i(status);

    // traverse
//    while (i.hasNext()) {
//        i.next();
//        qDebug().noquote() << i.key() << ": " << i.value();
//    }

    return status;
}

int AppManager::getNetworkId(QString ssid)
{
    QMap<QString, int> networks = listNetworks_();
    int value = networks.value(ssid, -1);
    return value;
}

void AppManager::selectNetwork(int networkid)
{
    QMap<QString, QString> status;
    QProcess wpa_cli;
    QStringList arg;
    arg << "select_network"<<QString::number(networkid);
    wpa_cli.setProgram(WPA_CLI);
    wpa_cli.setArguments(arg);
    wpa_cli.start();
    wpa_cli.waitForStarted();
    wpa_cli.waitForReadyRead();
    QString res = wpa_cli.readAll();
    QStringList list = res.split("\n");
    wpa_cli.waitForFinished();

    foreach (QString e, list) {
        qDebug().noquote()<<e;
        /*
        network id / ssid / bssid / flags
         0	GULF-PC	any	[CURRENT]
        */
    }


}

void AppManager::enableNetwork(int networkid)
{
    QMap<QString, QString> status;
    QProcess wpa_cli;
    QStringList arg;
    arg << "enable_network"<<QString::number(networkid);
    wpa_cli.setProgram(WPA_CLI);
    wpa_cli.setArguments(arg);
    wpa_cli.start();
    wpa_cli.waitForStarted();
    wpa_cli.waitForReadyRead();
    QString res = wpa_cli.readAll();
    QStringList list = res.split("\n");
    wpa_cli.waitForFinished();

    foreach (QString e, list) {
        qDebug().noquote()<<e;
        /*
        network id / ssid / bssid / flags
         0	GULF-PC	any	[CURRENT]
        */
    }
}

/**
 * @brief AppManager::dhcp
 * @details use udhcpc -iwlan0 to get dynamic ip address
 */
void AppManager::dhcp()
{
    QProcess udhcpc;
    QStringList arg;
    arg << "-iwlan0";
    udhcpc.setProgram(UDHCPC);
    udhcpc.setArguments(arg);
    udhcpc.start();
    udhcpc.waitForStarted();
    udhcpc.waitForReadyRead();
    QString res = udhcpc.readAll();
    QStringList list = res.split("\n");

    udhcpc.waitForFinished();

    foreach (QString e, list) {
        qDebug().noquote()<<e;
        /*
        network id / ssid / bssid / flags
         0	GULF-PC	any	[CURRENT]
        */
    }
}

//void AppManager::getIp()
//{

//}

// worked version
//void AppManager::startSearchWifi()
//{
//    QString appname("/usr/sbin/wpa_cli");
//    QStringList arg1, arg2;
//    arg1 << "scan";
//    QProcess wpa_cli;
//    wpa_cli.start(appname, arg1, QIODevice::ReadWrite);
//    wpa_cli.waitForStarted();
//    wpa_cli.waitForReadyRead();

//    QString res = wpa_cli.readAll();
//    QStringList list = res.split("\n");
//    wpa_cli.waitForFinished();

//    foreach (QString e, list) {
//        qDebug()<<e;
//    }
//    arg2 << "scan_results";
//    wpa_cli.start(appname, arg2, QIODevice::ReadWrite);
//    wpa_cli.waitForStarted();
//    wpa_cli.waitForReadyRead();
//    res = wpa_cli.readAll();
//    list = res.split("\n");

//    struct WifiEntry wifinode;

//    foreach (QString e, list) {

//        if(e.contains("[")){
////            qDebug()<<e;
////            QStringList l = e.split("\t");
////            foreach (QString i, l) {
////                qDebug()<<i;
////            }
//            emit searchResultChanged(e);
//        }

//    }
////    emit searchResultChanged(res);
//    wpa_cli.waitForFinished();
//}

void AppManager::appStarted()
{

}

void AppManager::appGotError()
{

}
