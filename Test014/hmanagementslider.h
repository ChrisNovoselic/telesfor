#ifndef HMANAGEMENTSLIDER_H
#define HMANAGEMENTSLIDER_H

#include <QObject>

class HManagementSliderPrivate;

class HManagementSlider : public QObject
{
    Q_OBJECT
    Q_PROPERTY (float sliderValue READ sliderValue WRITE setSliderValue NOTIFY sgnSliderValueChanged)
    Q_PROPERTY (float minValue READ minValue WRITE setMinValue NOTIFY sgnMinValueChanged)
    Q_PROPERTY (float maxValue READ maxValue WRITE setMaxValue NOTIFY sgnMaxValueChanged)
    Q_PROPERTY (float stepValue READ stepValue WRITE setStepValue NOTIFY sgnStepValueChanged)
public:
    explicit HManagementSlider(QObject *parent = 0);
    HManagementSlider(float , float , float , float , QObject *);
    inline float sliderValue () const { return m_sliderValue; }
    inline float minValue () const { return m_MinValue; }
    inline float maxValue () const { return m_MaxValue; }
    inline float stepValue () const { return m_StepValue; }
    
signals:
    void sgnSliderValueChanged (float);
    void sgnMinValueChanged (float);
    void sgnMaxValueChanged (float);
    void sgnStepValueChanged (float);
    
public slots:
    void setSliderValue (float);
    void setMinValue (float);
    void setMaxValue (float);
    void setStepValue (float);

    void setValues (void) {
        setSliderValue (m_sliderValue);
        setMinValue (m_MinValue);
        setMaxValue (m_MaxValue);
        setStepValue (m_StepValue);
    }

private:
    float m_sliderValue;
    float m_MinValue;
    float m_MaxValue;
    float m_StepValue;

   class HManagementSliderPrivate *d;

    friend class HManagementSliderPrivate;

    Q_DISABLE_COPY(HManagementSlider)
};

#endif // HMANAGEMENTSLIDER_H
