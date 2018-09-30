#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "appmanager.h"
int main(int argc, char *argv[])
{
    qputenv("QT_IM_MODULE", QByteArray("qtvirtualkeyboard"));

    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    /**
     * @brief qmlRegisterType<AppManager>
     */
    qmlRegisterType<AppManager>("AppManager", 1, 0, "AppManager");


    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
