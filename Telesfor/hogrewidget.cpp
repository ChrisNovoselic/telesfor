#include "hogrewidget.h"
#include "hmat.h"
#include "HQmlCVCapture.h"
#include <OgreTextureUnitState.h>

HOgreWidget::HOgreWidget (QWidget *parent, Ogre::Root *ogreRoot, HSynchCoordinates *pSynchCoordinates, QDeclarativeItem *parentQMLItem, QString postfixName) : QGLWidget (parent) {
//HOgreWidget::HOgreWidget (QWidget *parent) : QWidget (parent) {
    m_pSynchCoordinates = pSynchCoordinates;

    QObject::connect(m_pSynchCoordinates, SIGNAL (sgnCreateEntity (QString)), this, SLOT (onSgnCreateEntity (QString)));
    QObject::connect(m_pSynchCoordinates, SIGNAL (sgnDestroyEntity (QString)), this, SLOT (onSgnDestroyEntity (QString)));

    m_OgreRoot = ogreRoot, m_OgreSceneManager = 0, m_OgreRenderWindow = 0, m_OgreViewport = 0, m_OgreCamera = 0, m_OgreCameraNode = 0x0;
//    m_ProjectorPosterNode = 0x0;
    m_ptrBufferBackground= 0x0;
    m_szBackground = QSize (160, 120);

    m_parentQMLItem = parentQMLItem;

    m_strPostfixName = postfixName;

//    m_bFixedPSC = false;
    m_shCountEmptyArrayMarkers = 0;
    m_shCountSetArrayMarkers = 0;

    m_ptrVideoCapturer = NULL;

    std::string pathRes = "res//";
    m_InputCameraFile = pathRes + "cameraParametrs.yml";

//    m_fltOgreScale = 0.00675f * pow (2.0, 2.0);
//    m_vec3DOgreScale = QVector3D (0.00675f * pow (2.0, 2.0), 0.00675f * pow (2.0, 2.0), 0.00675f * pow (2.0, 2.0));
    m_vec3DOgreScale = QVector3D (0.027f, 0.027f, 0.027f);

    setMinimumSize (m_szBackground);
}

HOgreWidget::~HOgreWidget () {
    cout << "HOgreWidget::~HOgreWidget" << endl;

    m_ptrBufferBackground = NULL;

    m_InputImage.release ();
    m_InputImageUnd.release ();

    m_ptrVideoCapturer = NULL;

    releaseOgre ();
}

void HOgreWidget::releaseOgre (void) {
    if (m_OgreRoot) {
        if (m_OgreRenderWindow) {
//            1-ый вариант освобождения 'Ogre::Viewport'


//            if (m_OgreViewport) {
//                2-ой вариант освобождения 'Ogre::Viewport'
//                m_OgreViewport->clear ();
//                delete m_OgreViewport;
//                m_OgreViewport = NULL;
//            }
//            else {
//                3-ий вариант освобождения 'Ogre::Viewport'
//                Ogre::Viewport *pOgreViewport = NULL;
//                for (unsigned short i = 0; i < m_OgreRenderWindow->getNumViewports (); i ++) {
//                    pOgreViewport = m_OgreRenderWindow->getViewport (i);
//                    pOgreViewport->clear ();
//                    delete pOgreViewport;
//                }
//            }

            if (m_OgreSceneManager) {
                m_OgreSceneManager->destroyAllCameras ();
//                if (m_OgreCamera) {
//                    delete m_OgreCamera;
                    m_OgreCamera = NULL;
                    delete m_OgreCameraNode;
                    m_OgreCameraNode = NULL;
//                }
//                else
//                    ;

                Ogre::String uniquename;

//                Ogre::SceneManager::SceneNodeList::iterator it;
//                for (it = m_OgreSceneManager->mSceneNodes.begin(); it != m_OgreSceneManager->mSceneNodes.end (); ++ it) {
//                    uniquename = it->first;
//                    cout << uniquename.c_str () << endl;
//                }

//                Ogre::SceneManager::MovableObjectIterator it;
//                it = m_OgreSceneManager->getMovableObjectIterator ("SceneNode");
//                while (it.hasMoreElements ())
//                {
//                    uniquename = it.getNext ()->getName ();
//                    cout << uniquename.c_str () << endl;
//                }

                ;
//                Ogre::SceneNode::ObjectIterator it = m_OgreSceneManager->getRootSceneNode ()->getAttachedObjectIterator ();
//                Ogre::SceneManager::MovableObjectIterator it = m_OgreSceneManager->getMovableObjectIterator ("SceneNode");
//
//                coutDebugNode (m_OgreSceneManager->getRootSceneNode ()->getName (), m_OgreSceneManager->getRootSceneNode ());

                Ogre::SceneNode::ObjectIterator it = m_OgreSceneManager->getRootSceneNode ()->getAttachedObjectIterator ();
                Ogre::Entity *ptrEntity = NULL;
                it.begin ();
                while (it.hasMoreElements ()) {
                    ptrEntity = (Ogre::Entity *) it.getNext ();
                    uniquename = ptrEntity->getName ();
                    ptrEntity->getParentNode ();
                    ptrEntity->getParentSceneNode ();
//                    ptrEntity->getMovableType ()
//                    cout << uniquename.c_str () << endl;

//                    it.moveNext ();
                }

                m_OgreSceneManager->destroyAllAnimations();
                m_OgreSceneManager->destroyAllAnimationStates();
                m_OgreSceneManager->destroyAllBillboardChains();
                m_OgreSceneManager->destroyAllBillboardSets();
//                m_OgreSceneManager->destroyAllCameras ();
                m_OgreSceneManager->destroyAllEntities();
                m_OgreSceneManager->destroyAllInstancedGeometry();
                m_OgreSceneManager->destroyAllLights();
                m_OgreSceneManager->destroyAllManualObjects();
                m_OgreSceneManager->destroyAllMovableObjects();
//                m_OgreSceneManager->destroyAllMovableObjectsByType();
                m_OgreSceneManager->destroyAllParticleSystems();
                m_OgreSceneManager->destroyAllRibbonTrails();
                m_OgreSceneManager->destroyAllStaticGeometry();
//                m_OgreSceneManager->clearScene ();

                m_OgreSceneManager->getRootSceneNode ()->detachAllObjects ();
                m_OgreSceneManager->getRootSceneNode ()->removeAndDestroyAllChildren ();

//                m_OgreSceneManager->clearScene ();

//                m_OgreRoot->destroySceneManager (m_OgreSceneManager);
//                delete m_OgreSceneManager; ???
//                m_OgreSceneManager = NULL;
            }

            m_OgreViewport->clear ();

            m_OgreRenderWindow->removeAllViewports ();

//            if (m_OgreViewport) {
//                delete m_OgreViewport;

//            }
//            else
//                ;

            m_OgreRoot->detachRenderTarget (m_OgreRenderWindow);
//            m_OgreRoot->destroyRenderTarget ();

            delete m_OgreRenderWindow;
            m_OgreRenderWindow = NULL;
        }

//        delete m_OgreRoot;
    }
    else
        ;

//    m_OgreRoot = NULL;
}

void HOgreWidget::coutDebugNode (Ogre::String name, Ogre::Node *ptrNode) {
    int iCountChild = 0;
    Ogre::String uniquename;
    Ogre::Node *ptrChildNode = NULL;
    Ogre::Node::ChildNodeIterator itChild = ptrNode->getChildIterator ();

    itChild.begin ();
    while (itChild.hasMoreElements ()) {
        ptrChildNode = itChild.getNext ();
        uniquename = ptrChildNode->getName ();
//        cout << uniquename.c_str () << endl;

        iCountChild ++;

//        coutDebugNode (ptrChildNode->getName (), ptrChildNode);
    }

//    cout << "Для " << name << " число child=" << iCountChild << endl;
}

void HOgreWidget::onSgnCreateEntity (QString key) {
    if (! (m_OgreSceneManager == NULL)) {
        if (! (createOgreEntity (key,
                                 m_pSynchCoordinates->getObjectReality (key)->sourceEntity (),
                                 m_pSynchCoordinates->getObjectReality (key)->placement ("size")->getSliderValues ()) == 0)) {
            cout << metaObject ()->className () << "::onSgnCreateEntity - Entity with name " << key.toStdString () << " can't create!" << endl;
        }
        else
            cout << metaObject ()->className () << "::onSgnCreateEntity - Entity with name " << key.toStdString () << " create success!" << endl;
    }
    else
        ;
}

void HOgreWidget::onSgnDestroyEntity (QString key) {
    Ogre::SceneNode *pRemoveNode = NULL;

    if (! (m_OgreSceneManager == NULL)) {
        cout << "Remove Entity from SCENe with name=" << key.toStdString () << "!" << endl;

//    int iRes = 0; //Success

        if (! (key.isEmpty ())) {
            if (m_mapOgreObjectNode [key]) {
                if (m_mapOgreEntity [key]) {
//                    m_mapOgreObjectNode [key]->removeAndDestroyChild (Ogre::String (key.toStdString ()));
                    m_mapOgreObjectNode [key]->detachObject (Ogre::String (key.toStdString ()));
                    m_OgreSceneManager->destroyEntity (Ogre::String (key.toStdString ()));
                    m_mapOgreEntity.remove (key);

                    m_OgreSceneManager->getRootSceneNode ()->removeAndDestroyChild (Ogre::String (key.toStdString ()));
                    m_mapOgreObjectNode.remove (key);
                }
                else
                    ; //m_mapOgreEntity not have
            }
            else
                ;
        }
        else
            ;
    }
    else
        ;

//    return iRes;
}

int HOgreWidget::createOgreSceneManager (void) {
    int iRes = 0; //Success

    // Create the SceneManager, in this case a generic one
    // m_OgreSceneManager = m_OgreRoot->createSceneManager (QString ("sceneManager" + m_strPostfixName).toStdString ());
    m_OgreSceneManager = m_OgreRoot->createSceneManager(Ogre::ST_GENERIC);

    if (m_OgreSceneManager == NULL)
        iRes = -1;

    cout << "HOgreWidget::createOgreSceneManager: " << iRes << endl;

    return iRes;
}

