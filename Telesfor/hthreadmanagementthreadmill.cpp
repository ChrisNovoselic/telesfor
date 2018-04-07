#include "hthreadmanagementthreadmill.h"

HThreadManagementThreadmill::HThreadManagementThreadmill (QObject *parent) : QThread (parent), m_stateTreamill (WRITABLE), m_iCountEmitMeasurementPulse (0x0) {
    moveToThread (this);
//    m_pManagementTreadmill = new HManagementTreadmill;
//    m_pManagementTreadmill->husb_device_init ();
//    m_pManagementTreadmill->moveToThread (this);

    m_iIdTimerPulse = -1;
    connect (&m_TimerPulse, SIGNAL (timeout ()), this, SLOT (timerPulse ()));

//    Константы для соединения
    m_ServerIP  = "127.0.0.1";
    m_ServerPort = 66666;
    m_timeOut = 5 * 1000;

    m_sliderQueryDiscretePulse = 1 * 1000;

    cout << "Ожидание соединения с СЕРВЕРом управления ДОРОЖкой" << endl;
    m_pManagementTreadmill = new QTcpSocket ();

    m_pManagementTreadmill->connectToHost (m_ServerIP, m_ServerPort);

    if (! m_pManagementTreadmill->waitForConnected (m_timeOut)) {
        cout << QObject::tr ("Сервер не отвечает...").toStdString () << endl;
    }
    else {
        cout << "Клиент: соединение с сервером:" << m_pManagementTreadmill->localAddress ().toString ().toStdString () << endl;

        connect (this, SIGNAL (sgnExecuteCommand (QString)), this, SLOT (onSgnExecuteCommand (QString)));
        connect (m_pManagementTreadmill, SIGNAL (readyRead ()), this, SLOT (onSgnTcpSocketReadyRead ()));
        connect (m_pManagementTreadmill, SIGNAL (disconnected ()), this, SLOT (onSgnTcpSocketDisconected ()));
    }
}

HThreadManagementThreadmill::~HThreadManagementThreadmill (void) {
    sgnExecuteCommand ("*601*");

    delete m_pManagementTreadmill;

    cout << "~HThreadManagementThreadmill = " << endl;
}

int HThreadManagementThreadmill::stateManagementTreadmill (void) {
    int iRes = 0;

    switch (m_pManagementTreadmill->state ()) {
        case QTcpSocket::UnconnectedState:
            break;
        case QTcpSocket::HostLookupState:
            break;
        case QTcpSocket::ConnectingState:
            break;
        case QTcpSocket::ConnectedState:
            iRes = 1;
            break;
        case QTcpSocket::BoundState:
            break;
        case QTcpSocket::ListeningState:
            break;
        case QTcpSocket::ClosingState:
            break;
        default:
            ;
    }

    return iRes;
}

void HThreadManagementThreadmill::run (void)
{
    m_iStateManagementTreadmill = stateManagementTreadmill ();
    sgnEnabledButtonTrack (m_iStateManagementTreadmill);

//    m_iIdTimerPulse = startTimer (m_sliderQueryDiscretePulse); //обработчик 'timerEvent'
    m_TimerPulse.moveToThread (this);
    m_TimerPulse.start (m_sliderQueryDiscretePulse); //обработчик 'timerPulse'

    exec ();
}

//Обработка сигнала от QML на выполнение команды 'cmd'
void HThreadManagementThreadmill::onSgnManagementTreadmill (QString cmd) {
    cout << "Клиент: 'onSgnManagementTreadmill' = " << cmd.toStdString () << endl;
    emit sgnExecuteCommand (cmd);
}

//Обработка сигнала от QML на выполнение команды 'cmd' (*111#34* ИЛИ *111#35*)
//void HThreadManagementThreadmill::onSgnQueryPulse (QString cmd) {
////    cout << "command query pulse of tradmill = " << cmd.toStdString () << endl;
////    m_pManagementTreadmill->executeCommand (cmd);

////    emit sgnPulseTreadmill (m_pManagementTreadmill->readPulse ());
//}
//События от таймерА с id = m_iIdTimerPulse
//void HThreadManagementThreadmill::timerEvent (QTimerEvent* te) {
////    cout << "HThreadManagementThreadmill::timerEvent = " << te->timerId () << endl;
//}
//События от таймерА 'm_TimerPulse'
void HThreadManagementThreadmill::timerPulse (void) {
    cout << "HThreadManagementThreadmill::timerPulse = " << endl;
//    cout << "command query pulse of treadmill = " << cmd.toStdString () << endl;

    if (! (m_iStateManagementTreadmill == stateManagementTreadmill ())) {
        m_iStateManagementTreadmill == stateManagementTreadmill ();
        sgnEnabledButtonTrack (m_iStateManagementTreadmill);

        emit sgnReconnection ();
    }
    else
        ;

    m_iCountEmitMeasurementPulse ++;

    QString cmd = "*111#34*";
//    while (m_stateTreamill == READABLE);
    emit sgnExecuteCommand (cmd);

//    while (m_stateTreamill == READABLE);
    QString pulseVal = m_mapRecievedSrvTreadmill [cmd];

//    if ((pulseVal.indexOf ("NaN") > -1) || (pulseVal.isEmpty ()) || (pulseVal.toFloat () == 0.0f)) {
//        cmd.replace ("34", "35");
////        while (m_stateTreamill == READABLE);
//        emit sgnExecuteCommand (cmd);

////        while (m_stateTreamill == WRITABLE);
//        pulseVal = m_mapRecievedSrvTreadmill [cmd];
//    }
//    else
//        ;

    if (m_iCountEmitMeasurementPulse > 13) {
        cout << "Клиент::timerPulse НЕ ДОСТОВЕРЕН = " << m_iCountEmitMeasurementPulse << endl;

//        emit sgnReconnection ();
    }
    else
        ;

    cout << "Клиент::timerPulse отправлюя для Qml = " << pulseVal.toStdString () << endl;
    emit sgnPulseTreadmill (pulseVal);
}

