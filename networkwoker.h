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
    void disconnectWifi();
    void dhcp();
    void getip();

signals:
    void ipChanged(QString ip);

public slots:
    void connectToWifi(QString ssid, QString psk);
};

#endif // NETWORKWOKER_H
