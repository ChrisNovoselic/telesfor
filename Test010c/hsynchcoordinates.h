#ifndef HSYNCHCOORDINATES_H
#define HSYNCHCOORDINATES_H

#include <QObject>
#include <QVector3D>
#include "hobjectreality.h"
#include "hmat.h"

class HSynchCoordinates : public QObject
{
    Q_OBJECT

    Q_PROPERTY (int idMarkerPSC READ idMarkerPSC WRITE setIdMarkerPSC)
    Q_PROPERTY (float szMarkerPSC READ szMarkerPSC WRITE setSizeMarkerPSC)
public:
    explicit HSynchCoordinates(QObject *parent = 0);
    ~HSynchCoordinates();

    static QVector3D crossCircles (QVector3D , QVector3D, QVector3D);

    QList <QString> getListNameObjectReality (void) { return m_mapObjectReality.keys (); }

    int idMarkerPSC (void) const { return m_iIdMarkerPSC; }
//    void setIdMarkerPSC (const int &id) { m_iIdMarkerPSC = id; }
    float szMarkerPSC (void) const { return m_fltMarkerSize; }
//    void setSizeMarkerPSC (const float &sz) { m_fltMarkerSize = sz; }

signals:
    void sgnCreateEntity (QString);
    void sgnDestroyEntity (QString);
    
public slots:
    HObjectReality *getObjectReality (QString);
    void insertObjectReality (QString, HObjectReality *);
    void deleteObjectReality (QString, HObjectReality *);

    QVector3D getValues (QString , QString );
    float getValue (QString , QString , QString );
    void initValues (QString , QString , QVector3D);
    void initValue (QString , QString , QString , float);
    void changeValues (QString , QString , QVector3D);
    void changeValue (QString , QString , QString , float);
    bool visible (QString obj) { return getObjectReality (obj)->visible (); }
    void setVisible (QString, bool);
    void calculate (QString , QString , QString = "");

    void initObjectReality (QObject *);
    int getCountObjectReality (QString = "");

    void setStepsLength (float val) { m_fltStepsLength = val; }
    void setStepsWidth (float val) { m_fltStepsWidth = val; }

    void setIdMarkerPSC (const int &id) { m_iIdMarkerPSC = id; }
    int getIdMarkerPSC (void) const { return m_iIdMarkerPSC; }
    void setSizeMarkerPSC (const float &val) { m_fltMarkerSize = val; }
//    void setMarkerSize (int id, float val) { m_fltMarkerSize = val; }
//    float getMarkerSize (void) { return m_fltMarkerSize; }
//    float getMarkerSize (int id) { return m_fltMarkerSize; }

    void fixedPSC (bool val) { m_bFixedPSC = val; }
    bool getFixededPSC (void) { return m_bFixedPSC; }

private:
    QMap <QString, HObjectReality *> m_mapObjectReality;
    int m_iIdMarkerPSC; //ID маркера - ЦЕНТРа ФСК
    float m_fltMarkerSize; //Размер маркера в метрах
    float m_fltStepsLength, m_fltStepsWidth;
    bool m_bFixedPSC; //Зафиксирована ли ФСК

//    HMat m_hmat;
};

#endif // HSYNCHCOORDINATES_H
