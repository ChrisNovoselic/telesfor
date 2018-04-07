#ifndef HTHREADCVCAPTURE_H
#define HTHREADCVCAPTURE_H

#include <QThread>

class HThreadCVCapture : public QThread
{
    Q_OBJECT
public:
    explicit HThreadCVCapture(QObject *parent = 0);
    
signals:
    
public slots:
    
};

#endif // HTHREADCVCAPTURE_H
