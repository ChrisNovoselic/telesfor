#ifndef HTHREADTHREADMILLPULSE_H
#define HTHREADTHREADMILLPULSE_H

#include <QThread>
#include <QVariant>

#include <QTimer>
#include <QTimerEvent>

#include <QtNetwork>

//#include "hmanagementtreadmill.h"

#include <iostream>
using namespace std;

class HThreadManagementThreadmill : public QThread
{
    Q_OBJECT
public:
    explicit HThreadManagementThreadmill (QObject *parent = 0);
    ~HThreadManagementThreadmill (void);

    enum STATE_TREADMILL {READABLE, WRITABLE};
    STATE_TREADMILL m_stateTreamill;

    virtual void run (void);
    void stop (void);
    int isInitTreadmill (void);
    
signals:
    void sgnPulseTreadmill (QVariant); //Отправление на сторону QML значения пульса
    void sgnEnabledButtonTrack (QVariant); //вКЛЮЧЕНИЕ/ОТКЛЮЧЕНИЕ ОБЛАСТИ управления ДОРОЖКой
    void sgnCheckedButtonTrack (QVariant);
    void sgnExecuteCommand (QString);

    void sgnReconnection (void);
    
public slots:
    void onSgnManagementTreadmill (QString );
//    void onSgnQueryPulse (QString ); //Запрос от Qml
    void onSgnExecuteCommand (QString);
    void onSgnTcpSocketReadyRead (void);
    void onSgnTcpSocketDisconected (void);

    void onSgnReconnection (void);

//    void timerEvent (QTimerEvent*);
    void timerPulse (void);

private:
//    HManagementTreadmill *m_pManagementTreadmill;
    QTcpSocket *m_pManagementTreadmill;
    int m_sliderQueryDiscretePulse;
    qint32 m_iIdTimerPulse;
    QTimer m_TimerPulse;

//    Константы для соединения
    QString m_ServerIP;
    quint16  m_ServerPort;
    quint32 m_timeOut;

    int m_iStateManagementTreadmill;
    int stateManagementTreadmill (void);

    int m_iCountEmitMeasurementPulse;

//    std::vector <QString> m_vectorStringRecievedSrvTreadmill;
    QMap <QString, QString> m_mapRecievedSrvTreadmill;
};

#endif // HTHREADTHREADMILLPULSE_H
