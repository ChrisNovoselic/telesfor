#include "hthreadtcpsocket.h"
#include "hmanagementtreadmill.h"

extern HManagementTreadmill *g_pMngntTrdml;
extern QMap <HThreadTcpSocket *, int> g_mapPtrThreadSocket;

HThreadTcpSocket::HThreadTcpSocket(QObject *parent) : QThread (parent) {
}

HThreadTcpSocket::HThreadTcpSocket(QTcpSocket *pSocket, QObject *parent) : QThread (parent), m_pTcpSocket (pSocket) {
    connect (m_pTcpSocket, SIGNAL (readyRead ()), this, SLOT (onSgnTcpSocketReadyRead ()));
    connect (m_pTcpSocket, SIGNAL (disconnected ()), this, SLOT (onSgnTcpSocketDisconnected ()));
//    connect (m_pTcpSocket, SIGNAL (stateChanged (QVariant)), this, SLOT (onSgnTcpSocketStateChanged (QVariant)));
}

HThreadTcpSocket::~HThreadTcpSocket () {
    disconnect (m_pTcpSocket, SIGNAL (readyRead ()), this, SLOT (onSgnTcpSocketReadyRead ()));
    disconnect (m_pTcpSocket, SIGNAL (disconnected ()), this, SLOT (onSgnTcpSocketDisconnected ()));
//    disconnect (m_pTcpSocket, SIGNAL (stateChanged (QVariant)), this, SLOT (onSgnTcpSocketStateChanged (QVariant)));

    cout << "Деструктор сокета..." << m_pTcpSocket->localAddress ().toString ().toStdString () << endl;
}

void HThreadTcpSocket::onSgnTcpSocketReadyRead () {
    cout << "::onSgnTcpSocketReadyRead..." << endl;

    QDataStream in (m_pTcpSocket);
    in.setVersion (QDataStream::Qt_4_0);

    QString strReceived = "";
    cout << "Received (" << m_pTcpSocket->bytesAvailable () << "): ";
    unsigned char ch;
    while (in.device ()->getChar ((char *) &ch)) {
        if (ch > 31) {
            cout << ch;
            strReceived.append (ch);
        }
        else
            ; //Не отображаемые символы
    }
    cout << endl;

    cout << QObject::tr ("Выполняю команду: ").toStdString () << strReceived.toStdString () << endl;

    //Выполнение команды...
    if (strReceived.compare ("stop") == 0) {
        g_pMngntTrdml->executeCommand ("*601*");

        g_mapPtrThreadSocket [this] = 1;

        exit ();
    }
    else {
        g_pMngntTrdml->executeCommand (strReceived);
    }

//            if (! (strReceived.compare ("stop") == 0)) {
        QByteArray block;
        block.append (g_pMngntTrdml->readRecieve ());

        cout << QObject::tr ("ОтправЛЯю квитанцию: ").toStdString () << block.constData () << endl;
        if (m_pTcpSocket->write (block)) {
            //Успех при отправлении квитанции о выполнении
            cout << QObject::tr ("ОтправИЛ квитанцию: ").toStdString () << block.constData () << endl;
        }
        else
            ;
//            }
//            else
//                ; //END CONNECTION...
}

void HThreadTcpSocket::onSgnTcpSocketDisconnected () {
    cout << "::onSgnTcpSocketDisconnected..." << endl;

    g_mapPtrThreadSocket [this] = 0;
}

void HThreadTcpSocket::onSgnTcpSocketStateChanged (QVariant state) { //QAbstractSocket::SocketState
    cout << "::onSgnTcpSocketStateChanged..." << state.toString ().toStdString () << endl;
}

void HThreadTcpSocket::run (void) {
//    cout << "NEW CONNECTION..." << m_pTcpSocket->localAddress ().toString ().toStdString () << endl;

    const int timeOut = 5 * 1000;
    QString strReceived = "";

//    Ожидание сообщения
    while ((m_pTcpSocket->bytesAvailable () < (int) sizeof (quint16))) {
        if (! m_pTcpSocket->waitForReadyRead (timeOut)) {
            cout << "Лжидание сообщения..." << m_pTcpSocket->state () << endl;
            if ((m_pTcpSocket->state () == QTcpSocket::UnconnectedState) ||
                 (m_pTcpSocket->state () == QTcpSocket::ClosingState)) {
                cout << "END CONNECTION..." << m_pTcpSocket->localAddress ().toString ().toStdString () <<
                        ", state = " << m_pTcpSocket->state () << endl;
                break;
            }
            else
                ;
        }
        else {
            if (strReceived.compare ("stop") == 0) {
                cout << "END CONNECTION..." << m_pTcpSocket->localAddress ().toString ().toStdString () <<
                        ", state (stop) = " << m_pTcpSocket->state () << endl;
                break;
            }
            else
                ;

            QDataStream in (m_pTcpSocket);
            in.setVersion (QDataStream::Qt_4_0);

            strReceived.clear ();
            cout << "Received (" << m_pTcpSocket->bytesAvailable () << "): ";
            unsigned char ch;
            while (in.device ()->getChar ((char *) &ch)) {
                if (ch > 31) {
                    cout << ch;
                    strReceived.append (ch);
                }
                else
                    ; //Не отображаемые символы
            }
            cout << endl;

            cout << QObject::tr ("Выполняю команду: ").toStdString () << strReceived.toStdString () << endl;

            //Выполнение команды...
            if (strReceived.compare ("stop") == 0) {
                g_pMngntTrdml->executeCommand ("*601*");
            }
            else {
                g_pMngntTrdml->executeCommand (strReceived);
            }

//            if (! (strReceived.compare ("stop") == 0)) {
                QByteArray block;
                block.append (g_pMngntTrdml->readRecieve ());

                cout << QObject::tr ("ОтправЛЯю квитанцию: ").toStdString () << block.constData () << endl;
                if (m_pTcpSocket->write (block)) {
                    //Успех при отправлении квитанции о выполнении
                    cout << QObject::tr ("ОтправИЛ квитанцию: ").toStdString () << block.constData () << endl;
                }
                else
                    ;
//            }
//            else
//                ; //END CONNECTION...
        }
    }

    if (strReceived.compare ("stop") == 0) {
        g_mapPtrThreadSocket [this] = 1;
    }
    else {
        g_mapPtrThreadSocket [this] = 0;
    }

//    exec ();
}

//int HThreadTcpSocket::stateSocket (void) {
//    int iRes = 0;

//    switch (m_pTcpSocket->state ()) {
//        case QTcpSocket::UnconnectedState:
//            break;
//        case QTcpSocket::HostLookupState:
//            break;
//        case QTcpSocket::ConnectingState:
//            break;
//        case QTcpSocket::ConnectedState:
//            iRes = 1;
//            break;
//        case QTcpSocket::BoundState:
//            break;
//        case QTcpSocket::ListeningState:
//            break;
//        case QTcpSocket::ClosingState:
//            break;
//        default:
//            ;
//    }

//    return iRes;
//}
