#ifndef APPMANAGER_H
#define APPMANAGER_H

#include <QObject>


class AppManager : public QObject
{
    Q_OBJECT
public:
    explicit AppManager(QObject *parent = nullptr);
    ~AppManager();

    Q_INVOKABLE void startApp(QString appname);
    Q_INVOKABLE void startApp(QString appname, bool running);
    Q_INVOKABLE void startSearchWifi();
    Q_INVOKABLE void connectToWifi(QString ssid);
    Q_INVOKABLE void connectToWifi(QString ssid, QString psk);
    Q_INVOKABLE void getip();

    QList<QMap<QString, int>> listNetworks();
    QMap<QString, int> listNetworks_();
    QMap<QString, QString> getCurrentNetworkStatus();
    int getNetworkId(QString ssid);
    void selectNetwork(int networkid);
    void enableNetwork(int networkid);
    Q_INVOKABLE int  addNetwork();
    Q_INVOKABLE void  testQString(QString ssid, QString psk, int networkid);
    Q_INVOKABLE void setNetwork(QString ssid, QString psk, int networkid);

    void dhcp();
//    void getIp();

signals:
    void searchResultChanged(QString res);
    void ipChanged(QString ip);
    void connectionStatusChanged(); //1 connected; 0 unconnected

public slots:
    void appStarted();
    void appGotError();


private:
    QPROCESSORDETECTION_H
};

#endif // APPMANAGER_H
