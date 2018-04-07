#ifndef HTHREADTCPSOCKET_H
#define HTHREADTCPSOCKET_H

#include <QThread>
#include <QtNetwork>

#include <iostream>
using namespace std;

class HThreadTcpSocket : public QThread
{
    Q_OBJECT
public:
//    explicit HThreadTcpSocket (QObject *parent = 0);
    HThreadTcpSocket (QTcpSocket *, QObject *parent = 0);
    ~HThreadTcpSocket ();

    enum ID_EXIT_CODE {STOP = 666, DISCONNECT};
    
    virtual void run (void);
    QTcpSocket *getTcpSocket (void) { return m_pTcpSocket; }
    int getExitCode (void) { return m_iExitCode; }

signals:
    void sgnExecuteCommand (QString );

public slots:
    void onSgnTcpSocketReadyRead ();
    void onSgnTcpSocketDisconnected ();
    void onSgnTcpSocketStateChanged (QVariant );
    void onSgnTreadmillResponse (QString );

private:
    QTcpSocket *m_pTcpSocket;
    int m_iExitCode;
};

#endif // HTHREADTCPSOCKET_H
