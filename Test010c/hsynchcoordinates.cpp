#include <qdeclarativeitem3d.h>
#include <qgraphicsrotation3d.h>
#include "qmath.h"
#include "hsynchcoordinates.h"

#include <iostream>
using namespace std;

HSynchCoordinates::HSynchCoordinates(QObject *parent) : QObject(parent) {
    m_fltStepsLength = 0, m_fltStepsWidth = 0;

//    УказывАТь значения в 'main.qml'
//    m_fltMarkerSize = 0.21;
//    m_iIdMarkerPSC = 199;

    m_bFixedPSC = false;
}

HSynchCoordinates::~HSynchCoordinates () {
    int i = -1;
    HObjectReality *pObjectReality = NULL;
    QList <QString> keysObjectReality = m_mapObjectReality.keys ();
    for (i = 0; i < keysObjectReality.size (); i ++) {
        pObjectReality = m_mapObjectReality [keysObjectReality.at (i)];
//        delete pObjectReality;

        m_mapObjectReality.remove (keysObjectReality.at (i));
    }
}

HObjectReality *HSynchCoordinates::getObjectReality (QString name) {
    if (! (m_mapObjectReality [name] == NULL)) {
//        printf ("objectReality with name=%s reurn Success!\n", name.data ());
        return m_mapObjectReality [name];
    }
    else {
        cout << "objectReality with name=" << name.toStdString () << " not created!\n" << endl;
    }

    return NULL;
}

void HSynchCoordinates::insertObjectReality (QString name, HObjectReality *obj) {
    if (! (m_mapObjectReality [name] == NULL))
        printf ("objectReality with name=%s HAS created!\n", name.data ());

    m_mapObjectReality.insert (name, obj);
    sgnCreateEntity (name);
}

void HSynchCoordinates::deleteObjectReality (QString name, HObjectReality *obj) {
    if (m_mapObjectReality [name] == NULL)
        printf ("objectReality with name=%s not created!\n", name.data ());

    m_mapObjectReality.remove (name);
    cout << "Remove objectReality from 'm_mapObjectReality' with name=" << name.toStdString () << endl;

    sgnDestroyEntity (name);
}

int HSynchCoordinates::getCountObjectReality (QString subName) {
    int iRes = 0;
    unsigned int i = -1;
    QList <QString> listNameObjectReality;

    if (! subName.isEmpty ()) {
        listNameObjectReality = getListNameObjectReality ();
        i = 0;
        for (i; i < listNameObjectReality.size (); i ++) {
            if (listNameObjectReality.at (i).contains (subName)) {
                iRes ++;
//                Отладка
//                cout << iRes << " - " << listNameObjectReality.at (i).toStdString () << endl;
            }
            else
                ;
        }

//        Отладка
        cout << endl;
    }
    else
        iRes = m_mapObjectReality.size ();

    if (! (iRes == 0))
        return iRes;
    else
        return -1; //Для ПЕРВого прохода при обработке сигнала 'onCount_of_traceChanged'
}

QVector3D HSynchCoordinates::crossCircles (QVector3D camera, QVector3D centerPrev, QVector3D center) {
    QVector3D vec3DRes = QVector3D (0, 0, 0), vec3DRes1, vec3DRes2;
    QPoint C1, C2, P1, P2;
    float R1, R2,
            X, Y, A, B, D, H,
            XDiff = center.x () - centerPrev.x (),
            YDiff = center.y () - centerPrev.y ();

    if ((XDiff == 0) && (YDiff == 0))
        ; //
    else {
        R1 = QVector3D (camera - center).length () - QVector3D (camera - centerPrev).length ();
        R2 = QVector3D (camera - centerPrev).length ();

        D = QVector3D (camera - center).length ();

        B = (sqrtf (R2*R2 - R1*R1) + D*D) / (2 * D);
        A = D - B;
        H = sqrtf (R2*R2 - B*B);

        if (YDiff == 0) {
            C1 = QPoint (camera.x (), camera.z ());
            C2 = QPoint (center.x (), center.z ());
        }
        else
            if (XDiff == 0) {
                C1 = QPoint (camera.y (), camera.z ());
                C2 = QPoint (center.y (), center.z ());
            }
            else
                ;

        X = (C1.x () + (C2.x () - C1.x ())) / (D / A);
        Y = (C1.y () + (C2.y () - C1.y ())) / (D / A);

        P1.setX (X - (Y - C2.y () * H / B));
        P1.setY (Y + (X - C2.x () * H / B));

        P2.setX (X + (Y - C2.y () * H / B));
        P2.setY (Y - (X - C2.x () * H / B));

        if (YDiff == 0) {
            vec3DRes1 = QVector3D (P1.x (), camera.y (), P1.y ());
            vec3DRes2 = QVector3D (P2.x (), camera.y (), P2.y ());

            if (XDiff > 0)
                if ((vec3DRes1.x () - camera.x ()) < 0)
                    vec3DRes = vec3DRes1;
                else
                    if ((vec3DRes2.x () - camera.x ()) < 0)
                        vec3DRes = vec3DRes2;
                    else
                        ;
            else
                if ((vec3DRes1.x () - camera.x ()) > 0)
                    vec3DRes = vec3DRes1;
                else
                    if ((vec3DRes2.x () - camera.x ()) > 0)
                        vec3DRes = vec3DRes2;
                    else
                        ;
        }
        else
            if (XDiff == 0) {
                vec3DRes1 = QVector3D (camera.x (), P1.x (), P1.y ());
                vec3DRes2 = QVector3D (camera.x (), P2.x (), P2.y ());

                if (YDiff > 0)
                    if ((vec3DRes1.y () - camera.y ()) < 0)
                        vec3DRes = vec3DRes1;
                    else
                        if ((vec3DRes2.y () - camera.y ()) < 0)
                            vec3DRes = vec3DRes2;
                        else
                            ;
                else
                    if ((vec3DRes1.y () - camera.y ()) > 0)
                        vec3DRes = vec3DRes1;
                    else
                        if ((vec3DRes2.y () - camera.y ()) > 0)
                            vec3DRes = vec3DRes2;
                        else
                            ;
            }
            else
                ;
    }
//B:=(sqr(R2)-sqr(R1)+sqr(D))/(2*D);
//A:=D-B;
//H:=sqrt(sqr(R2)-sqr(B));

//X:=round(X1+(X2-X1)/(D/A));
//Y:=round(Y1+(Y2-Y1)/(D/A));

//X3:=round(X-(Y-Y2)*H/B);
//Y3:=round(Y+(X-X2)*H/B);
//X4:=round(X+(Y-Y2)*H/B);
//Y4:=round(Y-(X-X2)*H/B);

    return vec3DRes;
}

