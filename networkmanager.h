#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <QObject>
#include "networkwoker.h"
#include <QThread>

class NetworkManager : public QObject
{
    Q_OBJECT
public:
    explicit NetworkManager(QObject *parent = nullptr);
    Q_INVOKABLE bool saveWifi(QString ssid, QString psk);
    Q_INVOKABLE void updateWifiList();
    Q_INVOKABLE void connectToWifi(QString ssid, QString psk);
    Q_INVOKABLE void connectToWifi(QString ssid);

signals:
    void ipChanged(QString ip);
    //signals passed to worker
    void connectToWifiSignal(QString ssid, QString psk);
    void wifiListUpdate(QString ssid);
public slots:

private:
    QThread *m_thread;
    NetworkWoker *m_networkWorker;
};

#endif // NETWORKMANAGER_H
