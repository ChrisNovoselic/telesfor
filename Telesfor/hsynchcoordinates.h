#ifndef HSYNCHCOORDINATES_H
#define HSYNCHCOORDINATES_H

#include <QObject>
#include <QVector3D>

//#include <aruco/aruco.h>
//using namespace aruco;

#include "hobjectreality.h"
#include "hmat.h"

class HSynchCoordinates : public QObject
{
    Q_OBJECT

    Q_PROPERTY (int idMarkerPSC READ idMarkerPSC WRITE setIdMarkerPSC)
    Q_PROPERTY (float szMarkerPSC READ szMarkerPSC WRITE setSizeMarkerPSC)

    //ХАРАКТЕРИСТИКи СЦЕНы расширеннОЙ реалЬностИ
    Q_PROPERTY (int direction_track READ direction_track WRITE setDirectionTrack) //Направление движения 'дорожки'
    Q_PROPERTY (qreal begin_position_trace READ begin_position_trace WRITE setBeginPositionTrace) //Смещение позиции ПЕРВого СЛЕДа от центрА ФСК (вдоль ДВИЖЕНия ДОРОЖКи)
    Q_PROPERTY (qreal begin_position_track READ begin_position_track WRITE setBeginPositionTrack) //Смещение НАЧАЛа виртуальной ДОРОЖКи от центрА ФСК
    Q_PROPERTY (qreal length_track READ length_track WRITE setLengthTrack) //Виртуальная ДЛИНа ДОРОЖКи (следы виднЫ)

//    Q_PROPERTY (int count_of_trace READ count_of_trace) //Количество следов

    Q_PROPERTY (qreal sliderStepsLength READ sliderStepsLength WRITE setStepsLength NOTIFY sgnStepsLengthChanged) //Длина шага - внешние данные, получаемые от 'Qml::root::paramStepsLength'

    Q_PROPERTY (int count_line READ count_line WRITE setCountLine) //Количество линИй следов
    Q_PROPERTY (qreal sliderStepsWidth READ sliderStepsWidth WRITE setStepsWidth) //База шага - внешние данные, получаемые от 'Qml::root::'
    Q_PROPERTY (qreal max_steps_width READ max_steps_width WRITE setMaxStepsWidth) //База шага - внешние данные, получаемые от 'Qml::root::'

    Q_PROPERTY (qreal sliderSpeedTrack READ sliderSpeedTrack WRITE setSpeedTrack) //СкоростЬ "дорожки" - внешние данные, получаемые от 'Qml::root::paramStepsLength'
    Q_PROPERTY (qreal coeffSpeedTrack READ coeffSpeedTrack WRITE setCoeffSpeedTrack) //Коэффициент движения полотна "дорожки" - внешние данные, получаемые от 'Qml::root::paramStepsLength'

     Q_PROPERTY (qreal coeffStepsLength READ coeffStepsLength WRITE setCoeffStepsLength)

    Q_PROPERTY (int count_lattice_line READ count_lattice_line WRITE setCountLatticeLine NOTIFY sgnCountLatticeLineChanged) //Количество линИй РЕШёТКи
public:
    explicit HSynchCoordinates(QObject *parent = 0);
    ~HSynchCoordinates();

    enum TYPE_OBJECTREALITY {TRACE, POLE, LINE};

    static QVector3D crossCircles (QVector3D , QVector3D, QVector3D);

    QList <QString> getListNameObjectReality (void) { return m_mapObjectReality.keys (); }

    int idMarkerPSC (void) const { return m_iIdMarkerPSC; }
//    void setIdMarkerPSC (const int &id) { m_iIdMarkerPSC = id; }
    float szMarkerPSC (void) const { return m_fltMarkerSize; }
//    void setSizeMarkerPSC (const float &sz) { m_fltMarkerSize = sz; }

    int direction_track (void) const { return m_shDirectionTrack; }
    qreal begin_position_trace (void) const { return m_fltBeginPositionTrace; }
    qreal begin_position_track (void) const { return m_fltBeginPositionTrack; }
    qreal length_track (void) const { return m_fltLengthTrack; }

//    int count_of_trace (void) const { return m_iCountOfTrace; }

    qreal sliderStepsLength (void) const { return m_fltStepsLength; }

    int count_line (void) const { return m_iCountLine; }
    qreal sliderStepsWidth (void) const { return m_fltStepsWidth; }
    qreal max_steps_width (void) const { return m_fltMaxStepsWidth; }

    qreal sliderSpeedTrack (void) const { return m_fltSpeedTrack; }
    qreal coeffSpeedTrack (void) const { return m_fltCoeffSpeedTrack; }

    qreal coeffStepsLength (void) const { return m_fltCoeffStepsLength; }

    int count_lattice_line (void) const { return m_iCountLatticeLine; }

signals:
    void sgnCreateEntity (QString);
    void sgnDestroyEntity (QString);
    void sgnStepsLengthChanged (float val);

    void sgnCreateObjectReality (QVariant, QVariant );