QVector3D HSynchCoordinates::getValues (QString obj, QString itemManagement) {
    return getObjectReality (obj)->placement (itemManagement)->getSliderValues ();
}

float HSynchCoordinates::getValue (QString obj, QString itemManagement, QString itemAxis) {
    float fltRes = 0.0;

    if (m_mapObjectReality.size ()) {
//        Необходимо проверить на ВАЛИДНОСТь 'itemAxis' (длина=1, НЕ ПУСТая) ???
        if (itemAxis.contains ("X"))
            fltRes = getObjectReality (obj)->placement (itemManagement)->getSliderValues ().x ();
        else
            if (itemAxis.contains ("Y"))
                fltRes = getObjectReality (obj)->placement (itemManagement)->getSliderValues ().y ();
            else
                if (itemAxis.contains ("Z"))
                    fltRes = getObjectReality (obj)->placement (itemManagement)->getSliderValues ().z ();
                else
                    ; //Какая же ОСь в параметре ???
    }
    else
        ;

    return fltRes;
}

void HSynchCoordinates::initValues (QString obj, QString itemManagement, QVector3D vec3DValues) {
    if (m_mapObjectReality.size ())
        getObjectReality (obj)->placement (itemManagement)->setSliderValues (vec3DValues.x (), vec3DValues.y (), vec3DValues.z ());
    else
        ;
}

void HSynchCoordinates::initValue (QString obj, QString itemManagement, QString itemAxis, float val) {
    if (m_mapObjectReality.size ())
        getObjectReality (obj)->placement (itemManagement)->setSliderValue (itemAxis, val);
    else
        ;
}

void HSynchCoordinates::changeValues (QString obj, QString itemManagement, QVector3D vec3DValues) {
    if (m_mapObjectReality.size ()) {
        initValues (obj, itemManagement, getValues (obj, itemManagement) + vec3DValues);
//        m_mapObjectReality [obj]->m_mapPlacement [itemManagement]->calculate ();
    }
    else
        ;
}

void HSynchCoordinates::changeValue (QString obj, QString itemManagement, QString itemAxis, float val) {
    float fltPrevValue = 0.0;
    if (itemAxis.contains ("X"))
        fltPrevValue = getValues (obj, itemManagement).x ();
    else
        if (itemAxis.contains ("Y"))
            fltPrevValue = getValues (obj, itemManagement).y ();
        else
            if (itemAxis.contains ("Z"))
                fltPrevValue = getValues (obj, itemManagement).z ();
            else
                ; //Какая же ОСь в параметре ???

    getObjectReality (obj)->placement (itemManagement)->setSliderValue (itemAxis, fltPrevValue + val);
//    m_mapObjectReality [obj]->m_mapPlacement [itemManagement]->calculate ();

//    cout << obj.toStdString () << ":" << metaObject ()->className () << "::changeValue - Prev=" << fltPrevValue << "Diff=" << val << endl;
}

void HSynchCoordinates::setVisible (QString obj, bool val) {
     getObjectReality (obj)->setVisible (val);
}

void HSynchCoordinates::calculate (QString obj, QString itemManagement, QString itemAxis) {
//    Отдельный расчЁт по ОДНой оси ??? (тем более, что это не расчЁт А КОПИрование)
//    m_mapObjectReality [obj]->m_mapPlacement [itemManagement]->calculate (itemAxis);
    getObjectReality (obj)->placement (itemManagement)->calculate (itemAxis);
}

