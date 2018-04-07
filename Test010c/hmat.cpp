#include "hmat.h"

HMat::HMat(QObject *parent) : QObject (parent) {
}

float HMat::roundFloat (float doValue, int nPrecision)
{
    static const float doBase = 10.0;
    float doComplete5, doComplete5i;

    doComplete5 = doValue * pow(doBase, (float) (nPrecision + 1));

    if (doValue < 0.0)
        doComplete5 -= 5.0;
    else
        doComplete5 += 5.0;

    doComplete5 /= doBase;
    modff (doComplete5, &doComplete5i);

    return doComplete5i / pow (doBase, (float) nPrecision);
}

QQuaternion HMat::getQuaternionFromEuler (float x, float y, float z) {
    return getQuaternionFromEuler (QVector3D (x, y, z));
}

QQuaternion HMat::getQuaternionFromEuler (QVector3D angleIn) {
    QQuaternion qtrnRes;
    QVector3D angleRad (GRAD_TO_RADIAN (angleIn.x ()), GRAD_TO_RADIAN (angleIn.y ()), GRAD_TO_RADIAN (angleIn.z ()));

    // Assuming the angles are in radians.
    double  c1 = cos (angleRad.x () / 2),
            s1 = sin (angleRad.x () / 2),
            c2 = cos (angleRad.y () / 2),
            s2 = sin (angleRad.y () / 2),
            c3 = cos (angleRad.z () / 2),
            s3 = sin (angleRad.z () / 2),
            c1c2 = c1*c2,
            s1s2 = s1*s2;

    qtrnRes.setScalar (c1c2 * c3 - s1s2 * s3);
    qtrnRes.setX (c1c2 * s3 + s1s2 * c3);
    qtrnRes.setY (s1 *c2 * c3 + c1 * s2 * s3);
    qtrnRes.setZ (c1 * s2 * c3 - s1 * c2 * s3);

    return qtrnRes;
}

QVector3D HMat::getEulerFromQuaternion (float w, float x, float y, float z) {
    return getEulerFromQuaternion (QQuaternion (w, x, y, z));
}

QVector3D HMat::getEulerFromQuaternion (QQuaternion q1) {
    QVector3D vec3DRes;

    double  sqw = q1.scalar () * q1.scalar (),
            sqx = q1.x () * q1.x (),
            sqy = q1.y () * q1.y (),
            sqz = q1.z () * q1.z ();

    double  unit = sqx + sqy + sqz + sqw, // if normalised is one, otherwise is correction factor
            test = q1.x () * q1.y () + q1.z () * q1.scalar ();

    if (test > 0.499*unit) { // singularity at north pole
        vec3DRes.setX (2 * atan2 (q1.x (), q1.scalar ()));
        vec3DRes.setY (M_PI / 2);
        vec3DRes.setZ (0);
    }
    else {
        if (test < -0.499 * unit) { // singularity at south pole
            vec3DRes.setX (-2 * atan2 (q1.x (), q1.scalar ()));
            vec3DRes.setY (-M_PI / 2);
            vec3DRes.setZ (0);
        }
        else {
            vec3DRes.setX (atan2 (2 * q1.y () * q1.scalar () - 2 * q1.x () * q1.z (), sqx - sqy - sqz + sqw));
            vec3DRes.setY (asin (2 * test / unit));
            vec3DRes.setZ (atan2 (2 * q1.x () * q1.scalar () -2 * q1.y () * q1.z (), -sqx + sqy - sqz + sqw));
        }
    }

    vec3DRes = radianToGradVector3D (vec3DRes);

    return vec3DRes;
}

void HMat::roundFloat (float *pDoValue, int nPrecision)
{
    static const float doBase = 10.0;
    float doComplete5, doComplete5i;

    doComplete5 = *pDoValue * pow(doBase, (float) (nPrecision + 1));

    if (*pDoValue < 0.0)
        doComplete5 -= 5.0;
    else
        doComplete5 += 5.0;

    doComplete5 /= doBase;
    modff (doComplete5, &doComplete5i);

    *pDoValue = doComplete5i / pow (doBase, (float) nPrecision);
}

cv::Mat HMat::roundCvMat (cv::Mat cvMat, int nPrecision) {
    float val;
    cv::Mat cvMatRes = cvMat.clone ();

    val = cvMatRes.ptr <float> (0) [0], roundFloat (&val, nPrecision), cvMatRes.ptr <float> (0) [0] = val;
    val = cvMatRes.ptr <float> (0) [1], roundFloat (&val, nPrecision), cvMatRes.ptr <float> (0) [1] = val;
    val = cvMatRes.ptr <float> (0) [2], roundFloat (&val, nPrecision), cvMatRes.ptr <float> (0) [2] = val;

    return cvMatRes;
}

void HMat::roundCvMat (cv::Mat *pCvMat, int nPrecision) {
    roundFloat (&pCvMat->ptr <float> (0) [0], nPrecision);
    roundFloat (&pCvMat->ptr <float> (0) [1], nPrecision);
    roundFloat (&pCvMat->ptr <float> (0) [2], nPrecision);
}

void HMat::cvMatZero (cv::Mat &cvMat) {
    cvMat.at <float> (0, 0) = 0;
    cvMat.at <float> (1, 0) = 0;
    cvMat.at <float> (2, 0) = 0;
}

