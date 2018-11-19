#ifndef LIGHTNESSWORKER_H
#define LIGHTNESSWORKER_H

#include <QObject>


class LightnessWorker : public QObject
{
    Q_OBJECT
public:
    LightnessWorker(QObject *parent = nullptr);
public slots:
    void setLightness(int light);

};

#endif // LIGHTNESSWORKER_H
