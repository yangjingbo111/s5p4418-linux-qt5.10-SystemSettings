#include "lightnessworker.h"
#include <QProcess>
#include <QFile>
#include "micros.h"

LightnessWorker::LightnessWorker(QObject *parent)
    :QObject (parent)
{

}

void LightnessWorker::setLightness(int light)
{
    QProcess backlight;
    QStringList arg;
    arg << QString::number(light);
    backlight.setProgram(BACKLIGHT_TEST);
    backlight.setArguments(arg);
    backlight.start();
    backlight.waitForStarted();
    backlight.waitForFinished();

    // save lightness value to local file
    QFile file(LIGHT_CONFIG_FILE);
    if (!file.open(QIODevice::WriteOnly | QIODevice::Text))
        return;

    QTextStream out(&file);
    out << light << "\n";
    file.close();

}
