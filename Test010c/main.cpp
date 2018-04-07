#include <QtDeclarative>
//#include <QGraphicsObject>
//#include <QList>
//#include "QtOpenGL/QGLWidget"
#include "hqdeclarativeviewform.h"

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    HQDeclarativeViewForm viewer;

    qmlRegisterType <QmlCVCapture> ("lib002", 1, 0, "QmlCVCapture");
    qmlRegisterType <HSynchCoordinates> ("lib002", 1, 0, "HSynchCoordinates");
    qmlRegisterType <HManagementSlider> ("lib002", 1, 0, "HManagementSlider");
    qmlRegisterType <HItemManagement> ("lib002", 1, 0, "HItemManagement");
    qmlRegisterType <HObjectReality> ("lib002", 1, 0, "HObjectReality");

    viewer.setSource (QUrl ("main.qml"));
    viewer.setResizeMode(QDeclarativeView::SizeRootObjectToView);

    viewer.init ();

//    HObjectReality *ptrObjectReality = NULL;
//    HControlledVector *ptrContrlledCector = NULL;

//    //ЦЕНТРАЛЬНЫЙ обЪект (CenterPSC)
//    //Память
//    ptrObjectReality = new HObjectReality ();
//    //Инициализация
//    ptrContrlledCector = new HControlledVector (HControlledVector::POINT);
//    ptrContrlledCector->setLimitValues ("X", -2, 2, 0.01);
//    ptrContrlledCector->setLimitValues ("Y", -2, 2, 0.01);
//    ptrContrlledCector->setLimitValues ("Z", -2, 2, 0.01);
//    ptrContrlledCector->initValues (0, 0.1, 0);
////    ptrObjectReality->m_mapPlacement.insert ("position", ptrContrlledCector);

//    ptrContrlledCector = new HControlledVector (HControlledVector::POINT);
//    ptrContrlledCector->setLimitValues ("X", -180, 180, 5);
//    ptrContrlledCector->setLimitValues ("Y", -180, 180, 5);
//    ptrContrlledCector->setLimitValues ("Z", -180, 180, 5);
//    ptrContrlledCector->initValues (0, 0, 0);
////    ptrObjectReality->m_mapPlacement.insert ("rotation", ptrContrlledCector);

//    ptrContrlledCector = new HControlledVector (HControlledVector::POINT);
//    ptrContrlledCector->setLimitValues ("X", 0.1, 6, 0.1);
//    ptrContrlledCector->setLimitValues ("Y", 0.1, 6, 0.1);
//    ptrContrlledCector->setLimitValues ("Z", 0.1, 6, 0.1);
//    ptrContrlledCector->initValues (1.0, 1.0, 1.0);
////    ptrObjectReality->m_mapPlacement.insert ("size", ptrContrlledCector);
//    //Добавление
//    viewer.m_pSynchCoordinates->m_mapObjectReality.insert ("CenterPSC", ptrObjectReality);

//    //1-Ый ВСПОМОГАТЕЛЬНвй обЪект (Trace1)
//    //Память
//    ptrObjectReality = new HObjectReality ();
//    //Инициализация
//    ptrContrlledCector = new HControlledVector (HControlledVector::POINT);
//    ptrContrlledCector->setLimitValues ("X", -2, 2, 0.01);
//    ptrContrlledCector->setLimitValues ("Y", -2, 2, 0.01);
//    ptrContrlledCector->setLimitValues ("Z", -2, 2, 0.01);
//    ptrContrlledCector->initValues (0.2, 0.1, -0.1);
////    ptrObjectReality->m_mapPlacement.insert ("position", ptrContrlledCector);

//    ptrContrlledCector = new HControlledVector (HControlledVector::POINT);
//    ptrContrlledCector->setLimitValues ("X", -180, 180, 5);
//    ptrContrlledCector->setLimitValues ("Y", -180, 180, 5);
//    ptrContrlledCector->setLimitValues ("Z", -180, 180, 5);
//    ptrContrlledCector->initValues (0, 0, 0);
////    ptrObjectReality->m_mapPlacement.insert ("rotation", ptrContrlledCector);