int HOgreWidget::initOgre (void) {
    int iRes = -1;

    if (isInitAR () == 0) {
//    if (parentWidget ()) {

        if (m_OgreRoot)
//            if (loadResources () == 0)
//                if (isInitAR () == 0)
//                    if (initRenderSystem () == 0)
                        if (createOgreRenderWindow () == 0)
                            if (createOgreSceneManager () == 0)
                                if (setupResources () == 0)
                                    if (createCameraBackground () == 0)
                                        if (createOgreCamera () == 0)
                                            if (createOgreViewport () == 0)
                                                if (createOgreMaterials () == 0)
                                                    if (createOgreScene () == 0)
                                                        iRes = 0;

        if (! (iRes == 0))
            releaseOgre ();
    }
    else
        ;

    cout << "HOgreWidget::initOgre: " << iRes << endl;

    return iRes;
}

int HOgreWidget::createOgreRenderWindow (void) {
    int iRes = 0; //Success

    QTime tmLoop;
    tmLoop.start ();
    while (tmLoop.elapsed () < 666);

    bool bMainRenderWindow = false;

    if (bMainRenderWindow)
        m_OgreRenderWindow = m_OgreRoot->initialise (bMainRenderWindow);
    else {
        m_OgreRoot->initialise (bMainRenderWindow);

//        m_OgreSceneManager = m_OgreRoot->createSceneManager(Ogre::ST_GENERIC);

        Ogre::NameValuePairList viewConfig;

    //    QWidget *q_parent = dynamic_cast <QWidget *> (parentWidget ());
        QX11Info xInfo = x11Info ();

    //    size_t widgetHandle;
        Ogre::String widgetHandle = Ogre::StringConverter::toString ((unsigned long) xInfo.display ()) +
                ":" + Ogre::StringConverter::toString ((unsigned int)xInfo.screen ()) +
                ":" + Ogre::StringConverter::toString ((unsigned long) winId ());
//                ":" + Ogre::StringConverter::toString ((unsigned long) parentWidget ()->winId ());

        std::cout << widgetHandle.c_str () << endl;

        viewConfig ["externalWindowHandle"] = widgetHandle;
//        viewConfig ["parentWindowHandle"] = widgetHandle;

//        viewConfig ["externalGLControl"] = "true";
//        viewConfig ["currentGLContext"] = "true";

        m_OgreRenderWindow = m_OgreRoot->createRenderWindow (QString ("Ogre rendering window " + m_strPostfixName).toStdString (), width (), height (), false, &viewConfig);

//        m_OgreCamera = m_OgreSceneManager->createCamera ("camera");
//        m_OgreCamera->setAspectRatio (Ogre::Real (width ()) / Ogre::Real (height ()));

//        m_OgreViewport = m_OgreRenderWindow->addViewport (m_OgreCamera);
//        m_OgreViewport->setBackgroundColour (Ogre::ColourValue (1.0, 0.5, 0.9));

    }

    cout << "HOgreWidget::createOgreRenderWindow: " << "size={" << width () << "," << height () << "}; код выхода=" << iRes << endl;

    return iRes;
}

