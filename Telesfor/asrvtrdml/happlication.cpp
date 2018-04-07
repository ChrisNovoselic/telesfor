#include "happlication.h"

HApplication::HApplication (int c, char **a, int serverPort) : QCoreApplication (c, a), m_pMngntTrdml (0x0), m_iServerPort (serverPort) {
    QStringList listArgv = arguments ();
    for (int i = 1; i < listArgv.size (); i ++) {
        cout << "Аргумент " << i << ": " << listArgv.at (i).toStdString () << " распознан как ";
        if (listArgv.at (i).indexOf ("=") > 1) {
            switch (parseArgv (listArgv.at (i))) {
                case IP_SERVER:
                    cout << "IP-адрес сервера";
                    break;
                case PORT_LINK:
                    cout << "номер порта для связи клиент/сервер";
                    break;
                case TYPE_APP:
                    cout << "тип запуска";
                    break;
                case CMD:
                    cout << "команда для выполнения";
                    break;
                default:
                    cout << "НЕИЗВЕСТНЫЙ";
            }
        }
        else {
            cout << "команда для выполнения";
            m_arArgv [CMD] = listArgv.at (i);
        }

        cout << endl;
    }
}

HApplication::~HApplication () {
    if (m_pMngntTrdml == 0x0)
        ;
    else {
        if (m_pMngntTrdml->validHandleDevice ())
            m_pMngntTrdml->executeCommand ("*601*");
        else
            ;

        m_pMngntTrdml->free_usb_device_descs ();

        delete m_pMngntTrdml;
    }

    cout << "Деструктор приложения..."  << endl;
}

int HApplication::parseArgv (QString arg) {
    int iRes = -1;
    if (arg.indexOf ("ip") > -1)
        iRes = IP_SERVER;
    else
        if (arg.indexOf ("app") > -1)
            iRes = TYPE_APP;
        else
            if (arg.indexOf ("port") > -1)
                iRes = PORT_LINK;
            else
                if (arg.indexOf ("cmd") > -1)
                    iRes = CMD;
                else
                    ;

    if (iRes > -1)
        m_arArgv [iRes] = arg.right (arg.length() - (arg.indexOf ("=") + 1));
    else
        ;

    cout << "(::parseArgv = " << iRes << ") ";
    return iRes;
}

void HApplication::executeCommand (QString cmd) {
    cout << "HApplication::executeCommand (), cmd = " << cmd.toStdString () << endl;

    QString strRecieve = "";

    if (! (m_pMngntTrdml == 0x0)) {
        if (m_pMngntTrdml->validHandleDevice () == 1) {
            if (cmd.isEmpty ())
                cmd = argvCmd ();
            else
                ;

            m_pMngntTrdml->executeCommand (cmd);

            strRecieve = m_pMngntTrdml->readRecieve ();
        }
        else
            ; //дорожка НЕ открыта для чтение/запись
    }
    else
        ; //нет обЪектА-дорожкА


    if (strRecieve.isEmpty ()) {
        sgnTreadmillResponse ("TREADMILL NOT RESPONSE...");
    }
    else
        sgnTreadmillResponse (strRecieve);
}

int HApplication::initTreadmill (void) {
    m_pMngntTrdml = new HManagementTreadmill;
    m_pMngntTrdml->husb_device_init ();
}

int HApplication::isInitTreadmill (void) {
    return m_pMngntTrdml->validHandleDevice ();
}

void HApplication::onSgnNewConnection () {
    HThreadTcpSocket *pThreadTcpSocket = new HThreadTcpSocket (m_tcpSrv.nextPendingConnection ());

    connect (this, SIGNAL (sgnTreadmillResponse (QString)), pThreadTcpSocket, SLOT (onSgnTreadmillResponse (QString)));
    connect (pThreadTcpSocket, SIGNAL (sgnExecuteCommand (QString )), this, SLOT (executeCommand (QString )));

    connect (pThreadTcpSocket->getTcpSocket (), SIGNAL (disconnected ()), this, SLOT (onSgnTcpSocketDisconnected ()));
    connect (pThreadTcpSocket, SIGNAL (finished ()), this, SLOT (onSgnThreadFinished ()));

    pThreadTcpSocket->start ();
    m_arPtrThreadSocket.push_back (pThreadTcpSocket);
}

int HApplication::initServer (void) {
    if (! m_tcpSrv.listen (QHostAddress::Any, m_iServerPort)) {
        cout <<  QObject::tr ("Unable to start the server: ").toStdString () << m_tcpSrv.errorString ().toStdString () << endl;
    }
    else {
        connect (&m_tcpSrv, SIGNAL (newConnection ()), this, SLOT (onSgnNewConnection ()));
    }
}

void HApplication::onSgnTcpSocketDisconnected () {
    cout << "HApplication::onSgnTcpSocketDisconnected ()" << endl;

    int iStop = -1;
    vector <HThreadTcpSocket *>:: iterator threadSocketIt = m_arPtrThreadSocket.begin ();
    for (threadSocketIt; threadSocketIt != m_arPtrThreadSocket.end (); ) {
        iStop = (*threadSocketIt)->getExitCode ();

//        if ((*threadSocketIt)->isFinished ()) {
        if (iStop > 0) {
            cout << "Останавливаю поток с кодом: " << iStop << endl;
            (*threadSocketIt)->exit (iStop);

//            QDateTime dtBegin, dtEnd = QDateTime::currentDateTime ();
//            while ((*threadSocketIt)->isRunning ());
            (*threadSocketIt)->wait ();
//            dtEnd = QDateTime::currentDateTime ();
//            cout << "..." << dtBegin.msecsTo (dtEnd) << endl;
        }
        else
            ;

        threadSocketIt ++;
    }
}

void HApplication::onSgnThreadFinished (void) {
    cout << QObject::tr ("HApplication::onSgnThreadFinished (): one of the threads is FINISHed...").toStdString () << endl;

    int iStop = -1;
    vector <HThreadTcpSocket *>:: iterator threadSocketIt = m_arPtrThreadSocket.begin ();
    for (threadSocketIt; threadSocketIt != m_arPtrThreadSocket.end (); ) {
        iStop = (*threadSocketIt)->getExitCode ();

        if ((*threadSocketIt)->isFinished ()) {
//        if (iStop > 0) {
            delete (*threadSocketIt);
            threadSocketIt = m_arPtrThreadSocket.erase (threadSocketIt);
        }
        else
            threadSocketIt ++;
    }

//    Один из СОКЕТов отсоединЁн, но команда СТОП не поданА
    if (! (iStop == HThreadTcpSocket::STOP)) //Пока ещё не останавливаемся
        cout << QObject::tr ("Сервер: готов к ПРИЁМу...").toStdString () << endl;
    else {
        ; //Остановить и разрушить остальные ПОТОКи

        cout << QObject::tr ("Завершение работы с кодом: ").toStdString () << 0 << endl;
        exit (0x0);
    }
}
