#ifndef APPMANAGER_H
#define APPMANAGER_H

#include <QObject>

typedef struct WifiEntry{
    QString ssid;
    int level;

}WifiEntry;

class AppManager : public QObject
{
    Q_OBJECT
public:
    explicit AppManager(QObject *parent = nullptr);
    ~AppManager();

    Q_INVOKABLE void startApp(QString appname);
    Q_INVOKABLE void startApp(QString appname, bool running);
    Q_INVOKABLE void startSearchWifi();

signals:
    void searchResultChanged(QString res);

public slots:
    void appStarted();
    void appGotError();

private:
    QPROCESSORDETECTION_H
};

#endif // APPMANAGER_H
