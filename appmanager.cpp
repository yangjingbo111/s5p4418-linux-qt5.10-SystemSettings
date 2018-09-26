#include "appmanager.h"
#include <QProcess>
#include <QApplication>
#include <QDebug>
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
    QString appname("/usr/sbin/wpa_cli");
    QStringList arg1, arg2;
    arg1 << "scan";
    QProcess wpa_cli;
    wpa_cli.start(appname, arg1, QIODevice::ReadWrite);
    wpa_cli.waitForStarted();
    wpa_cli.waitForReadyRead();

    QString res = wpa_cli.readAll();
    QStringList list = res.split("\n");
    wpa_cli.waitForFinished();

    foreach (QString e, list) {
        qDebug()<<e;
    }
    arg2 << "scan_results";
    wpa_cli.start(appname, arg2, QIODevice::ReadWrite);
    wpa_cli.waitForStarted();
    wpa_cli.waitForReadyRead();
    res = wpa_cli.readAll();
    list = res.split("\n");

    struct WifiEntry wifinode;

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
//    emit searchResultChanged(res);
    wpa_cli.waitForFinished();
}

void AppManager::appStarted()
{

}

void AppManager::appGotError()
{

}