int HOgreWidget::setupResources (void) {
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

int HOgreWidget::createCameraBackground (void) {
    int iRes = 0; //Success

    if (m_szBackground.width () == 0 || m_szBackground.height () == 0 || m_ptrBufferBackground == 0) {
        std::cout << "Image size or buffer not defined in user-defined init function" << std::endl;

        iRes = -1;
    }
    else {
        QString strCameraMaterial = "cameraMaterial" + m_strPostfixName,
                strCameraTexture  = "cameraTexture" + m_strPostfixName;

        // create background texture
        m_PixelBox = Ogre::PixelBox(m_szBackground.width (), m_szBackground.height (), 1, Ogre::PF_R8G8B8, m_ptrBufferBackground);
        // Create Texture
        m_Texture = Ogre::TextureManager::getSingleton().createManual (
                  strCameraTexture.toStdString (),
                  Ogre::ResourceGroupManager::DEFAULT_RESOURCE_GROUP_NAME,
                  Ogre::TEX_TYPE_2D,
                  m_szBackground.width (),
                  m_szBackground.height (),
                  0,
                  Ogre::PF_R8G8B8,
                  Ogre::TU_DYNAMIC);

        //Create Camera Material
        Ogre::MaterialPtr material = Ogre::MaterialManager::getSingleton ().create (strCameraMaterial.toStdString (), Ogre::ResourceGroupManager::DEFAULT_RESOURCE_GROUP_NAME);
        Ogre::Technique *technique = material->createTechnique ();
        technique->createPass ();
//        material->getTechnique (0)->getPass (0)->setLightingEnabled (false);
        material->getTechnique (0)->getPass (0)->setDepthWriteEnabled (false);
        material->getTechnique (0)->getPass (0)->createTextureUnitState (strCameraTexture.toStdString ());

        // Create background rectangle covering the whole screen
        Ogre::Rectangle2D* rect = new Ogre::Rectangle2D (true);
        rect->setCorners (-1.0, 1.0, 1.0, -1.0);
        rect->setMaterial (strCameraMaterial.toStdString ());

        // Render the background before everything else
        rect->setRenderQueueGroup (Ogre::RENDER_QUEUE_BACKGROUND);

        // Hacky, but we need to set the bounding box to something big
        // Use infinite AAB to always stay visible
        Ogre::AxisAlignedBox aabInf;
        aabInf.setInfinite ();
        rect->setBoundingBox (aabInf);

        // Attach background to the scene
        Ogre::SceneNode* node = m_OgreSceneManager->getRootSceneNode ()->createChildSceneNode (QString ("background" + m_strPostfixName).toStdString ());
        node->attachObject (rect);
    }

    cout << metaObject ()->className () << "::createCameraBackground: " << iRes << endl;

    return iRes;
}

int HOgreWidget::createOgreViewport (void) {
    int iRes = 0; //Success

    if (m_OgreRenderWindow && m_OgreCamera) {
        //mViewport->setCamera (mCamera);
        cout << "HOgreWidget::createOgreViewport - count Viewport's of RenderWindow=" << m_OgreRenderWindow->getNumViewports () << endl;
        if (m_OgreRenderWindow->getNumViewports ())
            m_OgreRenderWindow->removeAllViewports();
        cout << "HOgreWidget::createOgreViewport - count Viewport's of RenderWindow=" << m_OgreRenderWindow->getNumViewports () << endl;

        m_OgreViewport = m_OgreRenderWindow->addViewport (m_OgreCamera);
//        m_OgreViewport = m_OgreRenderWindow->addViewport (m_OgreCamera, 0, x (), y (), width (), height ());
        cout << "HOgreWidget::createOgreViewport - attributes of Viewport={" << endl;
        cout << "" << "actualLeft=" << m_OgreViewport->getActualLeft () << ", left=" << m_OgreViewport->getLeft () << endl;
        cout << "" << "actualTop=" << m_OgreViewport->getActualTop () << ", top=" << m_OgreViewport->getTop () << endl;
        cout << "" << "actualWidth=" << m_OgreViewport->getActualWidth () << ", width=" << m_OgreViewport->getWidth () << endl;
        cout << "" << "actualHeight=" << m_OgreViewport->getActualHeight () << ", height=" << m_OgreViewport->getHeight () << "}" << endl;

        if (m_OgreViewport == NULL)
            iRes = -1;
        else {
//            setAttribute(Qt::WA_OpaquePaintEvent);
//            setAttribute(Qt::WA_PaintOnScreen);
            setAttribute(Qt::WA_NoSystemBackground);

            m_OgreViewport->setBackgroundColour (Ogre::ColourValue (0.5, 0.5, 0.5));
//            m_OgreViewport->setBackgroundColour (Ogre::ColourValue (0.0, 1.0, 1.0));
        }
    }
    else
        iRes = -1;

    cout << "HOgreWidget::createOgreViewport: " << iRes << endl;

    return iRes;
}

int HOgreWidget::createOgreCamera (void) {
    int iRes = 0; //Success

    m_OgreCamera = m_OgreSceneManager->createCamera ("camera");
    m_OgreCamera->setAspectRatio (Ogre::Real (width ()) / Ogre::Real (height ()));

    if (m_OgreCamera) {
        //FROM A 'aruco_test_ogre.cpp'
        // configure Ogre Camera
        m_OgreCamera->setProjectionType (Ogre::PT_ORTHOGRAPHIC);
        m_OgreCamera->setNearClipDistance (0.01f);
        m_OgreCamera->setFarClipDistance (10.0f);

        double pMatrix [16];
        m_CameraParamsUnd.OgreGetProjectionMatrix ( m_CameraParamsUnd.CamSize,
                                                    m_CameraParamsUnd.CamSize,
                                                    pMatrix,
                                                    0.05,
                                                    10,
                                                    false);

        Ogre::Matrix4 PM (pMatrix [0], pMatrix [1], pMatrix [2] , pMatrix [3],
                         pMatrix [4], pMatrix [5], pMatrix [6] , pMatrix [7],
                         pMatrix [8], pMatrix [9], pMatrix [10], pMatrix [11],
                         pMatrix [12], pMatrix [13], pMatrix [14], pMatrix [15]);

        m_OgreCamera->setCustomProjectionMatrix (true, PM);
        m_OgreCamera->setCustomViewMatrix (true, Ogre::Matrix4::IDENTITY);

        m_OgreCameraNode = m_OgreSceneManager->getRootSceneNode ()->createChildSceneNode ("cameraNode");

        if (m_OgreCameraNode) {
            m_OgreCameraNode->attachObject (m_OgreCamera);
            //mCameraNode->setFixedYawAxis (true, Vector3::UNIT_Y);//
        }
        else
            iRes = -1;
    }
    else
        iRes = -1;

    cout << "HOgreWidget::createOgreCamera: " << iRes << endl;

    return iRes;
}

int HOgreWidget::createOgreEntity (QString key, QString src, float scaleX, float scaleY, float scaleZ) {
    createOgreEntity (key, src, QVector3D (scaleX, scaleY, scaleZ));
}

int HOgreWidget::createLattice (Ogre::SceneNode *parentNode, QString nameNode) {
    //Х -> ВПРАВО от ЦФК
    //Y -> ВВЕРХ от ЦФК
    //Z -> НА НАС от ЦФК
    //РешЁткА в плоскости МАРКЕРа (XY)---0.01, 1.0, 0.01---1.0, 0.01, 0.01---
    //РешЁткА  на 90 вокруг X относительно плоскости МАРКЕРа (YZ)---0.01, 0.01, 1.0---0.01, 1.0, 0.01---
    //РешЁткА  на 90 вокруг Y относительно плоскости МАРКЕРа (XZ)---0.01, 0.01, 1.0---1.0, 0.01, 0.01---

    unsigned int i = -1, iCountVertical = m_pSynchCoordinates->count_lattice_line (),
                        iCountHorizontal = m_pSynchCoordinates->count_lattice_line ();
    Ogre::Entity *ptrEntity = NULL;
    Ogre::SceneNode *ptrNode = 0x0;

    Ogre::AxisAlignedBox axisAlignedBoxVertical, axisAlignedBoxHorizontal;
    Ogre::Vector3 vec3ScaleConst,
                vec3TranslateVertical, vec3ScaleVertical,
                vec3TranslateHorizontal, vec3ScaleHorizontal;

    if (((m_parentQMLItem->objectName ().contains ("Base") == true) && (nameNode.contains ("Front") == true)) ||
        ((m_parentQMLItem->objectName ().contains ("Face") == true) && (nameNode.contains ("Rear") == true))) {

        vec3ScaleConst = Ogre::Vector3 (0.01, 0.01, 0.01);

//        ПОЧЕМу создаютСя ОБе решЁтКи ???
        if (nameNode.contains ("Front") == true) {
            vec3ScaleVertical = Ogre::Vector3 (1, 100, 1), vec3TranslateVertical = Ogre::Vector3 (1, 0, 0);
            vec3ScaleHorizontal = Ogre::Vector3 (100, 1, 1), vec3TranslateHorizontal = Ogre::Vector3 (0, 1, 0);
        }
        else {
            if (nameNode.contains ("Rear") == true) {
                vec3ScaleVertical = Ogre::Vector3 (1, 100, 1), vec3TranslateVertical = Ogre::Vector3 (0, 0, 1);
                vec3ScaleHorizontal = Ogre::Vector3 (1, 1, 100), vec3TranslateHorizontal = Ogre::Vector3 (0, 1, 0);
            }
            else {
            }
        }

        std::stringstream entityName, nodeName;

        for (i = 0; i < iCountVertical; i ++) {
            entityName.str (std::string ());
            entityName << nameNode.toStdString () << "EntityVertical" << i;
            cout << entityName.str () << endl;
            ptrEntity =  m_OgreSceneManager->createEntity (entityName.str (), "Cube.mesh");
            ptrEntity->setMaterialName ("materialLattice");
            m_arEntityLatticeVertical.insert (i, ptrEntity);

            nodeName.str (std::string ());
            nodeName << nameNode.toStdString () << "NodeVertical" << i;
//            cout << nodeName.str () << endl;
            ptrNode = parentNode->createChildSceneNode (nodeName.str ());
            if ((! (i == 0)) && (! (i == (iCountVertical - 1))))
                ptrNode->attachObject (m_arEntityLatticeVertical.at (i));
            else
                ;
            m_arNodeLatticeVertical.insert (i, ptrNode);

//            m_arNodeLatticeVertical [i]->setScale (m_vec3DOgreScale.x () * 0.1, m_vec3DOgreScale.y (), m_vec3DOgreScale.z () * 0.1);
            m_arNodeLatticeVertical [i]->setScale (vec3ScaleConst * vec3ScaleVertical); ////На 90 вокруг X - растЯнутЫ по ВЫСОТе
//            m_arNodeLatticeVertical [i]->setScale (0.01, 0.01, 1.0); //в плоскости МАРКЕРа - растЯнутЫ по ГЛУБИНе
            m_arNodeLatticeVertical [i]->setVisible (false);

            if (axisAlignedBoxVertical.isNull ())
                axisAlignedBoxVertical = m_arEntityLatticeVertical.at (i)->getBoundingBox ();

            //На 90 вокруг X
            m_arNodeLatticeVertical [i]->translate (Ogre::Vector3 (-axisAlignedBoxVertical.getHalfSize ().z + axisAlignedBoxVertical.getSize ().z / (iCountVertical - 1) * i,
                                                                   -axisAlignedBoxVertical.getHalfSize ().z + axisAlignedBoxVertical.getSize ().z / (iCountVertical - 1) * i,
                                                                   -axisAlignedBoxVertical.getHalfSize ().z + axisAlignedBoxVertical.getSize ().z / (iCountVertical - 1) * i) *
                                                                vec3TranslateVertical);
            //в плоскости МАРКЕРа
//            m_arNodeLatticeVertical [i]->translate (Ogre::Vector3 (-axisAlignedBoxVertical.getHalfSize ().z + axisAlignedBoxVertical.getSize ().z / (iCountVertical - 1) * i, 0, 0));
//            m_arNodeLatticeVertical [i]->translate (Ogre::Vector3 (-1 + 0.2 * i, 0, 0));
        }

        for (i = 0; i < iCountHorizontal; i ++) {
            entityName.str (std::string ());
            entityName << nameNode.toStdString () << "EntityHorizontal" << i;
            ptrEntity =  m_OgreSceneManager->createEntity (entityName.str (), "Cube.mesh");
            ptrEntity->setMaterialName ("materialLattice");
            m_arEntityLatticeHorizontal.insert (i, ptrEntity);

            nodeName.str (std::string ());
            nodeName << nameNode.toStdString () << "NodeHorizontal" << i;
            ptrNode = parentNode->createChildSceneNode (nodeName.str ());
            if ((! (i == 0)) && (! (i == (iCountVertical - 1))))
                ptrNode->attachObject (m_arEntityLatticeHorizontal.at (i));
            else
                ;
            m_arNodeLatticeHorizontal.insert (i, ptrNode);

//            m_arNodeLatticeHorizontal [i]->setScale (m_vec3DOgreScale.x (), m_vec3DOgreScale.y () * 0.1, m_vec3DOgreScale.z () * 0.1);
            m_arNodeLatticeHorizontal [i]->setScale (vec3ScaleConst * vec3ScaleHorizontal); //в плоскости МАРКЕРа - растЯнутЫ по ШИРИНе
            m_arNodeLatticeHorizontal [i]->setVisible (false);

            if (axisAlignedBoxHorizontal.isNull ())
                axisAlignedBoxHorizontal = m_arEntityLatticeVertical.at (i)->getBoundingBox ();
            else
                ;

            m_arNodeLatticeHorizontal [i]->translate (Ogre::Vector3 (-axisAlignedBoxHorizontal.getHalfSize ().z + axisAlignedBoxHorizontal.getSize ().z / (iCountHorizontal - 1) * i,
                                                                     -axisAlignedBoxHorizontal.getHalfSize ().z + axisAlignedBoxHorizontal.getSize ().z / (iCountHorizontal - 1) * i,
                                                                     -axisAlignedBoxHorizontal.getHalfSize ().z + axisAlignedBoxHorizontal.getSize ().z / (iCountHorizontal - 1) * i) *
                                                                      vec3TranslateHorizontal);
            //в плоскости МАРКЕРа
//            m_arNodeLatticeHorizontal [i]->translate (Ogre::Vector3 (0, 0, -axisAlignedBoxHorizontal.getHalfSize ().z + axisAlignedBoxHorizontal.getSize ().z / (iCountHorizontal - 1) * i));
        }
    }
    else
        ;
}

void HOgreWidget::onCheckedLatticeLine (int number, bool checked, QColor col) {
//    cout << "HOgreWidget::onCheckedLatticeLine" << " " << m_arEntityLatticeHorizontal [number]->getName () << " " << m_arEntityLatticeHorizontal.size () << endl;

    if (m_arEntityLatticeHorizontal.size ()) {
//        ОбесЦВЕчиваЕм все элементЫ решЁткИ
//        for (int i = 1; i < m_arEntityLatticeHorizontal.size () - 1; i ++) {
////            ПОЧЕМу создаютСя ОБе решЁтКи ???
//            m_arEntityLatticeHorizontal [i]->setMaterialName ("materialLattice");
//        }

        if (checked) {
//            ПОЧЕМу создаютСя ОБе решЁтКи ??? ЗДЕСь д.б. ОДНа строКа (длЯ ОДНой реШётКи)!!!
            m_arEntityLatticeHorizontal [m_pSynchCoordinates->count_lattice_line () - (number + 1)]->setMaterialName ("materialLatticeCheckedLine");
//            m_arEntityLatticeHorizontal [2 * m_pSynchCoordinates->count_lattice_line () - (number + 1)]->setMaterialName ("materialBlue");
        }
        else
            m_arEntityLatticeHorizontal [m_pSynchCoordinates->count_lattice_line () - (number + 1)]->setMaterialName ("materialLattice");
    }
    else
        ;
}

int HOgreWidget::createOgreEntity (QString key, QString src, QVector3D vec3DScale) {
    int iRes = 0; //Success
    Ogre::String materialName = "materialGreen";
//    Ogre::Real rRed, rGreen, rBlue, rAlfa;
//    Ogre::MaterialPtr material;
//    Ogre::Pass* pass = NULL;

//    std::stringstream entityName;
//    entityName << "marker_" << i;

    if (key.length () && (m_mapOgreEntity [key] == NULL)) {
//        БЛОК созданиЯ 'ENTITY'
//        if (key.compare ("Lattice", Qt::CaseSensitive) == 0) {
        if (key.contains ("Lattice", Qt::CaseSensitive) == true) {
//            МноЖестВо Entity созДадИМ толЬко после создАНия 'Node' ВЕРХненго уровнЯ
        }
        else {
            m_mapOgreEntity [key] = m_OgreSceneManager->createEntity (key.toStdString (), src.toStdString ());
//            cout << src.toStdString () << endl;
//            m_mapOgreEntity [key] = m_OgreSceneManager->createEntity (key.toStdString (), "Sinbad.mesh");

            if (m_mapOgreEntity [key]) {
                if (key.contains ("Trace")) {
                    if (key.mid (QString ("Trace").length (), key.length () - QString ("Trace").length ()).toInt () % 2 == 0) {
//                        Все 'СЛЕДы' чЁтнЫЕ СИНего цветА
                        materialName = "materialBlue";
                    }
                    else {
//                        Все 'СЛЕДы' НЕчЁтнЫЕ КРАСНого цветА
                        materialName = "materialRed";
                    }

                    m_mapOgreEntity [key]->setMaterialName (materialName);

    //                material = Ogre::MaterialManager::getSingleton ().getByName (materialName);
    //                pass = material->getTechnique (0)->getPass (0);
    //                Ogre::ColourValue diffuseColour = pass->getDiffuse ();
    //                rRed = diffuseColour.r, rGreen = diffuseColour.g, rBlue = diffuseColour.b,
    //                rAlfa = m_pSynchCoordinates->m_mapObjectReality [key]->opacity ();
    //                cout << "diffuseColour {Red=" << rRed << ", Green=" << rGreen << ", Blue=" << rBlue << ", Alpha=" << rAlfa << "}" << endl;
    //                pass->setDiffuse (rRed, rGreen, rBlue, rAlfa);

    //                if (rAlfa < 1.0)
    //                    pass->setSceneBlending (Ogre::SBT_TRANSPARENT_ALPHA);
    //                else
    //                    pass->setSceneBlending (Ogre::SBF_ONE, Ogre::SBF_ZERO);
                }
                else {
//                    Все НЕ 'СЛЕДы' ЗЕЛёНОГо цветА
                    m_mapOgreEntity [key]->setMaterialName (materialName);
                }

                Ogre::AxisAlignedBox axisAlignedBox = m_mapOgreEntity [key]->getBoundingBox ();
                m_mapOgreEntityTrueSize [key] = axisAlignedBox.getSize ();
            }
            else {
                cout << metaObject ()->className () << "::createOgreEntity with name=" << key.toStdString () << " with source=" << src.toStdString () << " Entity can't create" << endl;
                iRes = -1;
            }
        }

//        БЛОК созданиЯ 'NODE' для 'ENTITY'
        if (iRes == 0) {
            m_mapOgreObjectNode [key] = m_OgreSceneManager->getRootSceneNode ()->createChildSceneNode (Ogre::String (key.toStdString ()));

        if (m_mapOgreObjectNode [key]) {
//            if (key.compare ("Lattice", Qt::CaseSensitive) == 0) {
            if (key.contains ("Lattice", Qt::CaseSensitive) == true) {
                createLattice (m_mapOgreObjectNode [key], key); //Если уж ПЕРЕДАёМ 'key', тогда ЗАЧЕм передаваТЬ 'Node' ???
            }
            else {
                m_mapOgreObjectNode [key]->attachObject (m_mapOgreEntity [key]);

//                m_mapOgreObjectNode [key]->setScale (m_vec3DOgreScale.x () * vec3DScale.x (), m_vec3DOgreScale.y () * vec3DScale.z (), m_vec3DOgreScale.z () * vec3DScale.z ());
                m_mapOgreObjectNode [key]->setScale (m_vec3DOgreScale.x (), m_vec3DOgreScale.y (), m_vec3DOgreScale.z ());
                m_mapOgreObjectNode [key]->setVisible (false);

                //Init animation
//                m_mapOgreEntity [key]->getSkeleton ()->setBlendMode (Ogre::ANIMBLEND_CUMULATIVE);
//                m_mapBaseAnimation [key] = m_mapOgreEntity [key]->getAnimationState ("RunBase");
//                m_mapTopAnimation [key] = m_mapOgreEntity [key]->getAnimationState ("Dance");
//                m_mapBaseAnimation [key]->setLoop (true);
//                m_mapTopAnimation [key]->setLoop (true);
//                m_mapBaseAnimation [key]->setEnabled (true);
//                m_mapTopAnimation [key]->setEnabled (true);

                    cout << metaObject ()->className () << "::createOgreEntity with name=" << key.toStdString () << " with source=" << src.toStdString () << " and iRes=" << iRes << endl;
                }
            }
        }
        else {
            cout << metaObject ()->className () << "::createOgreEntity with name=" << key.toStdString () << " with source=" << src.toStdString () << " Node can't create" << endl;
            iRes = -1;
        }
    }
    else {
        cout << metaObject ()->className () << "::createOgreEntity name is Null" << endl;
        iRes = -1; //
    }

    return iRes;
}

int HOgreWidget::createOgreScene (void) {
    int iRes = 0; //Success

    unsigned int i = 0;
    QList <QString> listNameObjectReality = m_pSynchCoordinates->getListNameObjectReality ();
    QString strKeyObjectReality;

//    for (i; i < 64; i ++) {
    for (i; i < listNameObjectReality.size (); i ++) {
        strKeyObjectReality = listNameObjectReality.at (i);
        if (! (createOgreEntity (strKeyObjectReality,
                                 m_pSynchCoordinates->getObjectReality (strKeyObjectReality)->sourceEntity (),
                                 m_pSynchCoordinates->getObjectReality (strKeyObjectReality)->placement ("size")->getSliderValues ()) == 0)) {
            cout << metaObject ()->className () << "::createOgreScene - Entity with name " << strKeyObjectReality.toStdString () << "can't create!" << endl;
            iRes = -1;
            break; //break of 'for'
        }
        else
            ; //Create entity + Node = success
    } //loop 'for'

    if (iRes == 0) {
        // Set ambient light
//        m_OgreSceneManager->setAmbientLight (Ogre::ColourValue (0.0, 1.0, 1.0));

        // Create a light
        Ogre::Light* l = m_OgreSceneManager->createLight ("Light");
//        l->setPosition (20, 80, 50);
        l->setPosition (0, 1, -10);

        m_OgreSceneManager->getRootSceneNode()->attachObject (l);
    }
    else
        iRes = -1;

    cout << metaObject ()->className() << "::createOgreScene: " << iRes << endl;

    return iRes;
}

int HOgreWidget::createMaterial (Ogre::String name, Ogre::ColourValue colourAmbient, Ogre::ColourValue colourDiffuse, Ogre::Real alpha, Ogre::String texture) {
    int iRes = 0; //Success
//    Ogre::Real rRed = 0.0, rGreen = 1.0, rBlue = 0.0, rAlfa = 1.0;
//    Ogre::MaterialPtr material;
    Ogre::Pass* pass = NULL;
    Ogre::TextureUnitState* tuisTexture = NULL;

//        Попытка создфть СВОй материал -----------------------------------------------------------
    Ogre::MaterialPtr material = Ogre::MaterialManager::getSingleton ().create ("material" + name, Ogre::ResourceGroupManager::DEFAULT_RESOURCE_GROUP_NAME);
//    material->getTechnique (0)->getPass (0)->createTextureUnitState ("camera-47-1852.jpg");
    material->setReceiveShadows (true);
    pass = material->getTechnique (0)->getPass (0);

    if (pass) {
        if (texture.empty ()) {
//            ambient 0.04999694973230362 0.0 0.800000011920929 1.0
            pass->setAmbient (colourAmbient);
//            diffuse 0.03999756038185298 0.0 0.6400000190734865 1.0
            pass->setDiffuse (colourDiffuse.r, colourDiffuse.g, colourDiffuse.b, alpha);
//            specular 0.5 0.5 0.5 1.0 12.5
            pass->setSpecular (0.5, 0.5, 0.5, 1.0);
        }
        else {
            Ogre::Pass* passPlane = NULL;
            Ogre::MaterialPtr materialPlane = Ogre::MaterialManager::getSingleton ().getByName ("Plane");
            passPlane = materialPlane->getTechnique (0)->getPass (0);
            tuisTexture = passPlane->getTextureUnitState (0);

//            Попытка управления ПРОЕКТОРом текстуры для оБЪектА 'Wall'
//            Ogre::Frustum *frustumPoster = new Ogre::Frustum ();
//            frustumPoster->setProjectionType (Ogre::PT_ORTHOGRAPHIC);
//            m_ProjectorPosterNode = m_OgreSceneManager->getRootSceneNode()->createChildSceneNode ("DecalProjectorNode");
//            m_ProjectorPosterNode->attachObject(frustumPoster);
//            m_ProjectorPosterNode->setPosition (0, 0, 0);

//            tuisTexture = pass->createTextureUnitState (texture, Ogre::TEX_TYPE_2D); //
//            tuisTexture->setColourOperationEx (Ogre::LBX_SOURCE1);
//            tuisTexture->setColourOperationEx (Ogre::LBX_BLEND_MANUAL,
//                                               Ogre::LBS_CURRENT,
//                                               Ogre::LBS_TEXTURE,
//                                               Ogre::ColourValue::White,
//                                               Ogre::ColourValue::White,
//                                               0.3);

            passPlane->setDepthWriteEnabled (false);
            passPlane->setLightingEnabled (false);

//            tuisTexture->setTextureFiltering(Ogre::FO_POINT, Ogre::FO_LINEAR, Ogre::FO_NONE);

//            tuisTexture->setTextureCoordSet (0);
            tuisTexture->setTextureAddressingMode (Ogre::TextureUnitState::TAM_WRAP);
//            tuisTexture->setContentType (Ogre::TextureUnitState::CONTENT_COMPOSITOR);
//            tuisTexture->setEnvironmentMap(true, Ogre::TextureUnitState::ENV_PLANAR);

//            tuisTexture->setTextureAnisotropy (2);
//            cout << "TextureAnisotropy ()=" << tuisTexture->getTextureAnisotropy () << endl;

//            tuisTexture->setBindingType (Ogre::TextureUnitState::BT_VERTEX);

//            tuisTexture->setScrollAnimation (0.1, 0.9);
//            tuisTexture->setRotateAnimation (0.5);

//            Попытка управления ПРОЕКТОРом текстуры для оБЪектА 'Wall'
//            tuisTexture->setProjectiveTexturing (true, frustumPoster);
//            tuisTexture->setProjectiveTexturing (true, m_OgreCamera);
            //            tuisTexture->setProjectiveTexturing (true);

            //            pass->setAmbient (colourAmbient);
            //            pass->setDiffuse (colourDiffuse.r, colourDiffuse.g, colourDiffuse.b, alpha);
            //            pass->setSpecular (0.9, 0.9, 0.9, 1.0);
                    }

            //        emissive 0.0 0.0 0.0 1.0

            //        alpha_to_coverage off
                    pass->setAlphaToCoverageEnabled (false);
            //        colour_write on
                    pass->setColourWriteEnabled (true);
            //        cull_hardware clockwise
                    pass->setCullingMode (Ogre::CULL_CLOCKWISE);
            //        depth_check on
                    pass->setDepthCheckEnabled (true);
            //        depth_func less_equal
                    pass->setDepthFunction (Ogre::CMPF_LESS_EQUAL);
            //        depth_write on
                    pass->setDepthWriteEnabled (true);
            //        illumination_stage
            //        light_clip_planes off
                    pass->setLightClipPlanesEnabled (false);
            //        light_scissor off
        pass->setLightScissoringEnabled (false);
//        lighting on
        pass->setLightingEnabled (true);
//        normalise_normals off
        pass->setNormaliseNormals (false);
//        polygon_mode solid
        pass->setPolygonMode (Ogre::PM_SOLID);

        if (alpha < 1.0)
            pass->setSceneBlending (Ogre::SBT_TRANSPARENT_ALPHA);
        else
//        scene_blend one zero
            pass->setSceneBlending (Ogre::SBF_ONE, Ogre::SBF_ZERO);

//        scene_blend_op add
        pass->setSceneBlendingOperation (Ogre::SBO_ADD);
//        shading gouraud
        pass->setShadingMode (Ogre::SO_GOURAUD);
//        transparent_sorting on
        pass->setTransparentSortingEnabled (true);

//        Ogre::Real alphaLevel = 0.5f;
//        pass->createTextureUnitState ()->setAlphaOperation (Ogre::LBX_SOURCE1, Ogre::LBS_MANUAL, Ogre::LBS_CURRENT, alphaLevel);

        cout << metaObject ()->className() << "::createMaterial: " << name << " is created!" << endl;
    }
    else {
        cout << metaObject ()->className() << "::createMaterial: " << name << " can't create!" << endl;
        iRes = -1;
    }

    return iRes;
}

int HOgreWidget::createOgreMaterials (void) {
    int iRes = 0; //Success
    Ogre::Real rAlfa = 1.0;
    Ogre::ColourValue colourAmbient, colourDiffuse;

//    Попытка изменить ИМЕЮЩИйся материал -----------------------------------------------------------
//    Ogre::MaterialPtr defaultMaterial = Ogre::MaterialManager::getSingleton().getDefaultSettings ();
//    pass = defaultMaterial->getTechnique (0)->getPass (0);

//    Материал для НЕЧёТНых СЛЕДов
    QString keyObjectReality = "Trace1";
    if (m_pSynchCoordinates->getObjectReality (keyObjectReality)) {
        colourAmbient = Ogre::ColourValue (0.8, 0.0, 0.0), colourDiffuse = Ogre::ColourValue (0.6, 0.0, 0.0); rAlfa = m_pSynchCoordinates->getObjectReality (keyObjectReality)->opacity ();
        if (createMaterial ("Red", colourAmbient, colourDiffuse, rAlfa) == 0) {
//            Материал для ЧёТНых СЛЕДов
            keyObjectReality = "Trace2";
            if (m_pSynchCoordinates->getObjectReality (keyObjectReality)) {
                colourAmbient = Ogre::ColourValue (0.0, 0.0, 0.8), colourDiffuse = Ogre::ColourValue (0.0, 0.0, 0.6); rAlfa = m_pSynchCoordinates->getObjectReality (keyObjectReality)->opacity ();
                if (createMaterial ("Blue", colourAmbient, colourDiffuse, rAlfa) == 0) {
//                    Материал для НЕ СЛЕДов
                    keyObjectReality = "CenterPSC"; //Line1, Line2, Gamma
                    if (m_pSynchCoordinates->getObjectReality (keyObjectReality)) {
                        colourAmbient = Ogre::ColourValue (0.0, 0.8, 0.0), colourDiffuse = Ogre::ColourValue (0.0, 0.6, 0.0); rAlfa = m_pSynchCoordinates->getObjectReality (keyObjectReality)->opacity ();
                        if (createMaterial ("Green", colourAmbient, colourDiffuse, rAlfa) == 0) {
//                            Материал для РЕШёТКи
//                            СОЗДаЁм в ЛЮБом случае
//                            keyObjectReality = "Lattice";
//                            if (m_pSynchCoordinates->getObjectReality (keyObjectReality)) {
                                colourAmbient = Ogre::ColourValue (0.5, 0.5, 0.5), colourDiffuse = Ogre::ColourValue (0.1, 0.1, 0.1); rAlfa = m_pSynchCoordinates->getObjectReality (keyObjectReality)->opacity ();
                                if (createMaterial ("Lattice", colourAmbient, colourDiffuse, rAlfa) == 0) {
//                                    keyObjectReality = "Wall";
//                                    if (m_pSynchCoordinates->getObjectReality (keyObjectReality)) {
//                                        colourAmbient = Ogre::ColourValue (0.0, 0.8, 0.0), colourDiffuse = Ogre::ColourValue (0.0, 0.6, 0.0); rAlfa = m_pSynchCoordinates->getObjectReality (keyObjectReality)->opacity ();
//                                        Ogre::String srcTexture;
//        //                                srcTexture = "camera-47-1852.jpg";
//                                        srcTexture = "labuda.gif";
//        //                                srcTexture = "labuda.bmp";
//                                        if (createMaterial ("Wall", colourAmbient, colourDiffuse, rAlfa, srcTexture) == 0) {
                                            ; //Success
//                                                Материал для ПОМЕЧЕННЫХ линий РЕШёТКи
//                                                СОЗДаЁм в ЛЮБом случае
                                                    colourAmbient = Ogre::ColourValue (0.357, 0.753, 0.87), colourDiffuse = Ogre::ColourValue (0.1, 0.1, 0.1); rAlfa = m_pSynchCoordinates->getObjectReality (keyObjectReality)->opacity ();
                                                    if (createMaterial ("LatticeCheckedLine", colourAmbient, colourDiffuse, rAlfa) == 0) {
                                                    }
                                                    else
                                                        iRes = -1; //Can't create material 'LatticeCheckedLine'
//                                        }
//                                        else
//                                            iRes = -1; //Can't create material 'Wall'
//                                    }
//                                    else
//                                        iRes = -1; //Wall not have
                                }
                                else
                                    iRes = -1; //Can't create material 'Lattice'
//                                Материал для РЕШёТКи
//                                СОЗДаЁм в ЛЮБом случае
//                            }
//                            else
//                                iRes = -1; //Lattice not have
                        }
                        else
                            iRes = -1; //Can't create material 'Green'
                    }
                    else
                        iRes = -1; //CenterPSC (Line1, Line2, Gamma) not have
                }
                else
                    iRes = -1; //Can't create material 'Blue'
            }
            else
                iRes = -1; //Trace2 not have
        }
        else
            iRes = -1; //Can't create material 'Red'
    }
    else
        iRes = -1; //Trace1 not have

    cout << metaObject ()->className() << "::createOgreMaterials: " << iRes << endl;

    return iRes;
}

int HOgreWidget::isInitAR (void) {
   int iRes = -1; //Error

    if (m_ptrVideoCapturer)
        if (m_ptrVideoCapturer->isOpened ())
            iRes = 0;

    return iRes;
}

int HOgreWidget::initAR (cv::VideoCapture *cvVideoCapture) {
    int iRes = 0; //Success

    if (cvVideoCapture == NULL)
        // read input video
//        m_ptrVideoCapturer->open (0);
        iRes = -1;
    else {
        m_ptrVideoCapturer = cvVideoCapture;

        if (! (m_ptrVideoCapturer->isOpened ())) {
            std::cerr << "Could not open video" << endl;

            iRes = -1;
        }
        else {
            // read intrinsic file
            try { m_CameraParams.readFromXMLFile (m_InputCameraFile); }
            catch (std::exception &ex) {
                cout << ex.what() << endl;

                iRes = -1;
            }

            if (iRes == 0) {
                // capture first frame
                if (m_ptrVideoCapturer->grab () == true) {
                    if (m_ptrVideoCapturer->retrieve (m_InputImage) == true) {
                        cv::undistort (m_InputImage, m_InputImageUnd, m_CameraParams.CameraMatrix, m_CameraParams.Distorsion);

                        m_CameraParamsUnd = m_CameraParams;
                        m_CameraParamsUnd.Distorsion = cv::Mat::zeros (4, 1, CV_32F);

                        float fltCoeff = 1.25;
                        sgnResized (m_InputImageUnd.cols * fltCoeff, m_InputImageUnd.rows * fltCoeff);

                        // This two lines has to be defined in order to update background image
                        m_szBackground.setWidth (m_InputImageUnd.cols), m_szBackground.setHeight (m_InputImageUnd.rows);
                        m_ptrBufferBackground = m_InputImageUnd.ptr <unsigned char> (0); // m_InputImageUnd will be shown as background

                        iRes = 0;
                    }
                    else {
                        iRes = -1;
                        cout << "VideoCapturer->retrieve () method return is FALSE!" << endl;
                    }
                }
                else {
                    iRes = -1;
                    cout << "VideoCapturer->grab () method return is FALSE!" << endl;
                }
            }
            else
                ;
        }
    }

    cout << "HOgreWidget::initAR: " << iRes << endl;
    return iRes;
}

//void HOgreWidget::initializeGL () {
//}

//void HOgreWidget::showGL (QShowEvent *e) {
void HOgreWidget::showEvent (QShowEvent *e) {
//    if (! m_OgreRoot)
//        initOgre ();

    cout << "DEBUG: " << metaObject ()->className () << "::showEvent" << endl;

//    m_iIdTimerUpadate = startTimer (m_iTimerInterval);

    QWidget::showEvent (e);
}

//void HOgreWidget::paintGL (QPaintEvent *e) {
void HOgreWidget::paintEvent (QPaintEvent *e) {
    cout << "DEBUG: " << metaObject ()->className () << "::paintEvent" << endl;
    e->accept ();
}

//void HOgreWidget::timerEvent (QTimerEvent *evt) {
//    int i = -1;

//    if (evt->timerId () == m_iIdTimerUpadate) {
//        if (! (m_OgreRoot == 0x0))
//            out ();
//        else
            ;
//    }
//    else //Другой таймер
//        ;

//    cout << "DEBUG: " << metaObject ()->className () << "::paintEvent" << endl;
//}

void HOgreWidget::out (void) {

//        glClear(GL_COLOR_BUFFER_BIT);
//        glLoadIdentity();

    if (! (isInitOgre () == 0))
        if (! (initOgre () == 0))
               return;

//    m_OgreRoot->_fireFrameStarted ();

//    m_OgreRenderWindow->_beginUpdate ();

    if (outBackground () == 0) {
        cv::undistort (m_InputImage, m_InputImageUnd, m_CameraParams.CameraMatrix, m_CameraParams.Distorsion);

//        if (! m_pSynchCoordinates->getFixededPSC ()) {
        if (! ((QmlCVCapture *) m_parentQMLItem)->fixedPSC ()) {
            //detect markers
            m_MarkerDetector.detect (m_InputImageUnd, m_arMarkers, m_CameraParamsUnd, m_pSynchCoordinates->szMarkerPSC ());

//            coutDebugMarkers ();

//            try { i = 0; }
//            catch (Ogre::Exception &e) {
//                std::cerr << "An exception has occured: " << e.getFullDescription ().c_str () << std::endl;
//            }
        }
        else
            ;

        outOgreScene ();
    }
    else
        ; //Нет изображения с 'КАМЕРа'

    try { m_OgreRenderWindow->update (); }
    catch (Ogre::Exception *err) {
        cout << err->getFullDescription ()  << endl;
    }

//    m_OgreRenderWindow->_endUpdate ();

//    m_OgreRoot->_fireFrameEnded ();

//    glBegin(GL_QUADS);
//        glColor3ub(0,0,255);
//        glVertex2d(x (), y ());
//        glVertex2d(width (), y ());
//        glColor3ub(255,0,0);
//        glVertex2d(width (), height ());
//        glVertex2d(x (), height ());
//    glEnd();

}

void HOgreWidget::moveEvent (QMoveEvent *e) {
//    QGLWidget::moveEvent (e);
    QWidget::moveEvent (e);

    if (e->isAccepted () && m_OgreRenderWindow) {
        m_OgreRenderWindow->windowMovedOrResized ();
        update ();
    }
}

void HOgreWidget::resizeEvent (QResizeEvent *e) {
//    QGLWidget::resizeEvent (e);
    QWidget::resizeEvent (e);

    if (e->isAccepted ()) {
        QSize newSize = e->size ();
//        QSize camSize (m_CameraParams.CamSize.width, m_CameraParams.CamSize.height);
//        if (newSize.width () == newSize.height ()) {
//            newSize.setHeight (newSize.width () * camSize.width () / camSize.height ());
//        }
//        else {
//            if (newSize.width () > newSize.height ()) {
//                newSize.setWidth (newSize.height () / camSize.height () * camSize.width ());
//            }
//            else
//                if (newSize.width () < newSize.height ()) {
//                    newSize.setHeight (Ogre::Real (newSize.width ()) / camSize.width () * camSize.height ());
//                }
//                else
//                    ;
//        }

        if (m_OgreRenderWindow) {
            m_OgreRenderWindow->resize (newSize.width (), newSize.height ());
            m_OgreRenderWindow->windowMovedOrResized ();
        }
        if (m_OgreCamera) {
            Ogre::Real aspectRatio = Ogre::Real (newSize.width ()) / Ogre::Real (newSize.height ());
            m_OgreCamera->setAspectRatio (aspectRatio);
        }
    }
}

int HOgreWidget::outBackground (void) {
    int iRes = 0; //Success

    if (isInitAR () == 0) {
        // capture a frame
        if (m_ptrVideoCapturer->grab ()) {//Hay alguna imagen para procesar?
            // undistort image
            m_ptrVideoCapturer->retrieve (m_InputImage);

//            cout << "update backGround...mTexture.isNull () = " << m_Texture.isNull () << endl;

            if (! m_Texture.isNull ())
            {
                //Pedimos a ogre que actualice la imagen desde el PixelBox
                Ogre::HardwarePixelBufferSharedPtr pixelBuffer = m_Texture->getBuffer ();
//                cout << pixelBuffer.isNull () << endl;
                pixelBuffer->blitFromMemory (m_PixelBox);

//                cout << "m_szBackground is size = (" << m_szBackground.width () << ", " << m_szBackground.height () << ")" << endl;
//                cout << "RenderWindow is size = (" << m_OgreRenderWindow->getWidth () << ", " << m_OgreRenderWindow->getHeight () << ")" << endl;
            }
            else {
                iRes = -1;

    //            return false;
            }
        }
        else
            iRes = -1;
    }
    else
        iRes = -1;

    return iRes;
}

void HOgreWidget::coutDebugMarkers (void) {;
    int i = -1;

    cout << m_arMarkers.size () << endl;

    if (m_arMarkers.size ()) {
        i = 0;
        do {
            cout << m_arMarkers [i].id;
            if ((++ i) < m_arMarkers.size ())
                cout << ", ";
            else
                cout << endl;
        }
        while (i < m_arMarkers.size ());

//                for (i = 0; i < m_arMarkers.size (); i ++) {
//                    cout << m_arMarkers [i].id;
//                    if ((i + 1) < m_arMarkers.size ())
//                        cout << ", ";
//                    else
//                        cout << endl;
//                }
    }
    else
        ;
}

void HOgreWidget::moveOgreEntity (QString keyOgreObjectNode, Ogre::Real x, Ogre::Real y, Ogre::Real z) {
    Ogre::Real offsetX = 0, offsetY = 0, offsetZ = 0;

    if (m_mapOgreObjectNode [keyOgreObjectNode]) {
//            cout << "position={" << m_arfltOgreObjectNodePosition [0] << ":"  << m_arfltOgreObjectNodePosition [1] << ":"  << m_arfltOgreObjectNodePosition [2] << "}" << endl;
            m_mapOgreObjectNode [keyOgreObjectNode]->setPosition (m_arfltOgreObjectNodePosition [0], m_arfltOgreObjectNodePosition [1], m_arfltOgreObjectNodePosition [2]);

//            Попытка управления ПРОЕКТОРом текстуры для оБЪектА 'Wall'
//            QString nameNodePositionFrustum;
//            nameNodePositionFrustum = "Lattice";
////            nameNodePositionFrustum = "CenterPSC";
//            if (keyOgreObjectNode.contains (nameNodePositionFrustum) == true) {
//                m_ProjectorPosterNode->setPosition (m_arfltOgreObjectNodePosition [0], m_arfltOgreObjectNodePosition [1], m_arfltOgreObjectNodePosition [2]);
////                cout << "{" << m_arfltOgreObjectNodePosition [0] << "," << m_arfltOgreObjectNodePosition [1] << "," << m_arfltOgreObjectNodePosition [2] << "}" << endl;
////                cout << "RePOSition node with name=" << keyOgreObjectNode.toStdString () << endl;
//            }

            // Update animation and correct position
//            m_mapBaseAnimation [keyOgreObjectNode]->addTime (0.08);
//            m_mapTopAnimation [keyOgreObjectNode]->addTime (0.08);

            m_mapOgreObjectNode [keyOgreObjectNode]->getAttachedObjectIterator ().begin ();
            if (m_mapOgreObjectNode [keyOgreObjectNode]->getAttachedObjectIterator ().hasMoreElements ()) {
                offsetX = m_mapOgreEntity [keyOgreObjectNode]->getBoundingBox ().getHalfSize ().x * m_vec3DOgreScale.x () * m_pSynchCoordinates->getObjectReality (keyOgreObjectNode)->placement ("size")->getSliderValues ().x (),
                offsetY = m_mapOgreEntity [keyOgreObjectNode]->getBoundingBox ().getHalfSize ().y * m_vec3DOgreScale.y () * m_pSynchCoordinates->getObjectReality (keyOgreObjectNode)->placement ("size")->getSliderValues ().y (),
                offsetZ = m_mapOgreEntity [keyOgreObjectNode]->getBoundingBox ().getHalfSize ().z * m_vec3DOgreScale.z () * m_pSynchCoordinates->getObjectReality (keyOgreObjectNode)->placement ("size")->getSliderValues ().z ();
            }
            else
                ;

//            cout << "offsetX=" << offsetX << "; offsetY=" << offsetY << "; offsetZ=" << offsetZ << endl;

//            m_mapOgreObjectNode [keyOgreObjectNode]->setVisible;

//            m_mapOgreEntity [keyOgreObjectNode]->

//            m_mapOgreObjectNode [keyOgreObjectNode]->translate (+offsetX + x,
//                                                                +offsetY + y,
//                                                                +offsetZ + z,
//                                                                Ogre::Node::TS_LOCAL);

            m_mapOgreObjectNode [keyOgreObjectNode]->translate (x,
                                                                offsetY + y,
                                                                -offsetZ + z,
                                                                Ogre::Node::TS_LOCAL);

//            Попытка управления ПРОЕКТОРом текстуры для оБЪектА 'Wall'
//            if (keyOgreObjectNode.contains (nameNodePositionFrustum) == true) {
//                m_ProjectorPosterNode->translate (offsetX + x,
//                                                offsetY + y,
//                                                offsetZ + z,
//                                                Ogre::Node::TS_LOCAL);
//            }

//            cout << keyOgreObjectNode.toStdString () << "-offset: X=" << offsetX << ", Y=" << offsetY << ", Z=" << offsetZ << endl;

//            m_mapOgreObjectNode [keyOgreObjectNode]->translate (x, y, z, Ogre::Node::TS_LOCAL);
    }
    else
        ; //Не создан ОДиН из 'entity'
}

void HOgreWidget::rotationOgreEntity (QString keyOgreObjectNode, Ogre::Real x, Ogre::Real y, Ogre::Real z) {
    unsigned int i = -1;
    QQuaternion  qtrnRotationEntity;
    Ogre::Vector3 orientX, orientY, orientZ;
    Ogre::Quaternion qtrnOgreRotationX90 (sqrt (0.5), sqrt (0.5), 0, 0),
                    qtrnOgreRotationY90 (sqrt (0.5), 0, sqrt (0.5), 0),
                    qtrnOgreRotationZ90 (sqrt (0.5), 0, 0, sqrt (0.5)),
                    qtrnOgreRotationEmpty (1, 0, 0, 0),
                    qtrnOgreRotationAruco, qtrnOgreRotationEntity (qtrnRotationEntity.scalar (), qtrnRotationEntity.x (), qtrnRotationEntity.y (), qtrnRotationEntity.z ()),
                    qtrnOgreOrientation;

//    cout << "orientation={" << m_arfltOgreObjectNodeOrientation [0] << ":"  << m_arfltOgreObjectNodeOrientation [1] << ":"  << m_arfltOgreObjectNodeOrientation [2] << ":"  << m_arfltOgreObjectNodeOrientation [3] << "}" << endl;
//    cout << "orientation={" << m_arfltOgreObjectNodeOrientation [0]*180/M_PI << ":"  << m_arfltOgreObjectNodeOrientation [1]*180/M_PI << ":"  << m_arfltOgreObjectNodeOrientation [2]*180/M_PI << ":"  << m_arfltOgreObjectNodeOrientation [3]*180/M_PI << "}" << endl;

//    qtrnOgreRotationAruco = Ogre::Quaternion (m_arfltOgreObjectNodeOrientation [0], m_arfltOgreObjectNodeOrientation [1], m_arfltOgreObjectNodeOrientation [2], m_arfltOgreObjectNodeOrientation [3]);
//    Вообще не уЧитЫватЬ x, y, z
    qtrnOgreOrientation = Ogre::Quaternion (m_arfltOgreObjectNodeOrientation [0], m_arfltOgreObjectNodeOrientation [1], m_arfltOgreObjectNodeOrientation [2], m_arfltOgreObjectNodeOrientation [3]);

    //****************** Вариант №1 ********************//
//    qtrnRotationEntity = HMat::quaternionRotationTotal ((float) x * M_PI / 180, (float) y * M_PI / 180, (float) z * M_PI / 180);
    //****************** ------------ ********************//

    //****************** Вариант №2 ********************//
//    QVector3D vec3DArucoEuler = HMat::getEulerFromQuaternion (QQuaternion (qtrnOgreRotationAruco.w, qtrnOgreRotationAruco.x, qtrnOgreRotationAruco.y, qtrnOgreRotationAruco.z));
//    vec3DArucoEuler.setX (vec3DArucoEuler.x () + x), vec3DArucoEuler.setY (vec3DArucoEuler.y () + y), vec3DArucoEuler.setZ (vec3DArucoEuler.z () + z);
//    qtrnRotationEntity = HMat::getQuaternionFromEuler (vec3DArucoEuler);
//    qtrnOgreOrientation = Ogre::Quaternion (qtrnRotationEntity.scalar (), qtrnRotationEntity.x (), qtrnRotationEntity.y (), qtrnRotationEntity.z ());
    //****************** ------------ ********************//

    //****************** Вариант №3 ********************//
//    orientX = m_mapOgreObjectNode [keyOgreObjectNode]->getOrientation() * Ogre::Vector3::UNIT_X;
//    orientY = m_mapOgreObjectNode [keyOgreObjectNode]->getOrientation() * Ogre::Vector3::UNIT_Y;
//    orientZ = m_mapOgreObjectNode [keyOgreObjectNode]->getOrientation() * Ogre::Vector3::UNIT_Z;

//    QQuaternion qtrnRotationEntityX = QQuaternion::fromAxisAndAngle (orientX.x, orientX.y, orientX.z, x),
//                qtrnRotationEntityY = QQuaternion::fromAxisAndAngle (orientY.x, orientY.y, orientY.z, y),
//                qtrnRotationEntityZ = QQuaternion::fromAxisAndAngle (orientZ.x, orientZ.y, orientZ.z, z);

//    qtrnOgreRotationEntity = Ogre::Quaternion ((Ogre::Real) qtrnRotationEntityX.scalar (), (Ogre::Real) qtrnRotationEntityX.x (), (Ogre::Real) qtrnRotationEntityX.y (), (Ogre::Real) qtrnRotationEntityX.z ()) *
//                            Ogre::Quaternion ((Ogre::Real) qtrnRotationEntityY.scalar (), qtrnRotationEntityY.x (), qtrnRotationEntityY.y (), qtrnRotationEntityZ.z ()) *
//                            Ogre::Quaternion (qtrnRotationEntityZ.scalar (), qtrnRotationEntityZ.x (), qtrnRotationEntityZ.y (), qtrnRotationEntityZ.z ());
//    qtrnOgreOrientation = qtrnOgreRotationAruco * qtrnOgreRotationEntity;
    //****************** ------------ ********************//

    //****************** Вариант №4 ********************//
//    orientX = qtrnOgreRotationAruco * Ogre::Vector3::UNIT_X;
//    orientY = qtrnOgreRotationAruco * Ogre::Vector3::UNIT_Y;
//    orientZ = qtrnOgreRotationAruco * Ogre::Vector3::UNIT_Z;

////    cout << "OrientX={" << orientX.x << "," << orientX.y << "," << orientX.z << "}" << " length=" << orientX.length () << endl;
////    cout << "OrientY={" << orientY.x << "," << orientY.y << "," << orientY.z << "}" << " length=" << orientY.length () << endl;
////    cout << "OrientZ={" << orientZ.x << "," << orientZ.y << "," << orientZ.z << "}" << " length=" << orientZ.length () << endl << endl;

////    cout << orientX << endl;
////    cout << orientY << endl;
////    cout << orientZ << endl << endl;

//    Ogre::Quaternion rr (Ogre::Degree(x), orientX);
//    Ogre::Quaternion pp (Ogre::Degree(y), orientY);
//    Ogre::Quaternion yy (Ogre::Degree(z), orientZ);

//    qtrnOgreOrientation = qtrnOgreRotationAruco * rr * pp * yy;
//    qtrnOgreOrientation = rr * pp * yy;
    //****************** ------------ ********************//

    //****************** Вариант №5 ********************//
//    Ogre::Matrix3 axes = m_mapOgreObjectNode [keyOgreObjectNode]->getLocalAxes ();
//    orientX = qtrnOgreRotationAruco * Ogre::Vector3::UNIT_X;
//    orientY = qtrnOgreRotationAruco * Ogre::Vector3::UNIT_Y;
//    orientZ = qtrnOgreRotationAruco * Ogre::Vector3::UNIT_Z;
    //****************** ------------ ********************//

    Ogre::Matrix3 axes;

    //****************** Вариант №6 ********************//
//    Получение локальНых осей ориентаЦии обЪектА - вариант №1
//    orientX = qtrnOgreRotationAruco * Ogre::Vector3::UNIT_X;
//    orientY = qtrnOgreRotationAruco * Ogre::Vector3::UNIT_Y;
//    orientZ = qtrnOgreRotationAruco * Ogre::Vector3::UNIT_Z;

////    Получение локальНых осей ориентаЦии обЪектА - вариант №2
//    axes = m_mapOgreObjectNode [keyOgreObjectNode]->getLocalAxes ();
//    axes.FromAxes (orientX, orientY, orientZ);
//    orientX = axes.GetColumn (0);
//    orientY = axes.GetColumn (1);
//    orientZ = axes.GetColumn (2);

////    Получение локальНых осей ориентаЦии обЪектА - вариант №3
//    qtrnOgreOrientation = m_mapOgreObjectNode [keyOgreObjectNode]->getOrientation ();
//    orientX = qtrnOgreOrientation * Ogre::Vector3::UNIT_X;
//    orientY = qtrnOgreOrientation * Ogre::Vector3::UNIT_Y;
//    orientZ = qtrnOgreOrientation * Ogre::Vector3::UNIT_Z;

//    Ogre::Quaternion rr (Ogre::Degree(x), orientX);
//    Ogre::Quaternion pp (Ogre::Degree(y), orientY);

//    orientY = rr * orientY;
//    orientZ = rr * orientZ;

//    qtrnOgreOrientation.FromAxes (orientX, orientY, orientZ);
    //****************** ------------ ********************//

//    m_mapOgreObjectNode [keyOgreObjectNode]->rotate (orientX, Ogre::Degree (x));
//    m_mapOgreObjectNode [keyOgreObjectNode]->rotate (orientY, Ogre::Degree (y));
//    m_mapOgreObjectNode [keyOgreObjectNode]->rotate (orientZ, Ogre::Degree (5));

//    Ogre::Vector3 dir = m_OgreCamera->getPosition () - m_mapOgreObjectNode [keyOgreObjectNode]->getPosition();
//    dir.x = 0;
//    Ogre::Quaternion quat = orient.getRotationTo (dir);
//    m_mapOgreObjectNode [keyOgreObjectNode]->rotate (quat);

//    qtrnOgreOrientation = qtrnOgreRotationAruco * qtrnOgreRotationX90;
//    qtrnOgreOrientation = qtrnOgreRotationAruco * qtrnOgreRotationY90;
//    qtrnOgreOrientation = qtrnOgreRotationAruco * qtrnOgreRotationZ90;
//    qtrnOgreOrientation = qtrnOgreRotationAruco * qtrnOgreRotationEmpty;

//    qtrnOgreOrientation = qtrnOgreRotationAruco * qtrnOgreRotationEntity;


//    m_mapOgreObjectNode [keyOgreObjectNode]->setOrientation (orientation [0], orientation [1], orientation [2], orientation [3]);

//    m_mapOgreObjectNode [keyOgreObjectNode]->rotate (qtrnOgreRotationEntity);

//    m_mapOgreObjectNode [keyOgreObjectNode]->roll (Ogre::Radian (x * M_PI / 180));
//    m_mapOgreObjectNode [keyOgreObjectNode]->pitch (Ogre::Radian (y * M_PI / 180));
//    m_mapOgreObjectNode [keyOgreObjectNode]->yaw (Ogre::Radian (z * M_PI / 180));

//    qtrnOgreOrientation = qtrnOgreRotationAruco * qtrnOgreRotationEntity;
//    qtrnOgreOrientation = m_mapOgreObjectNode [keyOgreObjectNode]->convertWorldToLocalOrientation (qtrnOgreOrientation);

    m_mapOgreObjectNode [keyOgreObjectNode]->setOrientation (qtrnOgreOrientation);
//    m_mapOgreObjectNode [keyOgreObjectNode]->setOrientation (qtrnOgreRotationAruco);
//    m_mapOgreObjectNode [keyOgreObjectNode]->roll (Ogre::Degree (x), Ogre::Node::TS_LOCAL);
//    m_mapOgreObjectNode [keyOgreObjectNode]->rotate (qtrnOgreOrientation);

    //****************** Вариант №7 ********************//
//    axes = m_mapOgreObjectNode [keyOgreObjectNode]->getLocalAxes ();
////    orientX = qtrnOgreOrientation * Ogre::Vector3::UNIT_X;
//    orientX = axes.GetColumn (0);
//    Ogre::Quaternion rr (Ogre::Degree(x), orientX);
//    m_mapOgreObjectNode [keyOgreObjectNode]->rotate (rr);
    //****************** ------------ ********************//

//    Попытка управления ПРОЕКТОРом текстуры для оБЪектА 'Wall'
//    QString nameNodePositionFrustum;
//    nameNodePositionFrustum = "Wall";
////    nameNodePositionFrustum = "CenterPSC";
//    if (keyOgreObjectNode.contains (nameNodePositionFrustum) == true) {
//        m_ProjectorPosterNode->setOrientation (qtrnOgreOrientation);
//    }
//    else
//        ;
}

bool HOgreWidget::visibleOgreEntity (QString keyOgreObjectNode, bool bVisible) {
//    Здесь необходимо проверить состояние 'CheckBox' для ЭТОго обЪекта ???
    if (m_mapOgreObjectNode [keyOgreObjectNode])
        m_mapOgreObjectNode [keyOgreObjectNode]->setVisible (bVisible);
    else
        cout << metaObject ()->className () << "::visibleOgreEntity" << "objectReality with name " << keyOgreObjectNode.toStdString () << " is Null" << endl;

//    if (bVisible)
//        cout << keyOgreObjectNode.toStdString () << " is visible=" << bVisible << endl;

    return bVisible;
}

void HOgreWidget::outOgreScene (void) {
    unsigned int i;
    double positon [3], orientation [4];
    QList <QString> listNameObjectReality = m_pSynchCoordinates->getListNameObjectReality ();
    QString strKeyObjectReality;
    QVector3D vec3DPosition, vec3DRotation, vec3DScale;

//    for (i; i < 64; i ++) {
    short indxMarkerPSC = getIndexMarkerPSC ();
//        if (m_arMarkers.size ()) {
        if (indxMarkerPSC > -1) {
//            ПРОВЕРКА номЕРа МАРКЕРа ??? Затем нахождения ИНДЕКСа для еГо НОМЕРа
            m_shCountEmptyArrayMarkers = 0;

            if ((! ((QmlCVCapture *) m_parentQMLItem)->fixedPSC ()) && (m_shCountSetArrayMarkers < 3))
                m_shCountSetArrayMarkers ++;
            else
                ((QmlCVCapture *) m_parentQMLItem)->setFixedPSC (true);
//                emit ((QmlCVCapture *) m_parentQMLItem)->sgnFixedPSCChanged (true);

//            if (i < m_arMarkers.size ()) {
                // set object poses
                try { m_arMarkers [indxMarkerPSC].OgreGetPoseParameters (positon, orientation); }
                catch (Ogre::Exception &e) {
                    std::cerr << "An exception has occured: " << e.getFullDescription ().c_str () << std::endl;
                    return ;
                }

                for (i = 0; i < 3; i ++)
                    m_arfltOgreObjectNodePosition [i] = (float) positon [i];
                for (i = 0; i < 4; i ++)
                    m_arfltOgreObjectNodeOrientation [i] = (float) orientation [i];

//                cout << "countObjectReality=" << listNameObjectReality.size () << endl;
                for (i = 0; i < listNameObjectReality.size (); i ++) {
                    strKeyObjectReality = listNameObjectReality.at (i);

                    //Entity must (can) bie NOT visible
                    if (visibleOgreEntity (strKeyObjectReality, m_pSynchCoordinates->getObjectReality (strKeyObjectReality)->visible () && true)) {
                        m_mapOgreObjectNode [strKeyObjectReality]->setPosition (m_arfltOgreObjectNodePosition [0], m_arfltOgreObjectNodePosition [1], m_arfltOgreObjectNodePosition [2]);
//                        m_mapOgreObjectNode [strKeyObjectReality]->setPosition (0, 0, 0);

                        vec3DRotation = m_pSynchCoordinates->getObjectReality (strKeyObjectReality)->placement ("rotation")->getValues ();
                        rotationOgreEntity (strKeyObjectReality, vec3DRotation.x (), vec3DRotation.y (), vec3DRotation.z ());

                        vec3DPosition = m_pSynchCoordinates->getObjectReality (strKeyObjectReality)->placement ("position")->getValues ();
                        moveOgreEntity (strKeyObjectReality, vec3DPosition.x (), vec3DPosition.y (), vec3DPosition.z ());

//                        Отладка
//                        cout << strKeyObjectReality.toStdString () << "={" << vec3DPosition.x () << "," << vec3DPosition.y () << "," << vec3DPosition.z () << "}" << endl;

                        vec3DScale = m_pSynchCoordinates->getObjectReality (strKeyObjectReality)->placement ("size")->getValues ();
//                        cout << "Size={" << vec3DScale.x () << "," << vec3DScale.y () << "," << vec3DScale.z () << "}" << endl;
//                        scaleOgreEntity (strKeyObjectReality, vec3DScale.x (), vec3DScale.y (), vec3DScale.z ());
//                        Ogre::Vector3 entityRealSize = m_mapOgreEntity [strKeyObjectReality]->getBoundingBox ().getSize ();
//                        m_mapOgreObjectNode [strKeyObjectReality]->scale (m_mapOgreEntityTrueSize [strKeyObjectReality].x * vec3DScale.x () / entityRealSize.x,
//                                                                          m_mapOgreEntityTrueSize [strKeyObjectReality].y * vec3DScale.y () / entityRealSize.y,
//                                                                          m_mapOgreEntityTrueSize [strKeyObjectReality].z * vec3DScale.z () / entityRealSize.z);
                        m_mapOgreObjectNode [strKeyObjectReality]->setScale (m_vec3DOgreScale.x () * vec3DScale.x (),
                                                                             m_vec3DOgreScale.y () * vec3DScale.y (),
                                                                             m_vec3DOgreScale.z () * vec3DScale.z ());
//                        if (strKeyObjectReality.contains ("Lattice") == true) {
//                            m_ProjectorPosterNode->setScale (m_vec3DOgreScale.x () * vec3DScale.x (),
//                                                           m_vec3DOgreScale.y () * vec3DScale.y (),
//                                                           m_vec3DOgreScale.z () * vec3DScale.z ());
//                        }
//                        else
//                            ;
                    }
                    else
                        ; //Entity NOT visible
                }
//            }
//            else
//                ; //Счётчик 'i' МЕНьШе числа РАСПОЗНАНных МАРКЕРов
        }
        else {
//            cout << "Пустой массив с ОБНАРУЖЕННыми МАРКЕРамИ!" << endl;

            if (m_shCountSetArrayMarkers < 2)
                m_shCountSetArrayMarkers = 0;
            else
                m_shCountSetArrayMarkers --;

            //МАРКЕРы ВОВСе НЕ ОБНАРУЖены
            if (m_shCountEmptyArrayMarkers > 3) {
                for (i = 0; i < listNameObjectReality.size (); i ++) {
                    strKeyObjectReality = listNameObjectReality.at (i);
                    visibleOgreEntity (strKeyObjectReality, false);
                }
            }
            else {
                m_shCountEmptyArrayMarkers ++;
            }
        }
//    } //Цикл 'for'
}

short HOgreWidget::getIndexMarkerPSC (void) {
//    ИСКАТЬ 'ID' (m_pSynchCoordinates->idMarkerPSC) МАРКЕРа ???
    if (m_arMarkers.size () > 0)
        return 0;
    else
        return -1;
}