void HThreadManagementThreadmill::stop (void) {
    /*terminated ();
    destroyed ();*/

    killTimer (m_iIdTimerPulse);
    m_TimerPulse.stop ();

    exit ();

    QDateTime dtStart = QDateTime::currentDateTime (), dtEnd;

    cout << "wait of exit threadmanagmentthreadmill (msec) ... "/* << endl*/;
    while (isRunning ())
        /*cout << "wait of exit threadmanagmentthreadmill..." << endl*/;

    dtEnd = QDateTime::currentDateTime ();
    cout << dtStart.msecsTo (dtEnd) << endl;
}

int HThreadManagementThreadmill::isInitTreadmill (void) {
    return m_pManagementTreadmill == 0x0 ? 0 : 1;
}

void HThreadManagementThreadmill::onSgnExecuteCommand (QString cmd) {
    if (m_pManagementTreadmill->isWritable ()) {
        QByteArray blockOut;
        blockOut.append (cmd);

        while (m_stateTreamill == READABLE);
        m_stateTreamill = READABLE;

        if (m_pManagementTreadmill->write (blockOut) > -1)
            ;
        else
            cout << "HThreadManagementThreadmill::onSgnExecuteCommand () ..." << "Данные отправлены с ОШИБКой!" << endl;

//        m_stateTreamill = READABLE;

//    Ожидание сообщения от серверА
        if (! m_pManagementTreadmill->waitForReadyRead (m_timeOut)) {
            cout << "Клиент: " << m_pManagementTreadmill->error () << ": " << m_pManagementTreadmill->errorString ().toStdString () << endl;
            m_stateTreamill = WRITABLE;
        }
        else {
//            QDataStream in (m_pManagementTreadmill);
//            in.setVersion (QDataStream::Qt_4_8);

//            m_mapRecievedSrvTreadmill [cmd].clear ();

//            cout << "Клиент: received (" << m_pManagementTreadmill->bytesAvailable () << "): ";
//            unsigned char ch;
//            while (in.device ()->getChar ((char *) &ch)) {
//                m_mapRecievedSrvTreadmill [cmd].append (ch);
//                cout << ch;
//            }
//            cout << endl;

//            m_stateTreamill = WRITABLE;
        }
    }
    else
        cout << "Клиент: 'onSgnExecuteCommand' = Невозможно послать строкУ серверу управления ДОРОЖКой" << endl;
}

void HThreadManagementThreadmill::onSgnTcpSocketReadyRead (void) {
    cout << "HThreadManagementThreadmill::onSgnTcpSocketReadyRead..." << m_pManagementTreadmill->bytesAvailable () << endl;

////    while (m_stateTreamill == WRITABLE);

    QString strRecieved, cmd;
    QDataStream in (m_pManagementTreadmill);
    in.setVersion (QDataStream::Qt_4_8);

    cout << "Клиент: received (" << m_pManagementTreadmill->bytesAvailable () << "): ";
    unsigned char ch;
    while (in.device ()->getChar ((char *) &ch)) {
        strRecieved.append (ch);
        cout << ch;
        if ((ch == '=') || (ch == ':')) {
            if (! cmd.isEmpty ())
                cmd.clear ();
            else
                ;

            cmd = "*" + strRecieved.left (strRecieved.length () - 1) + "*";
        }
        else
            ;
    }
    cout << endl;

    cmd.replace ("=", "#");

    m_mapRecievedSrvTreadmill [cmd].clear ();
    m_mapRecievedSrvTreadmill [cmd] = strRecieved.right (strRecieved.length () - cmd.length () - 1 + 2);
    cout << "Клиент: расшифорвка...[" << cmd.toStdString () << "] = " << m_mapRecievedSrvTreadmill [cmd].toStdString () << endl;

    m_stateTreamill = WRITABLE;

    if (cmd.indexOf ("600") > -1) {
        sgnCheckedButtonTrack (true);
    }
    else
        if (cmd.indexOf ("601") > -1) {
            sgnCheckedButtonTrack (false);
        }
        else
            if ((cmd.indexOf ("111#34") > -1) || (cmd.indexOf ("111#35") > -1)) {
                m_iCountEmitMeasurementPulse --;
            }
            else
                ;
}

void HThreadManagementThreadmill::onSgnTcpSocketDisconected (void) {
    cout << "HThreadManagementThreadmill::onSgnTcpSocketDisconected..." << endl;
}


void HThreadManagementThreadmill::onSgnReconnection (void) {
    cout << "HThreadManagementThreadmill::onSgnReconnection..." << endl;

    m_iCountEmitMeasurementPulse = 0;
}
