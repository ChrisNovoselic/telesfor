#include "hthreadtcpsocket.h"
#include "hmanagementtreadmill.h"

//HThreadTcpSocket::HThreadTcpSocket(QObject *parent) : QThread (parent) {
//}

HThreadTcpSocket::HThreadTcpSocket(QTcpSocket *pSocket, QObject *parent) : QThread (parent), m_pTcpSocket (pSocket), m_iExitCode (-1) {
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
        emit sgnExecuteCommand ("*601*");

        m_iExitCode = STOP;
    }
    else {
        emit sgnExecuteCommand (strReceived);
    }
}

void HThreadTcpSocket::onSgnTreadmillResponse (QString response) {
    cout << QObject::tr ("ОтправЛЯю квитанцию: ").toStdString () << response.toStdString () << endl;
    if (m_pTcpSocket->write (response.toLocal8Bit ())) {
        //Успех при отправлении квитанции о выполнении
        cout << QObject::tr ("ОтправИЛ квитанцию: ").toStdString () << response.toStdString () << endl;
    }
    else
        ;
}

void HThreadTcpSocket::onSgnTcpSocketDisconnected () {
    cout << "HThreadTcpSocket::onSgnTcpSocketDisconnected..." << endl;

    if (m_iExitCode == -1) {
        //Просто обрыв
        m_iExitCode = DISCONNECT;
    }
    else
        ;

    //exit (m_iExitCode);
}

void HThreadTcpSocket::onSgnTcpSocketStateChanged (QVariant state) { //QAbstractSocket::SocketState
    cout << "::onSgnTcpSocketStateChanged..." << state.toString ().toStdString () << endl;
}

void HThreadTcpSocket::run (void) {
    exec ();
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
