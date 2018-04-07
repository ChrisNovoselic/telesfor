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
    explicit HThreadTcpSocket (QObject *parent = 0);
    HThreadTcpSocket (QTcpSocket *, QObject *parent = 0);
    ~HThreadTcpSocket ();
    
    virtual void run (void);

signals:

public slots:
    void onSgnTcpSocketReadyRead ();
    void onSgnTcpSocketDisconnected ();
    void onSgnTcpSocketStateChanged (QVariant);

private:
    QTcpSocket *m_pTcpSocket;
};

#endif // HTHREADTCPSOCKET_H
