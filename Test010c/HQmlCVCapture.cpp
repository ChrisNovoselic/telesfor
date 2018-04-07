#include "HQmlCVCapture.h"

#include <QLabel>
#include <QGraphicsProxyWidget>
#include <qgraphicsrotation3d.h>

#include <QX11Info>

QmlCVCapture::QmlCVCapture (QDeclarativeItem *parent) : QDeclarativeItem (parent) {
    cout << "QmlCVCapture::QmlCVCapture with parent=" << parent << endl;

    m_widgetCVCapture = NULL;

    setFlag (QGraphicsItem::ItemHasNoContents, false);
//    setFlag (QGraphicsItem::ItemIgnoresParentOpacity, true);
//    setFlag (QGraphicsItem::ItemStacksBehindParent, true);
//    setFlag (QGraphicsItem::ItemAcceptsInputMethod, false);

    m_iIdTimerUpadate = 0x0;
    m_indexPort = m_numPort;
}

QmlCVCapture::~QmlCVCapture () {
    if (m_iIdTimerUpadate > 0)
        killTimer (m_iIdTimerUpadate);

    //ДеструктОР для 'm_widgetCVCapture' был УЖЕ вызван родительскОЙ формОЙ 'rootRectangle' при своЁм разрушении
//    if (! (m_widgetCVCapture == NULL))
//        delete m_widgetCVCapture;
}

void QmlCVCapture::paint (QPainter *painter, const QStyleOptionGraphicsItem *style, QWidget *pWidget) {
    painter->beginNativePainting ();
//    painter->begin (m_widgetCVCapture);

//    m_widgetCVCapture->out ();

//    glClear(GL_COLOR_BUFFER_BIT);
//    glLoadIdentity();

//     glBegin(GL_QUADS);
//        glColor3ub(0,0,255);
//        glVertex2d(x (), y ());
//        glVertex2d(width (), y ());
//        glColor3ub(255,255,0);
//        glVertex2d(width (), height ());
//        glVertex2d(x (), height ());
//    glEnd();

//    QStaticText stText ("some text");
//    painter->drawStaticText (10, 10, stText);

//    update ();

//    cout << "pWidget.ptr=" << pWidget << endl;
//    cout << "objectName=" << pWidget->objectName ().toStdString () << endl;
//    cout << "className=" << pWidget->metaObject ()->className () << endl;
//    cout << "QmlCVCapture::paint (QPainter *painter, const QStyleOptionGraphicsItem *style, QWidget *pWidget)" << endl;

//    painter->end ();
    painter->endNativePainting ();

    QDeclarativeItem::paint (painter, style, pWidget);
}

void QmlCVCapture::createWidgetCVCapture (QWidget *parent, Ogre::Root *ogreRoot, HSynchCoordinates *pSynchCoordinates, QString postfixName) {
    m_widgetCVCapture = new HOgreWidget (parent, ogreRoot, pSynchCoordinates, postfixName);

    m_widgetCVCapture->setVisible (false);

//    m_Proxy = new QGraphicsProxyWidget (this);
//    m_Proxy->setWidget (m_widgetCVCapture);
}

void QmlCVCapture::createWidgetCVCapture (QGLWidget *parent, Ogre::Root *ogreRoot, HSynchCoordinates *pSynchCoordinates, QString postfixName) {
    m_widgetCVCapture = new HOgreWidget (parent, ogreRoot, pSynchCoordinates, postfixName);

//    m_Proxy = new QGraphicsProxyWidget (this);
//    m_Proxy->setWidget (m_widgetCVCapture);
}

int QmlCVCapture::setupResources (void) {
    int iRes = 0; //Success

    if (Ogre::TextureManager::getSingletonPtr ()) {
        // Set default mipmap level (note: some APIs ignore this)
        Ogre::TextureManager::getSingletonPtr ()->setDefaultNumMipmaps (5);
        // initialise all resource groups
        Ogre::ResourceGroupManager::getSingletonPtr ()->initialiseAllResourceGroups ();
    }
    else
        iRes = -1;

    cout << "HOgreWidget::setupResource: " << iRes << endl;

    return iRes;
}

int QmlCVCapture::start (void) {
    cout << "Start camera: " << this << endl;

    if (m_iIdTimerUpadate)
        killTimer (m_iIdTimerUpadate);

    m_iIdTimerUpadate = startTimer (getInterval ());
    if (m_iIdTimerUpadate) {
        m_widgetCVCapture->setVisible (true);

        return 0;
    }
    else
        return -1;
}

void QmlCVCapture::stop (void) {
    cout << "Stop camera: " << this << endl;
    if (m_iIdTimerUpadate > 0)
        killTimer (m_iIdTimerUpadate);

    m_iIdTimerUpadate = 0x0;

    if (m_widgetCVCapture)
        m_widgetCVCapture->setVisible (false);
}

void QmlCVCapture::timerEvent (QTimerEvent* tmEvt) {
    QPainter *pPainter = NULL;
    QPaintDevice *pPaintDevice = NULL;

//    _Отладка
//    cout << "timerId=" << tmEvt->timerId () << " для qmlCvCapture=" << objectName ().toStdString() << endl;
    if (tmEvt->timerId () == m_iIdTimerUpadate) {

//        pPaintDevice = m_widgetCVCapture->paintEngine ()->paintDevice ();
//        pPainter = m_widgetCVCapture->paintEngine ()->painter ();
//        if (pPainter)
//            pPainter->beginNativePainting ();

//        cout << "paintingActive=" << m_widgetCVCapture->paintingActive () << endl;
//        cout << "isEnabled=" << m_widgetCVCapture->isEnabled () << endl;
//        cout << "m_widgetCVCapture.ptr=" << m_widgetCVCapture << endl;
//        cout << "objectName=" << m_widgetCVCapture->objectName ().toStdString () << endl;
//        cout << "className=" << m_widgetCVCapture->metaObject ()->className () << endl;

        m_widgetCVCapture->out ();

//        update ();

//        pPainter->endNativePainting ();
    }
    else
        ; //Другой 'startTimer'
}

void QmlCVCapture::completed (void) {
    cout << metaObject ()->className () << "::onCompleted" << endl;
    cout << "objectName=" << objectName ().toStdString () << endl;
}