void HMat::roundVector3D (QVector3D *pVec3D, int nPrecision) {
    pVec3D->setX (roundFloat (pVec3D->x (), nPrecision));
    pVec3D->setY (roundFloat (pVec3D->y (), nPrecision));
    pVec3D->setZ (roundFloat (pVec3D->z (), nPrecision));
}

void HMat::rotateXAxis (QVector3D &vec3DRotation, float angleGrad) {
    cv::Mat cvMatRes = cvMat (vec3DRotation);
    rotateXAxis (cvMatRes, angleGrad);
    vec3DRotation = vector3D (cvMatRes);
}

void HMat::rotateXAxis (cv::Mat &rotation, float angleGrad)
{
    float angleRad = GRAD_TO_RADIAN (angleGrad);
//    cout << angleRad << endl;

//    cv::Mat R (3, 3, CV_32F);
//    Rodrigues (rotation, R);
    //create a rotation matrix for x axis
    cv::Mat RX = cv::Mat::eye (3, 3, CV_32F);
//    cout << RX << endl;
    RX.at <float> (1, 1) = cos (angleRad);
    RX.at <float> (1, 2) = -sin (angleRad);
    RX.at <float> (2, 1) = sin (angleRad);
    RX.at <float> (2, 2) = cos (angleRad);
    //now multiply
//    R = R * RX;
    rotation = RX * rotation;
    //finally, the the rodrigues back
//    Rodrigues (R, rotation);

    roundCvMat (&rotation, 3);
}

void HMat::rotateYAxis (QVector3D &vec3DRotation, float angleGrad) {
    cv::Mat cvMatRes = cvMat (vec3DRotation);
    rotateYAxis (cvMatRes, angleGrad);
    vec3DRotation = vector3D (cvMatRes);
}

void HMat::rotateYAxis (cv::Mat &rotation, float angleGrad)
{
    float angleRad = GRAD_TO_RADIAN (angleGrad);

//    cv::Mat R (3, 3, CV_32F);
//    Rodrigues(rotation, R);
    //create a rotation matrix for y axis
    cv::Mat RX = cv::Mat::eye (3, 3, CV_32F);
//    cout << RX << endl;
    RX.at <float> (0, 0) = cos (angleRad);
    RX.at <float> (0, 2) = sin (angleRad);
    RX.at <float> (2, 0) = -sin (angleRad);
    RX.at <float> (2, 2) = cos(angleRad);
    //now multiply
//    R = R * RX;
    rotation = RX * rotation;
    //finally, the the rodrigues back
//    Rodrigues (R, rotation);

    roundCvMat (&rotation, 3);
}

void HMat::rotateZAxis (QVector3D &vec3DRotation, float angleGrad) {
    cv::Mat cvMatRes = cvMat (vec3DRotation);
    rotateZAxis (cvMatRes, angleGrad);
    vec3DRotation = vector3D (cvMatRes);
}

void HMat::rotateZAxis (cv::Mat &rotation, float angleGrad)
{
    float angleRad = GRAD_TO_RADIAN (angleGrad);

//    cv::Mat R (3, 3, CV_32F);
//    Rodrigues (rotation, R);
    //create a rotation matrix for x axis
    cv::Mat RX = cv::Mat::eye (3, 3, CV_32F);
//    cout << RX << endl;
    RX.at <float> (0, 0) = cos (angleRad);
    RX.at <float> (0, 1) = -sin (angleRad);
    RX.at <float> (1, 0) = sin (angleRad);
    RX.at <float> (1, 1) = cos (angleRad);
    //now multiply
//    R = R * RX;
    rotation = RX * rotation;
    //finally, the the rodrigues back
//    Rodrigues (R, rotation);

    roundCvMat (&rotation, 3);
}


QVector3D HMat::radianToGradVector3D (QVector3D vec3D) {
    QVector3D vec3DRes = QVector3D (0, 0, 0);

    vec3DRes.setZ (RADIAN_TO_GRAD (vec3D.z ()));
    vec3DRes.setX (RADIAN_TO_GRAD (vec3D.x ()));
    vec3DRes.setY (RADIAN_TO_GRAD (vec3D.y ()));

    HMat::roundVector3D (&vec3DRes, 3);

    return vec3DRes;
}

QVector3D HMat::rotatedVector3DOfAxisOfUp (const QVector3D vec3DAxisRotation, const QVector3D vec3DUpRotation, QVector3D vec3DRotated, const QVector3D vec3DAngleGradRotation) {
    QQuaternion qtr = HMat::roll (vec3DAxisRotation, vec3DAngleGradRotation.x ()),
                qtp = HMat::pan (vec3DUpRotation, vec3DAngleGradRotation.y ()),
                qtt = HMat::tilt (vec3DAxisRotation, vec3DUpRotation, vec3DAngleGradRotation.z ()),
                qtRes = qtt * qtp * qtr;

    return qtRes.rotatedVector (vec3DRotated);
}

void HMat::rotatedVector3DOfAxisOfUp (const QVector3D vec3DAxisRotation, const QVector3D vec3DUpRotation, QVector3D *pVec3DRotated, const QVector3D vec3DAngleGradRotation) {
    QQuaternion qtr = HMat::roll (vec3DAxisRotation, vec3DAngleGradRotation.x ()),
                qtp = HMat::pan (vec3DUpRotation, vec3DAngleGradRotation.y ()),
            qtt = HMat::tilt (vec3DAxisRotation, vec3DUpRotation, vec3DAngleGradRotation.z ()),
                qtRes = qtt * qtp * qtr;

    *pVec3DRotated = qtRes.rotatedVector (*pVec3DRotated);
}
