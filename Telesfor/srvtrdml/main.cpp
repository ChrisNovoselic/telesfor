#include <QtGui/QApplication>
#include <QtDebug>
#include <QtNetwork>

#include "hmanagementtreadmill.h"
#include "hthreadtcpsocket.h"

HManagementTreadmill *g_pMngntTrdml = 0x0;
//vector <HThreadTcpSocket *>g_arPtrThreadSocket;
QMap <HThreadTcpSocket *, int> g_mapPtrThreadSocket;

int exitMain (QString , int );
int g_iStop = 0;

int main(int argc, char *argv [])
{
//    QApplication a (argc, argv);
    int iExitCode = argc - 1;

    while (iExitCode > 0) {
        cout << (argc - iExitCode) << " argument: " << argv [argc - iExitCode] << endl;
        iExitCode --;
    }

    QString serverName  = "127.0.0.1";
    quint16  serverPort = 66666;
    const int timeOut = 5 * 1000;

    QTcpSocket socket;
    socket.connectToHost (serverName, serverPort);

    if (! socket.waitForConnected (timeOut)) {
        cout << QObject::tr ("Сервер не отвечает...").toStdString () << socket.error () << ", " << socket.errorString ().toStdString () << endl;
        if (argc < 3) {
            g_pMngntTrdml = new HManagementTreadmill;
            g_pMngntTrdml->husb_device_init ();

            if (g_pMngntTrdml->validHandleDevice () == 1) {
                if (argc == 2) {
                    cout << QObject::tr ("Выполняю команду: ").toStdString () << argv [1] << endl;

                    if (QString (argv [1]).compare ("stop") == 0) {
                        return exitMain (QObject::tr ("Завершение работы с кодом: "), iExitCode);
                    }
                    else {
                        //Выполнение команды...
                        g_pMngntTrdml->executeCommand (argv [1]);
                    }
                }
                else
                    ;
            }
            else {
                iExitCode = -1; //Не инициализированА дорожка
                return exitMain (QObject::tr ("Не инициализированА дорожка 'iExitCode' = "), iExitCode);
            }

            //Запуск сервера
            QTcpServer  tcpSrv;

            if (! tcpSrv.listen (QHostAddress::Any, serverPort)) {
                qDebug () <<  QObject::tr ("Unable to start the server: %1.").arg (tcpSrv.errorString ());
            }
            else {
                HThreadTcpSocket *pThreadTcpSocket = NULL;
                cout << QObject::tr ("Сервер: готов к ПРИЁМу....").toStdString () << endl;

                while (g_iStop == 0) {
                    if (tcpSrv.waitForNewConnection (100)) {
                        pThreadTcpSocket = new HThreadTcpSocket (tcpSrv.nextPendingConnection ());
                        pThreadTcpSocket->start ();
                        g_mapPtrThreadSocket.insert (pThreadTcpSocket, 1);
//                        QObject::connect (g_mapPtrThreadSocket.at (g_mapPtrThreadSocket.size () - 1), SIGNAL (sgnExitTcpSocket (int )), SLOT (onSgnExitTcpSocket (int )));

//                        cout << QObject::tr ("Сервер: готов к ПРИЁМу....").toStdString () << endl;
                    }
                    else {
                        QList <HThreadTcpSocket *> listKeys = g_mapPtrThreadSocket.keys ();
                        int szMap = listKeys.size (); int iThreadTcpSocketStop = 0;
                        while (listKeys.size () > 0) {
                            if (listKeys [szMap - 1]->isRunning () == false) {
                                iThreadTcpSocketStop = 1; //Один из потокОВ завершился

                                g_iStop = g_mapPtrThreadSocket [listKeys [szMap - 1]];
                                g_mapPtrThreadSocket.remove (listKeys [szMap - 1]);
//                                listKeys [szMap - 1]->m_pTcpSocket->disconnectFromHost ();
                                delete listKeys [szMap - 1];
                                listKeys.removeAt (szMap - 1);
                            }
                            else
                                ;
                        }

//                        Один из СОКЕТов отсоединЁн, но команда СТОП не поданА
                        if ((g_iStop == 0) && (iThreadTcpSocketStop == 1)) //Пока ещё не останавливаемся
                            cout << QObject::tr ("Сервер: готов к ПРИЁМу....").toStdString () << endl;
                        else {
                            ; //Остановить и разрушить остальные ПОТОКи
                        }
                    }
                }
            }
        }
        else
            cout << "Недопустимое колтичество аргументов!" << endl;

    }
    else {
        if (argc == 2) {
            cout << "Клиент: соединение с сервером:" << socket.localAddress ().toString ().toStdString () << endl;

            socket.write (argv [1]);

//            if (argv [1] == "stop") {
//                Ожидание сообщения от серверА
                if (! socket.waitForReadyRead (timeOut)) {
                    cout << "Клиент: " << socket.error () << ": " << socket.errorString ().toStdString () << endl;

                    iExitCode = 2;
                }
                else {
                    QDataStream in (&socket);
                    in.setVersion (QDataStream::Qt_4_8);

                    cout << "Received (" << socket.bytesAvailable () << "): ";
                    unsigned char ch;
                    while (in.device ()->getChar ((char *) &ch))
                        cout << ch;
                    cout << endl;
                }
//            }
//            else
//                ; //Окончание работы СЕРВЕРа ('OK' не будет отправлено)
        }
        else
            cout << "Клиент: Недопустимое колтичество аргументов:" << argc - 1 << " (д.б. ОДИН!)" << endl;

        socket.disconnectFromHost ();
    }

    
//    a.exit (iExitCode);
    return exitMain (QObject::tr ("Завершение работы с кодом: "), iExitCode);
}

int exitMain (QString msg, int code) {
    cout << msg.toStdString () << code << endl;
    if (g_pMngntTrdml == 0x0)
        ;
    else {
        if (g_pMngntTrdml->validHandleDevice ())
            g_pMngntTrdml->executeCommand ("*601*");
        else
            ;

        g_pMngntTrdml->free_usb_device_descs ();

        delete g_pMngntTrdml;
    }

    return code;
}
