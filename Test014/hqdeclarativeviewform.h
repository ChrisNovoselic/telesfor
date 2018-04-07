#ifndef HQDECLARATIVEVIEWFORM_H
#define HQDECLARATIVEVIEWFORM_H

#pragma once

#include <QDeclarativeView>
#include <QDeclarativeContext>
#include <QSlider>

#include <opencv/highgui.h>

#include "HQmlCVCapture.h"
#include "hmanagementtreadmill.h"
#include "hmanagementslider.h"
#include "hsynchcoordinates.h"
#include "htrainingdescitem.h"

#define MAX_COUNT_CAMERA 2

class HQDeclarativeViewForm : public QDeclarativeView
{
    Q_OBJECT
public:
    explicit HQDeclarativeViewForm (QDeclarativeView * = 0);
    ~HQDeclarativeViewForm ();

    void init ();

    QMap <QString, QmlCVCapture *> m_mapQmlCVCapture;
    QMap <QString, QSlider *> m_mapQmlSlider; //Список ВСЕх "Slider-ов"- обЪект-ов
    QList <cv::VideoCapture *> m_listptrVideoCapture;
//    QMap <QString, HManagementSlider *> m_mapManagementSlider;
    HSynchCoordinates *m_pSynchCoordinates;

public slots:
    void onSgnRecoverySliderValueObject (QString , QString);
    void onSgnReplacmentObject (QString , QString );
    void onSgnManagementTreadmill (QString );
    void onSgnQueryPulse (QString );

    void onSgnTrainingStart (double , double, double );
    void onSgnTrainingChange (QString , double );
    void onSgnTrainingStop ();

    void onSgnDebugRepositionObject (QString , QString );

    void onSgnIsCreateObjectReality (QString , int );

    void onSgnTrainingReport (QString , QString , QString );

signals:
    void sgnPulseTreadmill (QVariant data);

protected:

private:
    Ogre::Root *m_OgreRoot;
    HManagementTreadmill m_ManagementTreadmill;
    HTrainingDesc m_TrainingDesc;

    Ogre::String m_strOgrePluginsCfg;
    Ogre::String m_strRenderSystemCfg;
    Ogre::String m_strOgreResourcesCfg;

    int initOgre (void);
    int initRenderSystem (void);
    int loadResources (void);

    void releaseOgre (void);

    void coutQmlObjectInfo (int , QObject *);
};

#endif // HQDECLARATIVEVIEWFORM_H