//    ptrContrlledCector = new HControlledVector (HControlledVector::POINT);
//    ptrContrlledCector->setLimitValues ("X", 0.1, 6, 0.1);
//    ptrContrlledCector->setLimitValues ("Y", 0.1, 6, 0.1);
//    ptrContrlledCector->setLimitValues ("Z", 0.1, 6, 0.1);
//    ptrContrlledCector->initValues (1.0, 1.0, 1.0);
////    ptrObjectReality->m_mapPlacement.insert ("size", ptrContrlledCector);
//    //Добавление
//    viewer.m_pSynchCoordinates->m_mapObjectReality.insert ("Trace1", ptrObjectReality);

//    //2-ой ВСПОМОГАТЕЛЬНвй обЪект (Trace2)
//    //Память
//    ptrObjectReality = new HObjectReality ();
//    //Инициализация
//    ptrContrlledCector = new HControlledVector (HControlledVector::POINT);
//    ptrContrlledCector->setLimitValues ("X", -2, 2, 0.01);
//    ptrContrlledCector->setLimitValues ("Y", -2, 2, 0.01);
//    ptrContrlledCector->setLimitValues ("Z", -2, 2, 0.01);
//    ptrContrlledCector->initValues (0.0, 0.1, -0.4);
////    ptrObjectReality->m_mapPlacement.insert ("position", ptrContrlledCector);

//    ptrContrlledCector = new HControlledVector (HControlledVector::POINT);
//    ptrContrlledCector->setLimitValues ("X", -180, 180, 5);
//    ptrContrlledCector->setLimitValues ("Y", -180, 180, 5);
//    ptrContrlledCector->setLimitValues ("Z", -180, 180, 5);
//    ptrContrlledCector->initValues (0, 0, 0);
////    ptrObjectReality->m_mapPlacement.insert ("rotation", ptrContrlledCector);

//    ptrContrlledCector = new HControlledVector (HControlledVector::POINT);
//    ptrContrlledCector->setLimitValues ("X", 0.1, 6, 0.1);
//    ptrContrlledCector->setLimitValues ("Y", 0.1, 6, 0.1);
//    ptrContrlledCector->setLimitValues ("Z", 0.1, 6, 0.1);
//    ptrContrlledCector->initValues (1.0, 1.0, 1.0);
////    ptrObjectReality->m_mapPlacement.insert ("size", ptrContrlledCector);
//    //Добавление
//    viewer.m_pSynchCoordinates->m_mapObjectReality.insert ("Trace2", ptrObjectReality);

//    //3-ий ВСПОМОГАТЕЛЬНвй обЪект (Trace3)
//    //Память
//    ptrObjectReality = new HObjectReality ();
//    //Инициализация
//    ptrContrlledCector = new HControlledVector (HControlledVector::POINT);
//    ptrContrlledCector->setLimitValues ("X", -2, 2, 0.01);
//    ptrContrlledCector->setLimitValues ("Y", -2, 2, 0.01);
//    ptrContrlledCector->setLimitValues ("Z", -2, 2, 0.01);
//    ptrContrlledCector->initValues (0.4, 0.1, -0.4);
////    ptrObjectReality->m_mapPlacement.insert ("position", ptrContrlledCector);

//    ptrContrlledCector = new HControlledVector (HControlledVector::POINT);
//    ptrContrlledCector->setLimitValues ("X", -180, 180, 5);
//    ptrContrlledCector->setLimitValues ("Y", -180, 180, 5);
//    ptrContrlledCector->setLimitValues ("Z", -180, 180, 5);
//    ptrContrlledCector->initValues (0, 0, 0);
////    ptrObjectReality->m_mapPlacement.insert ("rotation", ptrContrlledCector);

//    ptrContrlledCector = new HControlledVector (HControlledVector::POINT);
//    ptrContrlledCector->setLimitValues ("X", 0.1, 6, 0.1);
//    ptrContrlledCector->setLimitValues ("Y", 0.1, 6, 0.1);
//    ptrContrlledCector->setLimitValues ("Z", 0.1, 6, 0.1);
//    ptrContrlledCector->initValues (1.0, 1.0, 1.0);
////    ptrObjectReality->m_mapPlacement.insert ("size", ptrContrlledCector);
//    //Добавление
//    viewer.m_pSynchCoordinates->m_mapObjectReality.insert ("Trace3", ptrObjectReality);

    viewer.setAttribute (Qt::WA_OpaquePaintEvent);
    viewer.setAttribute (Qt::WA_NoSystemBackground);
//    viewer.viewport ()->setAttribute (Qt::WA_OpaquePaintEvent);
//    viewer.viewport ()->setAttribute (Qt::WA_NoSystemBackground);

    viewer.show();
    return app.exec();
}
