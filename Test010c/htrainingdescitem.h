#ifndef HTRAININGDESCITEM_H
#define HTRAININGDESCITEM_H

#include <QObject>
#include <vector>

#include <QDateTime>

class HTrainingDescItem : public QObject {
    Q_OBJECT
public:
    explicit HTrainingDescItem (QObject *parent = 0);
    ~ HTrainingDescItem ();
    
signals:
    
public slots:

private:
    QDateTime m_dtBegin, m_dtEnd;
    float m_fltTrackSpeed;
    int m_iTrackTilt;
    float m_fltStepsLength;
};

class HTrainingDesc : public QObject {
    Q_OBJECT
public:
    explicit HTrainingDesc (QObject *parent = 0);
    ~HTrainingDesc ();

    int start (float , int, float );
    int addItem (float , int, float );
    void stop ();

signals:

public slots:

private:
    std::vector <HTrainingDescItem> m_vecTrainingItems;
};

#endif // HTRAININGDESCITEM_H
