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

    QList<QMap<QString, int>> listNetworks();
    QMap<QString, int> listNetworks_();
    QMap<QString, QString> getCurrentNetworkStatus();
    int getNetworkId(QString ssid);
    void selectNetwork(int networkid);
    void enableNetwork(int networkid);

signals:
    void searchResultChanged(QString res);

public slots:
    void appStarted();
    void appGotError();


private:
    QPROCESSORDETECTION_H
};

#endif // APPMANAGER_H
