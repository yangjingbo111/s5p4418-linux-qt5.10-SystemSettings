#ifndef NETWORKWOKER_H
#define NETWORKWOKER_H

#include <QObject>

class NetworkWoker : public QObject
{
    Q_OBJECT
public:
    explicit NetworkWoker(QObject *parent = nullptr);
    int  addNetwork();
    void setNetwork(QString ssid, QString psk, int networkid);
    void selectNetwork(int networkid);
    void enableNetwork(int networkid);
    int  getPid(QString process);
    void dhcp();
    void getip();
    void killProcess(int pid);

signals:
    void ipChanged(QString ip);

public slots:
    void connectToWifi(QString ssid, QString psk);
    void disconnectWifi();
};

#endif // NETWORKWOKER_H
