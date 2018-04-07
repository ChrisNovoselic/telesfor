#include "hobjectreality.h"

#include <iostream>
using namespace std;

HObjectReality::HObjectReality (QObject *parent) : QObject (parent)
{
//    HControlledVector *pControlledVector = NULL;
//    //1-ая точка для управления обЪектом
//    pControlledVector = new HControlledVector (HControlledVector::POINT);
//    pControlledVector->setLimitValues("X", -1, 1, 0.1);
//    pControlledVector->setLimitValues("Y", -1, 1, 0.1);
//    pControlledVector->setLimitValues("Z", -1, 1, 0.1);
//    pControlledVector->initValues (0, 0, 0);
//    m_mapPlacement.insert ("position", pControlledVector);

//    //2-ая точка для управления обЪектом
//    pControlledVector = new HControlledVector (HControlledVector::POINT);
//    pControlledVector->setLimitValues("X", -1, 1, 0.1);
//    pControlledVector->setLimitValues("Y", -1, 1, 0.1);
//    pControlledVector->setLimitValues("Z", -1, 1, 0.1);
//    pControlledVector->initValues (0, 0, 0);
//    m_mapPlacement.insert ("rotation", pControlledVector);

//    //3-я точка для управления обЪектом
//    pControlledVector = new HControlledVector (HControlledVector::POINT);
//    pControlledVector->setLimitValues("X", -1, 1, 0.1);
//    pControlledVector->setLimitValues("Y", -1, 1, 0.1);
//    pControlledVector->setLimitValues("Z", -1, 1, 0.1);
//    pControlledVector->initValues (0, 0, 0);
//    m_mapPlacement.insert ("size", pControlledVector);
}

HObjectReality::~HObjectReality () {
    cout << "Деструктор 'HObjectReality': " << objectName ().toStdString () << endl;
//    HControlledVector *pControlledVector = NULL;
//    QList <QString> keysMapPosition = m_mapPlacement.keys ();
//    for (i = 0; i < keysMapPosition.size (); i ++) {
//        pControlledVector = m_mapPlacement [keysMapPosition.at (i)];
//        delete pControlledVector;

//        m_mapPlacement.remove (keysMapPosition.at (i));
//    }
}

//HManagementItem HObjectReality::position () const {
//    HManagementItem res;

//    res.vec3Dvalue = m_mapPlacement ["position"]->getOutValues ();
//    m_mapPlacement ["position"]->getLimitValues ("X", &res.limitX.minimum, &res.limitX.maximum, &res.limitX.step);
//    m_mapPlacement ["position"]->getLimitValues ("Y", &res.limitY.minimum, &res.limitY.maximum, &res.limitY.step);
//    m_mapPlacement ["position"]->getLimitValues ("Z", &res.limitZ.minimum, &res.limitZ.maximum, &res.limitZ.step);

//    return res;
//}

//void HObjectReality::setPosition (const HManagementItem &value) {
//    m_mapPlacement ["position"]->setLimitValues ("X", value.limitX.minimum, value.limitX.maximum, value.limitX.step);
//    m_mapPlacement ["position"]->setLimitValues ("Y", value.limitY.minimum, value.limitY.maximum, value.limitY.step);
//    m_mapPlacement ["position"]->setLimitValues ("Z", value.limitZ.minimum, value.limitZ.maximum, value.limitZ.step);
//    m_mapPlacement ["position"]->initValues (value.vec3Dvalue.x (), value.vec3Dvalue.y (), value.vec3Dvalue.z ());
//    m_mapPlacement ["position"]->calculate ();
//}

//HManagementItem HObjectReality::rotation () const {
//    HManagementItem res;

//    res.vec3Dvalue = m_mapPlacement ["rotation"]->getOutValues ();
//    m_mapPlacement ["rotation"]->getLimitValues ("X", &res.limitX.minimum, &res.limitX.maximum, &res.limitX.step);
//    m_mapPlacement ["rotation"]->getLimitValues ("Y", &res.limitY.minimum, &res.limitY.maximum, &res.limitY.step);
//    m_mapPlacement ["rotation"]->getLimitValues ("Z", &res.limitZ.minimum, &res.limitZ.maximum, &res.limitZ.step);

//    return res;
//}

