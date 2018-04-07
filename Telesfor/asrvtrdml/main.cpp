#include "happlication.h"
#include <QtGui/QApplication>
//#include <QtDebug>
#include <QtNetwork>

#include "hthreadtcpsocket.h"

void exitMsg (QString , int );
int g_iStop = 0;

int main (int argc, char *argv [])
{
    QString serverName  = "127.0.0.1";
    quint16  serverPort = 66666;
    const int timeOut = 5 * 1000; //5 секунД

    HApplication theApp (argc, argv, serverPort);
    int iExitCode = 0;

//    iExitCode = argc - 1;
//    while (iExitCode > 0) {
//        cout << (argc - iExitCode) << " argument: " << argv [argc - iExitCode] << endl;
//        iExitCode --;
//    }

    if (argc < 5) {
        QTcpSocket socket;
        socket.connectToHost (serverName, serverPort);

        if (! socket.waitForConnected (timeOut)) {
            cout << QObject::tr ("Сервер не отвечает...").toStdString () << socket.error () << ", " << socket.errorString ().toStdString () << endl;

                theApp.initTreadmill ();

                if (theApp.isInitTreadmill () == 1) {
                    if (argc == 2) {
                        cout << QObject::tr ("Выполняю команду: ").toStdString () << argv [1] << endl;

                        if (QString (argv [1]).compare ("stop") == 0) {
                            exitMsg (QObject::tr ("Завершение работы с кодом: "), iExitCode);
                            exit (iExitCode);
                        }
                        else {
                            //Выполнение команды...
                            theApp.executeCommand ();
                        }
                    }
                    else
                        ;
                }
                else {
                    iExitCode = -2;
                    exitMsg (QObject::tr ("Не инициализированА дорожка 'iExitCode' = "), iExitCode);
                    exit (iExitCode); //Не инициализированА дорожка
                }

                //Запуск сервера
                theApp.initServer ();

//                Проверка на валидность СЕРВЕРа ???

                cout << QObject::tr ("Сервер: готов к ПРИЁМу....").toStdString () << endl;
                return theApp.exec ();
        }
        else {
            if (argc == 2) { //А не хочет ли USER запустить СЕРВЕР ???
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
                cout << "Клиент: Недопустимое колтичество аргументов:" << argc - 1 << " (д.б. хотя бы ОДИН!)" << endl;

            socket.disconnectFromHost ();
        }
    }
    else {
        iExitCode = -3;
        cout << "Недопустимое колтичество аргументов!" << endl;
    }

    exitMsg (QObject::tr ("Завершение работы с кодом: "), iExitCode);
    theApp.exit (iExitCode);
}

void exitMsg (QString msg, int code) {
    cout << msg.toStdString () << code << endl;
}
