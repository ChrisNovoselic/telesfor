#ifndef HOGREWIDGET_H
#define HOGREWIDGET_H

#include <QtGui>
#include <QGLWidget>
#include <QX11Info>

#include <QPaintEvent>
#include <QShowEvent>
#include <QResizeEvent>
#include <QMoveEvent>

#include "hsynchcoordinates.h"

#include <OGRE/Ogre.h>

#include <aruco/aruco.h>
using namespace aruco;

class HOgreWidget : public QGLWidget
//class HOgreWidget : public QGLWidget, public Ogre::WindowEventListener, public Ogre::FrameListener
//class HOgreWidget : public QWidget, public Ogre::WindowEventListener, public Ogre::FrameListener
{
    Q_OBJECT

public:
    HOgreWidget (QWidget *, Ogre::Root *, HSynchCoordinates *, QString);
    ~HOgreWidget();

    int initOgre (void);

    void out (void);
    int initAR (cv::VideoCapture * = NULL);

signals:
    void sgnSuccessInitalizeGL ();
    void sgnResized (int, int);
    void sgnClosed ();

public slots:
    void onSgnCreateEntity (QString);
    void onSgnDestroyEntity (QString);

protected:
    virtual void moveEvent (QMoveEvent *e);
    virtual void resizeEvent (QResizeEvent *e);

    virtual void showEvent (QShowEvent *e);
    virtual void paintEvent (QPaintEvent *e);

private:
//    void timerEvent (QTimerEvent *e);

    void releaseOgre (void);

    int createOgreRenderWindow (void);
    Ogre::RenderWindow *getRenderWindow (void) { return m_OgreRenderWindow; }

    int isInitAR (void);
    int isInitOgre (void) {
        int iRes = -1; //Error

        if (m_OgreRoot && m_OgreRenderWindow)
            iRes = 0;

        return iRes;
    }

    int createCameraBackground (void);

    int createOgreSceneManager (void);
    int setupResources (void);
    int createOgreViewport (void);
    int createOgreCamera (void);
    int createOgreScene (void);
    int createOgreMaterials (void);
    int createMaterial (Ogre::String , Ogre::ColourValue , Ogre::ColourValue , Ogre::Real, Ogre::String texture = "");

    int outBackground (void);
    void outOgreScene (void);

    void coutDebugMarkers (void);
    void coutDebugNode (Ogre::String, Ogre::Node *);

    HSynchCoordinates *m_pSynchCoordinates; //Глобальный обЪект для приложения (membership in HDeclarativeViewForm)

    Ogre::Root         *m_OgreRoot; //Глобальный обЪект для приложения (membership in HDeclarativeViewForm)
    Ogre::SceneManager *m_OgreSceneManager;
    Ogre::RenderWindow *m_OgreRenderWindow;
    Ogre::Viewport     *m_OgreViewport;
    Ogre::Camera       *m_OgreCamera;
    Ogre::SceneNode* m_OgreCameraNode;
//    Ogre::SceneNode *m_ProjectorPosterNode; //ПРОЕКТор для управлениЯ текстуроЙ оБЪектА 'Wall'

    QMap <QString, Ogre::Entity *> m_mapOgreEntity;
    QMap <QString, Ogre::Vector3> m_mapOgreEntityTrueSize;
    QMap <QString, Ogre::SceneNode *> m_mapOgreObjectNode;
    QMap <QString, Ogre::AnimationState *> m_mapBaseAnimation, m_mapTopAnimation;
    QVector3D m_vec3DOgreScale;

    QVector <Ogre::Entity *> m_arEntityLatticeVertical;
    QVector <Ogre::SceneNode *> m_arNodeLatticeVertical;
    QVector <Ogre::Entity *> m_arEntityLatticeHorizontal;
    QVector <Ogre::SceneNode *> m_arNodeLatticeHorizontal;

    float m_arfltOgreObjectNodePosition [3], m_arfltOgreObjectNodeOrientation [4];

    void moveOgreEntity (QString , Ogre::Real = 0, Ogre::Real = 0, Ogre::Real = 0);
    void rotationOgreEntity (QString , Ogre::Real = 0, Ogre::Real = 0, Ogre::Real = 0);
    void scaleOgreEntity (QString , Ogre::Real = 1.0, Ogre::Real = 1.0, Ogre::Real = 1.0);
    bool visibleOgreEntity (QString , bool = true);

    int createOgreEntity (QString , QString , float = 1.0, float = 1.0, float = 1.0);
    int createOgreEntity (QString , QString , QVector3D = QVector3D (1.0, 1.0, 1.0));
    int createLattice (Ogre::SceneNode *, QString);

    // ArUco variables
    string m_InputVideo, m_InputCameraFile;
    cv::VideoCapture *m_ptrVideoCapturer;
    cv::Mat m_InputImage, m_InputImageUnd;
    CameraParameters m_CameraParams, m_CameraParamsUnd;
    MarkerDetector m_MarkerDetector;
    cv::vector <Marker> m_arMarkers;

    short m_shCountEmptyArrayMarkers;

    Ogre::TexturePtr m_Texture;
    Ogre::PixelBox m_PixelBox;
    unsigned char *m_ptrBufferBackground;
    QSize m_szBackground;

    QString m_strPostfixName;
};

#endif // HOGREWIDGET_H
