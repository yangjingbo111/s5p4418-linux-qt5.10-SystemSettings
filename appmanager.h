#ifndef APPMANAGER_H
#define APPMANAGER_H

#include <QObject>
#include <QFile>
#include "networkwoker.h"
#include "lightnessworker.h"
#include <QThread>

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
    Q_INVOKABLE void getadc(int ch);
    Q_INVOKABLE void writeHeader(QString filename);
    Q_INVOKABLE void writeFooter(QString filename);
    Q_INVOKABLE void downloadFileToUsbDisk(QString usbnode, QString srcfilename);
    Q_INVOKABLE bool checkUsbDisk();
    Q_INVOKABLE QString getUsbDiskNode();

    QList<QMap<QString, int>> listNetworks();
    QMap<QString, int> listNetworks_();
    QMap<QString, QString> getCurrentNetworkStatus();
    int getNetworkId(QString ssid);
    void selectNetwork(int networkid);
    void enableNetwork(int networkid);
    Q_INVOKABLE int  addNetwork();
    Q_INVOKABLE void testQString(QString ssid, QString psk, int networkid);
    Q_INVOKABLE void setNetwork(QString ssid, QString psk, int networkid);
    Q_INVOKABLE void setLightness(int light);
    Q_INVOKABLE int getLightness();
    void dhcp();

    void saveAdcToFile(QString filename, QString val);
//    void getIp();

signals:
    void searchResultChanged(QString res);

    void connectionStatusChanged(); //1 connected; 0 unconnected
    void adcReceived(QString val);
    void setLightnessSignal(int light);

public slots:
    void appStarted();
    void appGotError();


private:
    QPROCESSORDETECTION_H

    QThread *m_thread;
    NetworkWoker *m_networkWorker;
    LightnessWorker *m_lightnessWorker;
};

#endif // APPMANAGER_H
