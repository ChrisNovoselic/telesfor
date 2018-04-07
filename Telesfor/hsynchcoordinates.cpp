#include <qdeclarativeitem3d.h>
#include <qgraphicsrotation3d.h>
#include "qmath.h"
#include "hsynchcoordinates.h"

#include <iostream>
using namespace std;

HSynchCoordinates::HSynchCoordinates (QObject *parent) : QObject(parent) {
//    m_fltStepsLength = 0, m_fltStepsWidth = 0;

//    УказывАТь значения в 'main.qml'
//    m_fltMarkerSize = 0.21;
//    m_iIdMarkerPSC = 199;

//    m_bFixedPSC = false;

    m_iCountOfTrace = 6; //getCountOfTrace ();
    m_shStaticCountOfTrace = 2 * 2; //К каждому следу, как известно, прикреплЁн 'Pole'

//    Внешние значения состояния кнопок 'checked' для След№1(№2)
    m_arExternVisibleTrace [0] = false, m_arExternVisibleTrace [1] = false;

    QObject::connect (this, SIGNAL (sgnStepsLengthChanged (float)), this, SLOT (onSgnStepsLengthChanged (float)));
//    cout << "HSynchCoordinates::HSynchCoordinates::m_shDirectionTrack = " << m_shDirectionTrack << endl;
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

void HSynchCoordinates::deleteObjectReality (QString name) {
    if (m_mapObjectReality [name] == NULL)
        cout << "objectReality with name=" << name.toStdString () << " not created!\n" << endl;

    delete m_mapObjectReality [name];

    m_mapObjectReality.remove (name);
    cout << "Remove objectReality from 'm_mapObjectReality' with name=" << name.toStdString () << endl;

    sgnDestroyEntity (name);
}

//void HSynchCoordinates::deleteObjectReality (QString name, HObjectReality *obj) {
//    if (m_mapObjectReality [name] == NULL)
//        printf ("objectReality with name=%s not created!\n", name.data ());

//    m_mapObjectReality.remove (name);
//    cout << "Remove objectReality from 'm_mapObjectReality' with name=" << name.toStdString () << endl;

//    sgnDestroyEntity (name);
//}

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
    QVector3D vec3DSliderValues;

    if (m_mapObjectReality.size ()) {
//        Необходимо проверить на ВАЛИДНОСТь 'itemAxis' (длина=1, НЕ ПУСТая) ???
        vec3DSliderValues = getObjectReality (obj)->placement (itemManagement)->getSliderValues ();
        if (itemAxis.contains ("X"))
            fltRes = vec3DSliderValues.x ();
        else
            if (itemAxis.contains ("Y"))
                fltRes = vec3DSliderValues.y ();
            else
                if (itemAxis.contains ("Z"))
                    fltRes = vec3DSliderValues.z ();
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

float HSynchCoordinates::changeValue (QString obj, QString itemManagement, QString itemAxis, float val) {
    float fltPrevValue = 0.0, fltNewVal = -1.0;
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

    fltNewVal = fltPrevValue + val;
    getObjectReality (obj)->placement (itemManagement)->setSliderValue (itemAxis, fltNewVal);
//    m_mapObjectReality [obj]->m_mapPlacement [itemManagement]->calculate ();

//    cout << obj.toStdString () << ":" << metaObject ()->className () << "::changeValue - Prev=" << fltPrevValue << "Diff=" << val << endl;
    return fltNewVal;
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

void HSynchCoordinates::onSgnSetPlacementsMovable (QString nameObject) {
    QVector3D vec3DPlacementPosition;
    QString namePrefix;
    short shNumberObject = 0, numRow = 0;

//    УдобнО извлекать обЪекты по 'objectName' вызовом 'getObjectReality', НО ДОЛГо
//    НЕ удобНО пройти ОДИН раз по списку, находя при этом необходимые, НО БЫСТРей

//    for (int i = 0; i < m_iCountOfTrace; i ++) {
//        pObject = m_mapObjectReality [nameObject];

        namePrefix = "Trace";
        if (nameObject.contains (namePrefix) == true) {
            shNumberObject = nameObject.right (nameObject.length () - namePrefix.length ()).toShort ();
        }
        else {
            namePrefix = "Pole";
            if (nameObject.contains (namePrefix) == true) {
                shNumberObject = nameObject.right (nameObject.length () - namePrefix.length ()).toShort ();
            }
            else
                ; //ТолькО 'Trace#' и 'Pole#' movable objectReality
        }

        vec3DPlacementPosition = getPositionTrace (shNumberObject);

//        ЕщЁ небольШОе уточнение для 'Pole'
        namePrefix = "Pole";
        if (nameObject.contains (namePrefix) == true) {
            vec3DPlacementPosition.setZ (vec3DPlacementPosition.z () - (0.02754 / 2 + 0.02754 / 4));
        }
        else
            ;

        initValues (nameObject, "position", vec3DPlacementPosition);

        m_shStaticCountOfTrace --;

        cout << "HSynchCoordinates::onSgnSetPlacementsMovable для " << nameObject.toStdString () << ":(" << vec3DPlacementPosition.x () << ";" <<
                                                                                                            vec3DPlacementPosition.y () << ";" <<
                                                                                                            vec3DPlacementPosition.z () << ")" << endl;

        if (m_shStaticCountOfTrace == 0) {
//            КРАЙнемУ статическомУ обЪектУ (САМый ВЕРХний в 'qml') присвоенЫ ВСЕ значения
//            Время присвоить ЗНАЧения для динамически созданных
            int i, j;

            m_iCountOfTrace = getCountOfTrace ();

            QStringList strListPrefix; strListPrefix.append ("Trace"); strListPrefix.append ("Pole");
            for (i = 2 + 1; i < m_iCountOfTrace + 1; i ++) { //ВСЕГо 2 статических обЪекта
                for (j = 0; j < strListPrefix.length (); j ++) {
                    namePrefix = strListPrefix.at (j);
                    if (m_mapObjectReality [namePrefix + QString::number (i)] == NULL)
//                        pObject = new HObjectReality ();
                        emit sgnCreateObjectReality (namePrefix, i);
                    else
                        ;
                }
            }
        }
        else
            ;
//    }
}

void HSynchCoordinates::onSgnIsCreateObjectReality (HObjectReality *pObject, QString namePrefix, int num) {
//    HObjectReality *pObject = NULL;
    HObjectReality *pObjectTemplate = NULL;
    QVector3D vec3DPlacementPosition;
    int a, b, c;

    pObjectTemplate = m_mapObjectReality [namePrefix +  QString::number ((2 - (num % 2)))];

    pObject->setOpacity (pObjectTemplate->opacity ());
    pObject->setVisible (pObjectTemplate->visible ());
    pObject->setSourceEntity (pObjectTemplate->sourceEntity ());

    QStringList strListNamePlacement; strListNamePlacement.append ("position"); strListNamePlacement.append ("rotation"); strListNamePlacement.append ("size");
    QStringList strListNameAxis; strListNameAxis.append ("X"); strListNameAxis.append ("Y"); strListNameAxis.append ("Z");
    for (a = 0; a < strListNamePlacement.count (); a ++) {
        HManagementItem *pManagementItem = pObject->placement (strListNamePlacement.at (a));
        HManagementItem *pManagementItemTemplate = pObjectTemplate->placement (strListNamePlacement.at (a));
//                        QList <HManagementSlider *> pManagementSliders = pItemsManagement.at (a)
//                        pItemManagement = pItemsManagement.at (a);
        for (b = 0; b < strListNameAxis.count (); b ++) {
            HManagementSlider *pManagementSlider = pManagementItem->sliderParamsAxis (strListNameAxis.at (b));
            HManagementSlider *pManagementSliderTemplate = pManagementItemTemplate->sliderParamsAxis (strListNameAxis.at (b));

            pManagementSlider->setSliderValue (pManagementSliderTemplate->sliderValue ());
            if ((strListNameAxis.at (b).contains ("X") == true) && (strListNamePlacement.at (a).contains ("position") == true))
                pManagementSlider->setSliderValue (pManagementSlider->sliderValue () + m_shDirectionTrack * floor ((num - 1) / 2) * 2 * m_fltStepsLength * m_fltCoeffStepsLength);
            else
                ;

            pManagementSlider->setMinValue (pManagementSliderTemplate->minValue ());
            pManagementSlider->setMaxValue (pManagementSliderTemplate->maxValue ());
            pManagementSlider->setStepValue (pManagementSliderTemplate->stepValue ());
        }
    }

    vec3DPlacementPosition = pObject->placement ("size")->getSliderValues ();
    cout << metaObject ()->className () << "::onSgnIsCreateObjectReality для " << (namePrefix + QString::number (num)).toStdString () << ":(" << vec3DPlacementPosition.x () << ";" <<
                                                                                                        vec3DPlacementPosition.y () << ";" <<
                                                                                                        vec3DPlacementPosition.z () << ") " << floor ((num - 1) / 2) << endl;

    insertObjectReality (namePrefix +  QString::number (num), pObject);
}

QVector3D HSynchCoordinates::getPositionTrace (short num) {
    QVector3D vec3DRes;

    vec3DRes.setX (m_fltBeginPositionTrace + m_shDirectionTrack * (num - 1) * m_fltStepsLength * m_fltCoeffStepsLength);

//    vec3DRes.y = m_synchCoordinates.szMarkerPSC / 2
    vec3DRes.setY (0);
//    vec3DRes.y = -m_synchCoordinates.szMarkerPSC / 2

    vec3DRes.setZ (getNumberLine (num) * m_fltStepsWidth + m_fltMarkerSize / 2);

    return vec3DRes;
}

short HSynchCoordinates::getNumberLine (short numObject) {
    short retNumber = -1;

    switch (m_iCountLine) {
        case 1:
            retNumber = 0;
            break;
        case 2:
            if ((numObject % 2) == 0)
                retNumber = 1; //ЧЁтные следы отдаляем от неЧЁтных на величинУ 'БАЗа ШАГа'
            else
                retNumber = 0;
            break;
        default:
            break;
    }

    return retNumber;
}

void HSynchCoordinates::onSgnSetVisibleObjectReality (QString prefix, int num, bool val) {
    if (prefix.contains ("Trace") == true) {
        m_arExternVisibleTrace [2 - (num % 2) - 1] = val;

        QString nameManagementItem = "position", axisDirection = "X";
        bool visible = false;

        for (int i = num; i < (m_iCountOfTrace + 1); i += 2) {
            float posAxisDirection = getValue (prefix + QString::number (i), nameManagementItem, axisDirection),
                min = m_fltBeginPositionTrack, max = m_fltBeginPositionTrack;

            if (m_shDirectionTrack > 0) {
                max += m_shDirectionTrack * m_fltLengthTrack;
            }
            else
                min += m_shDirectionTrack * m_fltLengthTrack;

            if ((posAxisDirection < min) || (posAxisDirection > max)) {
                visible = false;

//                return ;
            }
            else {
//                if (parseInt(obj.substr (5, obj.length - 5)) % 2 === 1) {
                if (num % 2 == 1) {
                    if (val)
                        visible = true;
                    else
                        visible = false;
                }
                else {
                    if (val)
                        visible = true;
                    else
                        visible = false;
                }
            }

            m_mapObjectReality [prefix + QString::number (i)]->setVisible (visible);
            m_mapObjectReality ["Pole" + QString::number (i)]->setVisible (visible);
        }
    }
    else
        m_mapObjectReality [prefix + QString::number (num)]->setVisible (val);
}

void HSynchCoordinates::onSgnMotionTrace (void) {
    QString objTrace, objPole,
            nameManagementItem = "position", axisDirection = "X";
    int i, indxPrevTrace, indxNextTrace, indxBeginObj = -1;
//    float fltLimPos = m_shDirectionTrack * m_iCountOfTrace * m_fltStepsLength * m_fltCoeffStepsLength + m_fltBeginPositionTrace;
    for (i = 1; i < (m_iCountOfTrace + 1); i ++) {
        objTrace = "Trace" + QString::number (i);
        objPole = "Pole" + QString::number (i);
        initValue (objPole, nameManagementItem, axisDirection, changeValue (objTrace, nameManagementItem, axisDirection,
                                                                            m_shDirectionTrack * m_fltSpeedTrack * m_fltCoeffSpeedTrack));

//        if (Math.abs () === paramTrackSpeed.val.value)
//            console.debug ("ОШИБКА КООРДИНАТ!")

//        if ((getValue (objTrace, nameManagementItem, axisDirection) - fltLimPos) < 0) {
        if (abs (getValue (objTrace, nameManagementItem, axisDirection) - m_fltBeginPositionTrace) > m_iCountOfTrace * m_fltStepsLength * m_fltCoeffStepsLength) {
//            cout << "Cлед №" << i << "из" << getValue (objTrace, nameManagementItem, axisDirection) << "в" << m_fltBeginPositionTrace << endl;
//                 << "(fltLimPos = " << fltLimPos << ")" << endl;

            initValue (objTrace, nameManagementItem, axisDirection, m_fltBeginPositionTrace);
            initValue (objPole, nameManagementItem, axisDirection, m_fltBeginPositionTrace);

            indxBeginObj = i;

            //Здесь исследуем расстояниЕ между следами - оказалось, что РАЗНИЦа ИЗМЕНяется
            //поЭТОму прекратим выполнение

            break;

//            indxPrevTrace = i;

//            indxNextTrace = i + 1;
//            if (indxNextTrace > m_iCountOfTrace)
//                indxNextTrace = 1;
//            else
//                ;

//            console.debug ("Между следами", indxPrevTrace, indxNexrTrace, m_synchCoordinates.getValue ("Trace" + indxNexrTrace, itemManagement, axisDirection) - m_synchCoordinates.getValue ("Trace" + indxPrevTrace, itemManagement, axisDirection))
        }
        else {
        }

        if (i % 2 == 1)
            onSgnSetVisibleObjectReality ("Trace", i, m_arExternVisibleTrace [2 - (i % 2) - 1]);
        else
            if (i % 2 == 0)
                onSgnSetVisibleObjectReality ("Trace", i, m_arExternVisibleTrace [2 - (i % 2) - 1]);
            else
                ;
    }

    if (indxBeginObj > -1) { //Выравнивание
        setTracesPlacement (indxBeginObj);
    }
    else
        ;
}

int HSynchCoordinates::getCountOfTrace () {
    short cntRequired = -1;
//    cntRequired = floor ((m_fltLengthTrack + 2 * m_fltSpeedTrack + abs (m_fltBeginPositionTrace - m_fltBeginPositionTrack)) / m_fltSpeedTrack);
    cntRequired = floor ((m_fltLengthTrack + 2 * m_fltStepsLength * m_fltCoeffStepsLength + abs (m_fltBeginPositionTrace - m_fltBeginPositionTrack)) / m_fltStepsLength * m_fltCoeffStepsLength);
    if (cntRequired % 2 == 1)
        cntRequired ++;
    else
        ;

    cout << "Количество следов (НАДО): " << cntRequired << endl;

    return cntRequired;
}

HObjectReality *HSynchCoordinates::createObjectReality (int num, TYPE_OBJECTREALITY type) {
}

void HSynchCoordinates::onSgnStepsLengthChanged (float val) {
//    printf ("HSynchCoordinates::onSgnStepsLengthChanged = %f.3\n", val);

    //ОТЛАДКа
    cout << "Количество objectReality (В НАЛИЧИИ): " << getCountObjectReality () << endl;

    if (getCountObjectReality () > 0) {
        m_iCountOfTrace = getCountOfTrace ();

        //Удалить ЛИШНие (создать необходимые)
        QString name, prefixName = "Trace";
        int i, countOfTrace = getCountObjectReality (prefixName);
        HObjectReality *obj = NULL;

        int indexMaxValue, numLeadingTrace;
        float posMaxValue;

        indexMaxValue = getNumTraceOfMaxPosition ();
        cout << "indexMaxValue=" << indexMaxValue << endl;

        if (getObjectReality ("Trace", indexMaxValue)) {
            posMaxValue = getObjectReality ("Trace", indexMaxValue)->placement ("position")->sliderParamsAxis ("X")->sliderValue ();
            cout << "posMaxValue=" << posMaxValue << endl;
        }
        else
            ;

        numLeadingTrace = indexMaxValue;

        if (countOfTrace > -1) {
            if (! (m_iCountOfTrace == countOfTrace)) {
                if (m_iCountOfTrace > countOfTrace) {
                    //Создать необходимые
                    cout << "Создать необходимые: " << m_iCountOfTrace - countOfTrace << endl;
                    for (i = countOfTrace + 1; i < (m_iCountOfTrace + 1); i ++) {
//                        ДобАвлЯеМ следЫ
                        emit sgnCreateObjectReality ("Trace", i);

//                        Добавляем КОЛы
                        emit sgnCreateObjectReality ("Pole", i);
                    }
                }
                else {
                    //Удалить ЛИШНие
                    //Перед удалениеим ПРОВЕРить - не потеряем ли позицию следа
                    if (indexMaxValue > m_iCountOfTrace) {
                        //С удаление следа - ПОТЕРяем ЕГо ПОЗицию
                        if (indexMaxValue % 2 == 1) {
                            numLeadingTrace = 1;
                        }
                        else {
                            numLeadingTrace = m_iCountOfTrace;
                        }
                    }
                    else
                        ; //НиЧЕГо не делаем - ПОТЕРь позиции СЛЕДа НЕТ

                    cout << "Удалить ЛИШНие: " << countOfTrace - m_iCountOfTrace << endl;
                    for (i = m_iCountOfTrace + 1; i < (countOfTrace + 1); i ++) {
//                        УдАлЯеМ следЫ
                        deleteObjectReality ("Trace" + QString::number (i));

//                        УдАлЯеМ  КОЛы
                        deleteObjectReality ("Pole" + QString::number (i));
                    }

                    initValue (prefixName + QString::number (numLeadingTrace), "position", "X", m_fltBeginPositionTrace);
                    initValue ("Pole" + QString::number (numLeadingTrace), "position", "X", m_fltBeginPositionTrace);

//                    QList <QString> keysObjectReality = m_mapObjectReality.keys ();
//                    int num = -1;
//                    for (i = 0; i < keysObjectReality.size (); i ++) {
//                        name = keysObjectReality [i];

//                        prefixName = "Trace";
//                        if (name.indexOf (prefixName) > -1) {
//                            num = name.mid (prefixName.length (), name.length () - prefixName.length ()).toInt ();
//                            if (num > m_iCountOfTrace) {
//                                obj = m_mapObjectReality [keysObjectReality.at (i)];
//                                deleteObjectReality (name, obj); //??? Достаточно ОДНогО именИ
//                            }
//                            else
//                                ;
//                        }
//                        else {
//                            prefixName = "Pole";
//                            if (name.indexOf (prefixName) > -1) {
//                                num = name.mid (prefixName.length (), name.length () - prefixName.length ()).toInt ();
//                                if (num > m_iCountOfTrace) {
//                                    obj = m_mapObjectReality [keysObjectReality.at (i)];
//                                    deleteObjectReality (name, obj); //??? Достаточно ОДНогО именИ
//                                }
//                                else
//                                    ;
//                            }
//                            else
//                                ;
//                        }
//                    }
                }
            }
            else
                ; //Кол-во НЕОБХодиМЫх следов == В НАЛИчИИ

            setTracesPlacement (numLeadingTrace);
        }
        else
            ; //Количество следов МЕНьШе 0
    }
    else
        ; //Нет НИ ОДНого обЪектА РР
}

int HSynchCoordinates::getNumTraceOfMinPosition (void) {
    QString axisDirection = "X", nameManagementItem = "position", prefixName = "Trace", obj;
    int i, iRes = 1, countTrace = getCountObjectReality (prefixName);
    float minValue = -1.0;
    for (i = 1; i <= countTrace; i ++) {
        obj = prefixName + QString::number (i);

        if (i > 1)
            if (minValue > getValue (obj, nameManagementItem, axisDirection)) {
                minValue = getValue (obj, nameManagementItem, axisDirection);
                iRes = i;
            }
            else
                ;
        else
            minValue = getValue (obj, nameManagementItem, axisDirection);
    }

    return iRes;
}

int HSynchCoordinates::getNumTraceOfMaxPosition (void) {
    QString axisDirection = "X", nameManagementItem = "position", prefixName = "Trace", obj;
    int i, iRes = 1, countTrace = getCountObjectReality (prefixName);
    float maxValue = -1.0, fltCurrentValue = -1.0;
    for (i = 1; i <= countTrace; i ++) {
        obj = prefixName + QString::number (i);
        fltCurrentValue = getValue (obj, nameManagementItem, axisDirection);

        cout << obj.toStdString () << " " <<
                nameManagementItem.toStdString () << " " <<
                axisDirection.toStdString () << " = " << fltCurrentValue << endl;

        if (i > 1)
            if (maxValue < fltCurrentValue) {
                maxValue = fltCurrentValue;
                iRes = i;
            }
            else
                ;
        else
            maxValue = fltCurrentValue;
    }

    return iRes;
}


void HSynchCoordinates::setTracesPlacement (int indexMaxValue) {
    QString axisDirection = "X", nameManagementItem = "position";
//    HObjectReality *objTrace = NULL, *objPole = NULL;
    int i = -1, indexTrace = indexMaxValue; //, countOfTrace = getCountOfTrace (); //, indexMaxValue = -1;
    float posMaxValue;

//    cout << "HSynchCoordinates::setTracesPlacement () indexMaxValue = " << indexMaxValue << endl;

//    indexMaxValue = getNumTraceOfMaxPosition ();
//    posMaxValue = descObjectsReality.getObjectReality ("Trace", indexMaxValue).placements [0].sliders [0].sliderValue из 'Qml'
    posMaxValue = getObjectReality ("Trace", indexMaxValue)->placement (nameManagementItem)->sliderParamsAxis (axisDirection)->sliderValue ();

//    for (i = 1; i < countOfTrace; i ++) {
    for (i = 1; i < m_iCountOfTrace; i ++) {
        indexTrace ++;
        if (indexTrace > m_iCountOfTrace)
            indexTrace = 1;

        initValue ("Trace" + QString::number (i), nameManagementItem, axisDirection, posMaxValue - (i - indexMaxValue) * m_shDirectionTrack * m_fltStepsLength * m_fltCoeffStepsLength);

        initValue ("Pole" + QString::number (i), nameManagementItem, axisDirection, posMaxValue - (i - indexMaxValue) * m_shDirectionTrack * m_fltStepsLength * m_fltCoeffStepsLength);

        if (i % 2 == 1)
            onSgnSetVisibleObjectReality ("Trace", i, m_arExternVisibleTrace [2 - (i % 2) - 1]);
        else
            if (i % 2 == 0)
                onSgnSetVisibleObjectReality ("Trace", i, m_arExternVisibleTrace [2 - (i % 2) - 1]);
            else
                ;
    }
}

void HSynchCoordinates::setDirectionTrack (const int &d) {
    m_shDirectionTrack = d;
    cout << "HSynchCoordinates::setDirectionTrack::m_shDirectionTrack = " << m_shDirectionTrack << endl;
}
