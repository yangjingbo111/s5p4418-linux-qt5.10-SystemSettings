#include "networkmanager.h"
#include <QSettings>
#include "micros.h"

NetworkManager::NetworkManager(QObject *parent) : QObject(parent)
{
    m_thread = new QThread;
    m_networkWorker = new NetworkWoker;
    m_networkWorker->moveToThread(m_thread);

    connect(this, SIGNAL(connectToWifiSignal(QString, QString)), m_networkWorker, SLOT(connectToWifi(QString, QString)), Qt::QueuedConnection);
    connect(this, SIGNAL(disconnectWifiSignal()), m_networkWorker, SLOT(disconnectWifi()), Qt::QueuedConnection);

    connect(m_networkWorker, SIGNAL(ipChanged(QString)), this, SIGNAL(ipChanged(QString)), Qt::QueuedConnection);

    m_thread->start();

}

bool NetworkManager::saveWifi(QString ssid, QString psk)
{
    QSettings wifi;
    wifi.setValue(ssid, psk);
    qDebug().noquote()<<wifi.value(ssid);

    return true;
}

bool NetworkManager::removeWifi(QString ssid)
{
    QSettings wifi;
    wifi.remove(ssid);
//    qDebug().noquote()<<wifi.value(ssid);


    return true;
}

void NetworkManager::updateWifiList()
{
    QSettings wifi;
    QStringList wifilist = wifi.allKeys();
    qDebug().noquote()<<"wifi:";
    foreach (QString e, wifilist) {
//        qDebug().noquote()<<e<<wifi.value(e).toString();
        emit wifiListUpdate(e);
    }
}

void NetworkManager::connectToWifi(QString ssid, QString psk)
{
    emit connectToWifiSignal(ssid, psk);
}

void NetworkManager::connectToWifi(QString ssid)
{
    QSettings wifi;
    QVariant psk = wifi.value(ssid, QVariant(QString("wrong psk")));
    qDebug().noquote()<<ssid<<psk.toString();
    emit connectToWifiSignal(ssid, psk.toString());
}

void NetworkManager::disconnectWifi()
{
    emit disconnectWifiSignal();
}
