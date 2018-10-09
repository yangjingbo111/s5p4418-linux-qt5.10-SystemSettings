#include "networkwoker.h"
#include <QProcess>
#include "micros.h"

NetworkWoker::NetworkWoker(QObject *parent) : QObject(parent)
{

}

/**
 * @brief NetworkWoker::addNetwork
 * @return networkid
 */
int NetworkWoker::addNetwork()
{
    QProcess wpa_cli;
    QStringList arg;
    arg << "add_network";
    wpa_cli.setProgram(WPA_CLI);
    wpa_cli.setArguments(arg);
    wpa_cli.start();
    wpa_cli.waitForStarted();
    wpa_cli.waitForReadyRead();
    QString res = wpa_cli.readAll();
    QStringList list = res.split("\n");
    wpa_cli.waitForFinished();

//    qDebug().noquote()<<"add network id:"<<list.at(1);
    return list.at(1).toInt();
}

void NetworkWoker::setNetwork(QString ssid, QString psk, int networkid)
{
    QString appname(WPA_CLI);
    QList<QString> commands = {QString("set_network %1 ssid \"%2\"\n").arg(QString::number(networkid), QString(ssid)),
                              QString("set_network %1 psk \"%2\"\n").arg(QString::number(networkid), QString(psk)),
                              QString("quit\n")};
    QListIterator<QString> itr (commands);

    QStringList arg0;
    QProcess wpa_cli;
    wpa_cli.setProgram(appname);
    wpa_cli.setArguments(arg0); // interactive mode, start wpa_cli with none argument

    QObject::connect(&wpa_cli, &QProcess::readyReadStandardError, [&wpa_cli](){
       qDebug()<<wpa_cli.readAllStandardError();
    });
    QObject::connect(&wpa_cli, &QProcess::readyReadStandardOutput, [&wpa_cli, &itr, this](){
        QString result = wpa_cli.readAll();
        QStringList list = result.split("\n");


        qDebug().noquote()<<"Results:\n"<<result;
        if(itr.hasNext()){
            const QString & command = itr.next();

            wpa_cli.write(command.toLocal8Bit());
            qDebug()<< "command: " << command;
        }

    });


    wpa_cli.start();

    wpa_cli.waitForFinished();
}

void NetworkWoker::selectNetwork(int networkid)
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

void NetworkWoker::enableNetwork(int networkid)
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

void NetworkWoker::dhcp()
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

void NetworkWoker::getip()
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

void NetworkWoker::connectToWifi(QString ssid, QString psk)
{
    int networkid = addNetwork();
    setNetwork(ssid, psk, networkid);
    selectNetwork(networkid);
    enableNetwork(networkid);
    dhcp();
    getip();
}