    void sgnCountLatticeLineChanged (int );
    
public slots:
    HObjectReality *getObjectReality (QString);
    HObjectReality *getObjectReality (QString name, int num) { return getObjectReality (name + QString::number (num)); }
    void insertObjectReality (QString, HObjectReality *);
    void deleteObjectReality (QString);
//    void deleteObjectReality (QString, HObjectReality *);

    void onSgnIsCreateObjectReality (HObjectReality * , QString, int );

    QVector3D getValues (QString , QString ); //Все 3 координаты по 'position' ИЛИ по 'rotation' ИЛИ по 'size'
    float getValue (QString , QString , QString ); //ОДНа координатА по 'position' ИЛИ по 'rotation' ИЛИ по 'size' И по ОДНой из ОСей
    void initValues (QString , QString , QVector3D); //Все 3 координаты по 'position' ИЛИ по 'rotation' ИЛИ по 'size'
    void initValue (QString , QString , QString , float); //ОДНа координатА по 'position' ИЛИ по 'rotation' ИЛИ по 'size' И по ОДНой из ОСей
    void changeValues (QString , QString , QVector3D); //Все 3 координаты ...
    float changeValue (QString , QString , QString , float); //ОДНа координатА (возврАт новОе значение)
    bool visible (QString obj) { return getObjectReality (obj)->visible (); } //Прочитать значение 'видиммость' для обЪектА
    void setVisible (QString, bool); //Установить значение 'видиммость' для обЪектА
    void calculate (QString , QString , QString = "");

    void onSgnSetPlacementsMovable (QString );
    void onSgnSetVisibleObjectReality (QString , int , bool);
    void onSgnMotionTrace (void);

    void initObjectReality (QObject *);
    int getCountObjectReality (QString = "");

//    void setStepsLength (float val) { m_fltStepsLength = val; }
//    void setStepsWidth (float val) { m_fltStepsWidth = val; }

    void setIdMarkerPSC (const int &id) { m_iIdMarkerPSC = id; }
//    int getIdMarkerPSC (void) const { return m_iIdMarkerPSC; }
    void setSizeMarkerPSC (const float &val) { m_fltMarkerSize = val; }
//    void setMarkerSize (int id, float val) { m_fltMarkerSize = val; }
//    float getMarkerSize (void) { return m_fltMarkerSize; }
//    float getMarkerSize (int id) { return m_fltMarkerSize; }

//    void fixedPSC (bool val) { m_bFixedPSC = val; }
//    bool getFixededPSC (void) { return m_bFixedPSC; }
//    std::vector <Marker> getMarkers (void) { return m_arMarkers; }
//    cv::vector <Marker> m_arMarkers;

    void setDirectionTrack (const int &);
    void setBeginPositionTrace (const qreal &pos) { m_fltBeginPositionTrace = pos; }
    void setBeginPositionTrack (const qreal &pos) { m_fltBeginPositionTrack = pos; }
    void setLengthTrack (const qreal &l) { m_fltLengthTrack = l; }

    void setStepsLength (const qreal &l) {
        if (l == m_fltStepsLength)
            return;

        m_fltStepsLength = l;
        emit sgnStepsLengthChanged (m_fltStepsLength);
    }

    void onSgnStepsLengthChanged (float val);
    int getNumTraceOfMinPosition (void);
    int getNumTraceOfMaxPosition (void);

    void setCountLine (const int&c) { m_iCountLine = c; }
    void setStepsWidth (const qreal &w) { m_fltStepsWidth = w; }
    void setMaxStepsWidth (const qreal &m) { m_fltMaxStepsWidth = m; }

    void setSpeedTrack (const qreal &v) { m_fltSpeedTrack = v; }
    void setCoeffSpeedTrack (const qreal &c) { m_fltCoeffSpeedTrack = c; }

    void setCoeffStepsLength (const qreal &c) { m_fltCoeffStepsLength = c; }

    void setCountLatticeLine (const int&c) { m_iCountLatticeLine = c; }

private:
    QMap <QString, HObjectReality *> m_mapObjectReality;
    int m_iIdMarkerPSC; //ID маркера - ЦЕНТРа ФСК
    float m_fltMarkerSize; //Размер маркера в метрах

//    float m_fltStepsLength, m_fltStepsWidth;

//    bool m_bFixedPSC; //Зафиксирована ли ФСК
//    cv::vector <Marker> m_arMarkers;

//    HMat m_hmat;

        int m_shDirectionTrack;
        qreal m_fltBeginPositionTrace,
        m_fltBeginPositionTrack,
        m_fltLengthTrack;

        bool m_arExternVisibleTrace [2];

    //Количество 'следов'
    int m_iCountOfTrace,
        m_iCountLine;
    short m_shStaticCountOfTrace; //Из них статически создаваемых (образцы), остальные динамически

    int m_iCountLatticeLine;

    HObjectReality *createObjectReality (int , TYPE_OBJECTREALITY );
    void setTracesPlacement (int);
    int getCountOfTrace (void);

    short getNumberLine (short );
    QVector3D getPositionTrace (short );

    qreal m_fltStepsLength,
        m_fltSpeedTrack,
        m_fltCoeffSpeedTrack,
        m_fltCoeffStepsLength,
        m_fltStepsWidth,
        m_fltMaxStepsWidth;
};

#endif // HSYNCHCOORDINATES_H
