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

//class HManagementItemPrivate;

//class HManagementItem : public QObject
//{
//    Q_OBJECT
//public:
//    HManagementItem () {}
//    QVector3D vec3Dvalue;
//    HLimitManagementItem limitX;
//    HLimitManagementItem limitY;
//    HLimitManagementItem limitZ;

//private:
//    Q_DISABLE_COPY (HManagementItem)
//    Q_DECLARE_PRIVATE (HManagementItem)
//};

class HManagementItemPrivate;

class  HManagementItem : public QObject {
    Q_OBJECT
    Q_PROPERTY(QDeclarativeListProperty <HManagementSlider> sliders READ sliders DESIGNABLE false FINAL)
public:
    HManagementItem (QObject *parent = 0) : QObject (parent) {}
    ~HManagementItem () {}

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

    HManagementItemPrivate *d;

    friend class HManagementItemPrivate;

    Q_DISABLE_COPY(HManagementItem)
};

#define getValues getSliderValues

class HObjectRealityPrivate;

class  HObjectReality : public QObject {
    Q_OBJECT
    Q_PROPERTY(float opacity READ opacity WRITE setOpacity NOTIFY sgnObjectRealityOpacityChanged)
    Q_PROPERTY(bool visible READ visible WRITE setVisible NOTIFY sgnObjectRealityVisibleChanged)
    Q_PROPERTY(QString sourceEntity READ sourceEntity WRITE setSourceEntity NOTIFY sgnObjectRealitySourceEntityChanged)
    Q_PROPERTY(QDeclarativeListProperty <HManagementItem> placements READ placements DESIGNABLE false FINAL)
public:
    HObjectReality (QObject *parent = 0);
    ~HObjectReality ();

    QDeclarativeListProperty <HManagementItem> placements () {
        return QDeclarativeListProperty <HManagementItem> (this, m_listItemManagement);
    }

    inline float opacity () const { return m_fltOpacity; }
    inline bool visible () const { return m_bVisible; }
    inline QString sourceEntity () const { return m_strSourceEntity; }

    void componentComplete();

public Q_SLOTS:
    void setOpacity (float);
    void setVisible (bool);
    void setSourceEntity (QString);
    HManagementItem *placement (QString item) {
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
    QList <HManagementItem *> m_listItemManagement;
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
//    Q_PROPERTY(HManagementItem position READ position WRITE setPosition NOTIFY positionChanged)
//    Q_PROPERTY(HManagementItem rotation READ rotation WRITE setRotation NOTIFY rotationChanged)
//    Q_PROPERTY(HManagementItem size READ size WRITE setSize NOTIFY sizeChanged)

//    explicit HObjectReality (QObject * = 0);
//    ~HObjectReality ();

//    QMap <QString, HControlledVector *> m_mapPlacement;

//    HManagementItem position () const;
//    void setPosition (const HManagementItem &);

//    HManagementItem rotation () const;
//    void setRotation (const HManagementItem &);

//    HManagementItem size () const;
//    void setSize (const HManagementItem &);


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