//void HObjectReality::setRotation (const HManagementItem &value) {
//    m_mapPlacement ["rotation"]->setLimitValues ("X", value.limitX.minimum, value.limitX.maximum, value.limitX.step);
//    m_mapPlacement ["rotation"]->setLimitValues ("Y", value.limitY.minimum, value.limitY.maximum, value.limitY.step);
//    m_mapPlacement ["rotation"]->setLimitValues ("Z", value.limitZ.minimum, value.limitZ.maximum, value.limitZ.step);
//    m_mapPlacement ["rotation"]->initValues (value.vec3Dvalue.x (), value.vec3Dvalue.y (), value.vec3Dvalue.z ());
//    m_mapPlacement ["rotation"]->calculate ();
//}

//HManagementItem HObjectReality::size () const {
//    HManagementItem res;

//    res.vec3Dvalue = m_mapPlacement ["size"]->getOutValues ();
//    m_mapPlacement ["size"]->getLimitValues ("X", &res.limitX.minimum, &res.limitX.maximum, &res.limitX.step);
//    m_mapPlacement ["size"]->getLimitValues ("Y", &res.limitY.minimum, &res.limitY.maximum, &res.limitY.step);
//    m_mapPlacement ["size"]->getLimitValues ("Z", &res.limitZ.minimum, &res.limitZ.maximum, &res.limitZ.step);

//    return res;
//}

//void HObjectReality::setSize (const HManagementItem &value) {
//    m_mapPlacement ["size"]->setLimitValues ("X", value.limitX.minimum, value.limitX.maximum, value.limitX.step);
//    m_mapPlacement ["size"]->setLimitValues ("Y", value.limitY.minimum, value.limitY.maximum, value.limitY.step);
//    m_mapPlacement ["size"]->setLimitValues ("Z", value.limitZ.minimum, value.limitZ.maximum, value.limitZ.step);
//    m_mapPlacement ["size"]->initValues (value.vec3Dvalue.x (), value.vec3Dvalue.y (), value.vec3Dvalue.z ());
//    m_mapPlacement ["size"]->calculate ();
//}

void HObjectReality::setOpacity (float value) {
    if (value == m_fltOpacity)
        return;

//    cout << metaObject ()->className () << "::setOpacity=" << value << endl;
    m_fltOpacity = value;
    emit sgnObjectRealityOpacityChanged (m_fltOpacity);
}

void HObjectReality::setVisible (bool value) {
//    cout << metaObject ()->className () << "::" << objectName () << "::setVisible=" << value << endl;
    if (value == m_bVisible)
        return;

    m_bVisible = value;
    emit sgnObjectRealityVisibleChanged (m_bVisible);
}

void HObjectReality::setSourceEntity (QString value) {
    if (value == m_strSourceEntity)
        return;

//    cout << metaObject ()->className () << "::setSourceEntity=" << value << endl;
    m_strSourceEntity = value;
    emit sgnObjectRealitySourceEntityChanged (m_strSourceEntity);
}

QVector3D HManagementItem::getSliderValues (void) {
    return QVector3D (m_listSliderParams.at (0)->sliderValue (), m_listSliderParams.at (1)->sliderValue (), m_listSliderParams.at (2)->sliderValue ());
}

HManagementSlider *HManagementItem::sliderParamsAxis (QString axis) {
    if (axis.contains ("X"))
        return m_listSliderParams.at (0);
    else
        if (axis.contains ("Y"))
            return m_listSliderParams.at (1);
        else
            if (axis.contains ("Z"))
                return m_listSliderParams.at (2);
            else
                return NULL;
}

void HManagementItem::setSliderValues (float valX, float valY, float valZ) {
    m_listSliderParams.at (0)->setSliderValue (valX);
    m_listSliderParams.at (1)->setSliderValue (valY);
    m_listSliderParams.at (2)->setSliderValue (valZ);
}

void HManagementItem::setSliderValue (QString itemManagement, float val) {
    if (itemManagement.contains ("X"))
        m_listSliderParams.at (0)->setSliderValue (val);
    else
        if (itemManagement.contains ("Y"))
            m_listSliderParams.at (1)->setSliderValue (val);
        else
            if (itemManagement.contains ("Z"))
                m_listSliderParams.at (2)->setSliderValue (val);
            else
                ; //Не ИЗВЕСТНая осЬ
}

void HManagementItem::calculate (QString ) {

}

void HManagementItem::componentComplete() {

}
