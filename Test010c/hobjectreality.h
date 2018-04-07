#ifndef HOBJECTREALITY_H
#define HOBJECTREALITY_H

#include <QObject>
#include <QVector3D>
#include <qdeclarativelist.h>

#include "hmanagementslider.h"

//class HObjectReality : public QObject
//{
//    Q_OBJECT
//public:
//    explicit HObjectReality (QObject * = 0);
//    ~HObjectReality ();

//    QMap <QString, HControlledVector *> m_mapPlacement;
    
//signals:
    
//public slots:
    
//};

//class HLimitManagementItem : public QObject
//{
//    Q_OBJECT
//public:
//    HLimitManagementItem () {}
//    float minimum;
//    float maximum;
//    float step;
//};

//class HItemManagementPrivate;

//class HItemManagement : public QObject
//{
//    Q_OBJECT
//public:
//    HItemManagement () {}
//    QVector3D vec3Dvalue;
//    HLimitManagementItem limitX;
//    HLimitManagementItem limitY;
//    HLimitManagementItem limitZ;

//private:
//    Q_DISABLE_COPY (HItemManagement)
//    Q_DECLARE_PRIVATE (HItemManagement)
//};

class HItemManagementPrivate;

class  HItemManagement : public QObject {
    Q_OBJECT
    Q_PROPERTY(QDeclarativeListProperty <HManagementSlider> sliders READ sliders DESIGNABLE false FINAL)
public:
    HItemManagement (QObject *parent = 0) : QObject (parent) {}
    ~HItemManagement () {}

    QDeclarativeListProperty <HManagementSlider> sliders () {
        return QDeclarativeListProperty <HManagementSlider> (this, m_listSliderParams);
    }

    HManagementSlider *sliderParamsAxis (QString );
    void setSliderValues (float, float, float);
    void setSliderValue (QString , float);
    void calculate (QString );

    void componentComplete();

public Q_SLOTS:
    QVector3D getSliderValues (void);

protected:

Q_SIGNALS:

private:
    QList <HManagementSlider *> m_listSliderParams;

    HItemManagementPrivate *d;

    friend class HItemManagementPrivate;

    Q_DISABLE_COPY(HItemManagement)
};

#define getValues getSliderValues

class HObjectRealityPrivate;

class  HObjectReality : public QObject {
    Q_OBJECT
    Q_PROPERTY(float opacity READ opacity WRITE setOpacity NOTIFY sgnObjectRealityOpacityChanged)
    Q_PROPERTY(bool visible READ visible WRITE setVisible NOTIFY sgnObjectRealityVisibleChanged)
    Q_PROPERTY(QString sourceEntity READ sourceEntity WRITE setSourceEntity NOTIFY sgnObjectRealitySourceEntityChanged)
    Q_PROPERTY(QDeclarativeListProperty <HItemManagement> placements READ placements DESIGNABLE false FINAL)
public:
    HObjectReality (QObject *parent = 0);
    ~HObjectReality ();

    QDeclarativeListProperty <HItemManagement> placements () {
        return QDeclarativeListProperty <HItemManagement> (this, m_listItemManagement);
    }

    inline float opacity () const { return m_fltOpacity; }
    inline bool visible () const { return m_bVisible; }
    inline QString sourceEntity () const { return m_strSourceEntity; }

    void componentComplete();

public Q_SLOTS:
    void setOpacity (float);
    void setVisible (bool);
    void setSourceEntity (QString);
    HItemManagement *placement (QString item) {
        if (item.contains ("position"))
            return m_listItemManagement.at (0);
        else
            if (item.contains ("rotation"))
                return m_listItemManagement.at (1);
            else
                if (item.contains ("size"))
                    return m_listItemManagement.at (2);
                else
                    return 0x0;
    }

protected:

Q_SIGNALS:
    void sgnObjectRealityVisibleChanged (bool);
    void sgnObjectRealitySourceEntityChanged (QString);
    void sgnObjectRealityOpacityChanged (float);

private:
    QList <HItemManagement *> m_listItemManagement;
    float m_fltOpacity;
    bool m_bVisible;
    QString m_strSourceEntity;

    HObjectRealityPrivate *d;

    friend class HObjectRealityPrivate;

    Q_DISABLE_COPY(HObjectReality)
};

//class HObjectReality : public QObject
//{
//    Q_OBJECT

//public:
//    Q_PROPERTY(HItemManagement position READ position WRITE setPosition NOTIFY positionChanged)
//    Q_PROPERTY(HItemManagement rotation READ rotation WRITE setRotation NOTIFY rotationChanged)
//    Q_PROPERTY(HItemManagement size READ size WRITE setSize NOTIFY sizeChanged)

//    explicit HObjectReality (QObject * = 0);
//    ~HObjectReality ();

//    QMap <QString, HControlledVector *> m_mapPlacement;

//    HItemManagement position () const;
//    void setPosition (const HItemManagement &);

//    HItemManagement rotation () const;
//    void setRotation (const HItemManagement &);

//    HItemManagement size () const;
//    void setSize (const HItemManagement &);


//    HObjectReality *clone (QObject *) const;

//Q_SIGNALS:
//    void positionChanged ();
//    void rotationChanged ();
//    void sizeChanged ();

//private:
////    QScopedPointer <HObjectRealityPrivate> d_ptr;

//    Q_DISABLE_COPY (HObjectReality)
//    Q_DECLARE_PRIVATE (HObjectReality)
//};

#endif // HOBJECTREALITY_H
