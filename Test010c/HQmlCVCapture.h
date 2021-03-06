#ifndef HQMLCVCAPTURE_H
#define HQMLCVCAPTURE_H

#include <QDeclarativeItem>
#include <Qt3DQuick/qdeclarativeitem3d.h>
#include <Qt3D/qglcamera.h>

#include <opencv/cv.h>

#include "hogrewidget.h"

class QmlCVCapture;

class QmlCVCapture : public QDeclarativeItem
{
    Q_OBJECT

    //Q_PROPERTY (bool visible READ getVisible WRITE setVisible NOTIFY sgnVisibleChanged)
    Q_PROPERTY (int numPort READ getNumPort WRITE setNumPort)
    Q_PROPERTY (unsigned int interval READ getInterval WRITE setInterval)
    Q_PROPERTY (QRect rcOutput READ getRectOutput WRITE setRectOutput)
public:
    explicit QmlCVCapture (QDeclarativeItem *parent = 0);
    ~QmlCVCapture();

    //void setVisible (const bool &n) { m_bVisible = n; }
    //bool getVisible () const { return m_bVisible; }

    void setNumPort (const int &n) { m_numPort = n; }
    int getNumPort () const { return m_numPort; }

    void setIndexPort (const int &n) { m_indexPort = n; }
    int getIndexPort () const { return m_indexPort; }

    void setInterval (const unsigned int &n) { m_interval = n; }
    unsigned int getInterval () const { return m_interval; }

    void setRectOutput (const QRect &rc) { m_rcOutput = rc; }
    QRect getRectOutput () const { return m_rcOutput; }

    void createWidgetCVCapture (QGLWidget *, Ogre::Root *, HSynchCoordinates *, QString);
    void createWidgetCVCapture (QWidget *, Ogre::Root *, HSynchCoordinates *, QString);
    HOgreWidget *getWidgetCVCapture () { return m_widgetCVCapture; }

signals:

public slots:
    void size (int w, int h) {
        if (m_widgetCVCapture)
            m_widgetCVCapture->resize (w, h);
    }

    void move (int x, int y) {
        if (m_widgetCVCapture)
            m_widgetCVCapture->move (x, y);
    }

    void completed (void);

    int start (void);
    void stop (void);

    //void onSgnVisibleChanged (bool bVisible) { setVisible (bVisible); }

protected:
    void timerEvent(QTimerEvent*);
    void paint ( QPainter *, const QStyleOptionGraphicsItem *, QWidget *);

    void showEvent (QShowEvent *e) {
        cout << "QmlCVCapture::showEvent" << endl;
    }

private:
    HOgreWidget* m_widgetCVCapture;

    int m_iIdTimerUpadate;

    //bool m_bVisible;
    unsigned int m_numPort;
    unsigned int m_indexPort;
    unsigned int m_interval;
    QRect m_rcOutput;

    int setupResources (void);
};

#endif // HQMLCVCAPTURE_H
