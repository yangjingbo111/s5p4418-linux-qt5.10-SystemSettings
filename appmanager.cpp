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

void AppManager::appStarted()
{

}

void AppManager::appGotError()
{

}
