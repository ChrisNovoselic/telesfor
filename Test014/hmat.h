#ifndef HMAT_H
#define HMAT_H

#include <QObject>
#include <QQuaternion>
#include <QVector3D>
#include <opencv/cv.h>
#include <qmath.h>

#define RADIAN_TO_GRAD(val) val*180/M_PI
#define GRAD_TO_RADIAN(val) val*M_PI/180

class HMat : public QObject
{
    Q_OBJECT
public:
    explicit HMat (QObject * = 0);

    static float roundFloat (float , int );
    static void roundFloat (float *, int );
    static cv::Mat roundCvMat (cv::Mat, int );
    static void roundCvMat (cv::Mat *, int );
    static void roundVector3D (QVector3D *, int );
    static void cvMatZero (cv::Mat &);

    static void rotateXAxis (cv::Mat &, float);
    static void rotateXAxis (QVector3D &, float);
    static void rotateYAxis (cv::Mat &, float);
    static void rotateYAxis (QVector3D &, float);
    static void rotateZAxis (cv::Mat &, float);
    static void rotateZAxis (QVector3D &, float);

    static QVector3D rotatedVector3DOfAxisOfUp (const QVector3D, const QVector3D, QVector3D, const QVector3D);
    static void rotatedVector3DOfAxisOfUp (const QVector3D, const QVector3D, QVector3D *, const QVector3D);

    static QVector3D radianToGradVector3D (QVector3D);

    static QVector3D vector3D (cv::Mat cvMat) {
        return QVector3D (cvMat.at <float> (0, 0),
                          cvMat.at <float> (1, 0),
                          cvMat.at <float> (2, 0));
    }

    static cv::Mat cvMat (QVector3D vec3D) {
        cv::Mat cvMatRes;
        cvMatRes.create (3, 1, CV_32FC1);

        cvMatRes.at <float> (0, 0) = vec3D.x (), cvMatRes.at <float> (1, 0) = vec3D.y (), cvMatRes.at <float> (2, 0) = vec3D.z ();

        return cvMatRes;
    }

    static QQuaternion tilt (QVector3D vec3DLookAt, QVector3D vec3DUp, float angleGrad) {
        QVector3D side = QVector3D::crossProduct (vec3DLookAt, vec3DUp);

        return QQuaternion::fromAxisAndAngle(side, angleGrad);
    }

    static QQuaternion pan (QVector3D vec3DUp, float angleGrad) {
        return QQuaternion::fromAxisAndAngle (vec3DUp, angleGrad);
    }

    static QQuaternion roll (QVector3D vec3DLookAt, float angleGrad) {
        return QQuaternion::fromAxisAndAngle (vec3DLookAt, angleGrad);
    }

    static QQuaternion quaternionRotationTotal (float fltAngleX, float fltAngleY, float fltAngleZ) {
        QQuaternion qtrnRes (1, 0, 0, 0);
        qtrnRes.setScalar (cos (fltAngleX / 2) * cos (fltAngleY / 2) * cos (fltAngleZ / 2) + sin (fltAngleX / 2) * sin (fltAngleY / 2) * sin (fltAngleZ / 2));
        qtrnRes.setX (sin (fltAngleX / 2) * cos (fltAngleY / 2) * cos (fltAngleZ / 2) - cos (fltAngleX / 2) * sin (fltAngleY / 2) * sin (fltAngleZ / 2));
        qtrnRes.setY (cos (fltAngleX / 2) * sin (fltAngleY / 2) * cos (fltAngleZ / 2) + sin (fltAngleX / 2) * cos (fltAngleY / 2) * sin (fltAngleZ / 2));
        qtrnRes.setZ (cos (fltAngleX / 2) * cos (fltAngleY / 2) * sin (fltAngleZ / 2) - sin (fltAngleX / 2) * sin (fltAngleY / 2) * cos (fltAngleZ / 2));


        return qtrnRes;
    }

    static QVector3D getEulerFromQuaternion (float , float , float, float );
    static QVector3D getEulerFromQuaternion (QQuaternion);

    static QQuaternion getQuaternionFromEuler (float , float , float);
    static QQuaternion getQuaternionFromEuler (QVector3D);

signals:
    
public slots:
};

#endif // HMAT_H
