#ifndef HAPPLICATION_H
#define HAPPLICATION_H

#include <QCoreApplication>
#include <iostream>

using namespace std;

#include "hthreadtcpsocket.h"
#include "hmanagementtreadmill.h"

class HApplication : public QCoreApplication
{
    Q_OBJECT
public:
    explicit HApplication (int , char **, int );
    virtual  ~HApplication (void);

    enum ID_ARGS {IP_SERVER, PORT_LINK, TYPE_APP, CMD, ARGC};

    int initTreadmill (void);
    int isInitTreadmill (void);

    int initServer (void);

    QString argvCmd (void) { return m_arArgv [CMD]; }
    QString argvIpServer () { return m_arArgv [IP_SERVER]; }
    QString argvApp () { return m_arArgv [TYPE_APP]; }
    int argvPort (void) { return m_arArgv [PORT_LINK].toInt (); }
    
signals:
    void sgnTreadmillResponse (QString );
    
public slots:
    void onSgnNewConnection (void);
    void onSgnTcpSocketDisconnected (void); //Обработка этого сигнала д. волновать ТОЛЬКО потоК
    void executeCommand (QString = "");
    void onSgnThreadFinished (void);

private:
    QTcpServer  m_tcpSrv;
    HManagementTreadmill *m_pMngntTrdml;
    vector <HThreadTcpSocket *> m_arPtrThreadSocket;
    int m_iServerPort;

    QString m_arArgv [ARGC];

    int parseArgv (QString );
};

#endif // HAPPLICATION_H
