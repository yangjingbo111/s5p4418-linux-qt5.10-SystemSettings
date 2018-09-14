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

signals:

public slots:
    void appStarted();
    void appGotError();

private:
    QPROCESSORDETECTION_H
};

#endif // APPMANAGER_H
