#include "hmanagementslider.h"

HManagementSlider::HManagementSlider(QObject *parent) : QObject(parent) {
    m_sliderValue = 0;
    m_MinValue = -1;
    m_MaxValue = 1;
    m_StepValue = 1;
}

HManagementSlider::HManagementSlider(float val, float min, float max, float step, QObject *parent) : QObject(parent) {
    m_sliderValue = val;
    m_MinValue = min;
    m_MaxValue = max;
    m_StepValue = step;
}

void HManagementSlider::setSliderValue (float value) {
    if (value == m_sliderValue)
        return;

    m_sliderValue = value;
    emit sgnSliderValueChanged (m_sliderValue);
}

void HManagementSlider::setMinValue (float value) {
    if (value == m_MinValue)
        return;

    m_MinValue = value;
    emit sgnSliderValueChanged (m_MinValue);
}

void HManagementSlider::setMaxValue (float value) {
    if (value == m_MaxValue)
        return;

    m_MaxValue = value;
    emit sgnSliderValueChanged (m_MaxValue);
}

void HManagementSlider::setStepValue (float value) {
    if (value == m_StepValue)
        return;

    m_StepValue = value;
    emit sgnSliderValueChanged (m_StepValue);
}