void HSynchCoordinates::initObjectReality (QObject *obj) {
    int i = -1;
//    QVector3D vec3DPosition;
//    HObjectReality *pObjectReality = NULL;
//    pObjectReality = new HObjectReality ();

////    cout << obj->metaObject ()->className () << endl;

//    if (obj->objectName ().length ()) {
//        m_mapObjectReality.insert (obj->objectName(), pObjectReality);

//        vec3DPosition = ((QDeclarativeItem3D *) obj)->position ();
//        pObjectReality->m_mapPlacement ["position"]->setLimitValues ("X", -10, 10, 0.1);
//        pObjectReality->m_mapPlacement ["position"]->setLimitValues ("Y", -10, 10, 0.1);
//        pObjectReality->m_mapPlacement ["position"]->setLimitValues ("Z", -50, 50, 1);
//        pObjectReality->m_mapPlacement ["position"]->initValues (vec3DPosition.x (), vec3DPosition.y (), vec3DPosition.z ());

//        pObjectReality->m_mapPlacement ["rotation"]->setLimitValues ("X", -180, 180, 5);
//        pObjectReality->m_mapPlacement ["rotation"]->setLimitValues ("Y", -180, 180, 5);
//        pObjectReality->m_mapPlacement ["rotation"]->setLimitValues ("Z", -180, 180, 5);

////        QList <QGraphicsTransform *> listTransformations = ((QDeclarativeItem3D *) obj)->transformations ();
////        cout << listTransformations.count () << endl;

//        QDeclarativeListProperty <QGraphicsTransform3D> listTransform = ((QDeclarativeItem3D *) obj)->transform ();
////        cout << listTransform.count << endl;
//        QGraphicsTransform3D *pTransform3D = ((QGraphicsTransform3D *)listTransform.object)->clone ();
////        QMap <QString, QGraphicsRotation3D> mapRotation3D;
//        QString strClassName;
//        QVector3D vec3DRotation;
//        QObjectList listObject = pTransform3D->children ();
//        for (i = 0; i < listObject.count (); i ++) {
//            strClassName = listObject.at (i)->metaObject ()->className ();
//            if (strClassName.contains ("QGraphicsRotation3D"))
////                Вариант №1 по 'objectName', но ЕГО НЕОБХОДИМО задавать в Qml
////                if (((QGraphicsRotation3D *) listObject.at (i))->objectName ())

////                Вариант №2 по заданным ОСям
//                if (((QGraphicsRotation3D *) listObject.at (i))->axis ().x () == 1)
////                    pObjectReality->m_mapPlacement ["rotation"]->initValue ("X", ((QGraphicsRotation3D *) listObject.at (i))->angle ());
//                    vec3DRotation.setX (((QGraphicsRotation3D *) listObject.at (i))->angle ());
//                else
//                    if (((QGraphicsRotation3D *) listObject.at (i))->axis ().y () == 1)
////                        pObjectReality->m_mapPlacement ["rotation"]->initValue ("Y", ((QGraphicsRotation3D *) listObject.at (i))->angle ());
//                        vec3DRotation.setY (((QGraphicsRotation3D *) listObject.at (i))->angle ());
//                    else
//                        if (((QGraphicsRotation3D *) listObject.at (i))->axis ().z () == 1)
////                            pObjectReality->m_mapPlacement ["rotation"]->initValue ("Z", ((QGraphicsRotation3D *) listObject.at (i))->angle ());
//                            vec3DRotation.setZ (((QGraphicsRotation3D *) listObject.at (i))->angle ());
//                        else
//                            ;
//        }
//        pObjectReality->m_mapPlacement ["rotation"]->initValues (vec3DRotation.x (), vec3DRotation.y (), vec3DRotation.z ());

//        QVector3D vec3DSize;
//        pObjectReality->m_mapPlacement ["size"]->setLimitValues ("X", 0, 10, 0.1);
//        pObjectReality->m_mapPlacement ["size"]->setLimitValues ("Y", 0, 10, 0.1);

//        strClassName = obj->metaObject ()->className ();
//        if (strClassName.contains ("Cylinder")) {
//            pObjectReality->m_mapPlacement ["size"]->setLimitValues ("Z", 0, 50, 1);
//            vec3DSize = QVector3D (((QDeclarativeItem3D *) obj)->property ("radius").toFloat (),
//                                   ((QDeclarativeItem3D *) obj)->property ("radius").toFloat (),
//                                   ((QDeclarativeItem3D *) obj)->property ("length").toFloat ());
//        }
//        else
//            if (strClassName.contains ("QDeclarativeItem3D")) {
//                pObjectReality->m_mapPlacement ["size"]->setLimitValues ("Z", 0, 10, 0.1);
//                vec3DSize = QVector3D (((QDeclarativeItem3D *) obj)->scale (),
//                                       ((QDeclarativeItem3D *) obj)->scale (),
//                                       ((QDeclarativeItem3D *) obj)->scale ());
//            }
//            else
//                ;

//        pObjectReality->m_mapPlacement ["size"]->initValues (vec3DSize.x (), vec3DSize.y (), vec3DSize.z ());
//    }
}
