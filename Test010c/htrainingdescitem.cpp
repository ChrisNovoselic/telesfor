#include "htrainingdescitem.h"

HTrainingDesc::HTrainingDesc (QObject *parent) : QObject (parent) {
}

HTrainingDesc::~HTrainingDesc () {
}

int HTrainingDesc::start (float , int, float ) {

}

int HTrainingDesc::addItem (float , int, float ) {

}

void HTrainingDesc::stop () {

}

HTrainingDescItem::HTrainingDescItem (QObject *parent) : QObject (parent) {
    m_fltTrackSpeed = 0.8;
    m_iTrackTilt = 0;
    m_fltStepsLength = 0.25;
}

HTrainingDescItem::~HTrainingDescItem () {
}
