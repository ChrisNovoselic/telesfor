#include "hqdeclarativeviewform.h"
#include "HQmlCVCapture.h"
#include <QCheckBox>

HQDeclarativeViewForm::HQDeclarativeViewForm (QDeclarativeView *parent) : QDeclarativeView (parent) {
    m_strOgrePluginsCfg = "plugins.cfg";
    m_strRenderSystemCfg = "ogre.cfg";
    m_strOgreResourcesCfg = "resources.cfg";

//    m_mapManagementSlider.insert ("cameraX", new HManagementSlider ());
//    m_mapManagementSlider.insert ("cameraY", new HManagementSlider ());
//    m_mapManagementSlider.insert ("cameraZ", new HManagementSlider ());

//    m_mapManagementSlider.insert ("lineX", new HManagementSlider ());
//    m_mapManagementSlider.insert ("lineY", new HManagementSlider ());
//    m_mapManagementSlider.insert ("lineZ", new HManagementSlider ());

    m_pSynchCoordinates = NULL;
}

HQDeclarativeViewForm::~HQDeclarativeViewForm () {
    int i = -1;
    QList <QString> listKeys;
//    listKeys = m_mapManagementSlider.keys ();
//    for (int i = 0; i < listKeys.count (); i ++)
//        delete m_mapManagementSlider [listKeys.at (i)];

    cv::VideoCapture *ptrVideoCapture = NULL;
    while (m_listptrVideoCapture.count ()) {
        ptrVideoCapture = m_listptrVideoCapture.front ();
        if (ptrVideoCapture)
            if (ptrVideoCapture->isOpened ())
                ptrVideoCapture->release ();

        m_listptrVideoCapture.removeOne (ptrVideoCapture);
    }

    m_ManagementTreadmill.executeCommand ("*601*");
    m_ManagementTreadmill.free_usb_device_descs ();
}

void HQDeclarativeViewForm::onSgnDebugRepositionObject (QString , QString ) {
//    QVector3D vec3D = m_pSynchCoordinates->m_mapObjectReality ["Trace2"]->m_mapPlacement ["position"]->getOutValues ();
//    vec3D.setZ (vec3D.z () + 0.1);
//    m_pSynchCoordinates->m_mapObjectReality ["Trace2"]->m_mapPlacement ["position"]->initValues (vec3D.x (), vec3D.y (), vec3D.z ());
////    m_mapQmlCVCapture ["cameraBase"]->getWidgetCVCapture ()->m_z2 += 0.1;
}

void HQDeclarativeViewForm::init ()
{
    int i, j;

    QObject::connect (rootObject (), SIGNAL (sgnRecoverySliderValueObject (QString , QString)), this, SLOT (onSgnRecoverySliderValueObject (QString, QString )));
    QObject::connect (rootObject (), SIGNAL (sgnReplacmentObject (QString , QString )), this, SLOT (onSgnReplacmentObject (QString , QString )));
    QObject::connect (rootObject (), SIGNAL (sgnManagementTreadmill (QString )), this, SLOT (onSgnManagementTreadmill (QString )));
    QObject::connect (rootObject (), SIGNAL (sgnQueryPulse (QString )), this, SLOT (onSgnQueryPulse (QString )));

    QObject::connect (this, SIGNAL (sgnPulseTreadmill (QVariant)), rootObject (), SLOT (callbackQueryPulse (QVariant)));

    QObject::connect (rootObject (), SIGNAL (sgnTrainingStart (double , int, double )), this, SLOT (onSgnTrainingStart (double , int, double )));
    QObject::connect (rootObject (), SIGNAL (sgnTrainingChange (double , int, double )), this, SLOT (onSgnTrainingChange (double , int, double )));
    QObject::connect (rootObject (), SIGNAL (sgnTrainingStop ()), this, SLOT (onSgnTrainingStop ()));

    QObject::connect (rootObject (), SIGNAL (sgnDebugRepositionObject (QString , QString )), this, SLOT (onSgnDebugRepositionObject (QString , QString )));

    initOgre ();
    m_ManagementTreadmill.husb_init ();

//    QWidget *rootWidget = viewport ();
//    cout << "rootWidget.ptr=" << rootWidget << endl;
//    cout << "rootWidget.objectName=" << rootWidget->objectName ().toStdString () << endl;
//    cout << "rootWidget.className=" << rootWidget->metaObject ()->className () << endl;

    //ОбЪект для проведения расчётов по синхронному выводу обЪектов "расширенной реАльности"
    m_pSynchCoordinates =  rootObject ()->findChild <HSynchCoordinates *> ();
    if (m_pSynchCoordinates == NULL) {
        cout << "ОШИБКА! Не найден контейнер для обЪектов расширенной реальности!" << endl;
    }
    else {
        //Поиск обЪектов по ВСЕМу дереву 'DOM'
        QList <QObject *> listItemQmlObjects = rootObject ()->findChildren <QObject *> ();
        cout << "Всего элементов в 'DOMe': " << listItemQmlObjects.count () << endl;

        cout << "Поиск обЪектов 'CheckBox'..." << endl; //mapQmlCheckbox
        //Список ВСЕх "QCheckBox"- обЪектОВ
        QMap <QString, QCheckBox *> mapQmlCheckbox;
        //Список ключей (objectName), найденных "QCheckBox"- обЪектОВ
        QList <QString> listKeysQmlCheckbox;

        cout << "Поиск обЪектов 'QSlider'..." << endl; //m_mapQmlSlider
        QString keySlider;

        cout << "Поиск обЪектов 'QmlCVCapture'..." << endl; //m_mapQmlCVCapture
        QmlCVCapture *itemQmlCVCapture = NULL;
        QList <QmlCVCapture *> listItemQmlCVCapture;

        cout << "Поиск обЪектов 'HObjectReality'..." << endl; //m_pSynchCoordinates->m_mapObjectReality
        QList <HObjectReality *> listItemQmlObjectReality;

        for (i = 0; i < listItemQmlObjects.count (); i ++) {
            //ВЫВОД КаждОГО элементА !!!
//            if (QString (listItemQmlObjects.at (i)->objectName()).size ()) {
//                coutQmlObjectInfo (i, listItemQmlObjects.at (i));
//            }

            //Поиск обЪектов 'CheckBox'
            if (QString (listItemQmlObjects.at (i)->metaObject ()->className ()).contains ("CheckBox")) {
//                coutQmlObjectInfo (i, listItemQmlObjects.at (i));
                if (listItemQmlObjects.at (i)->objectName ().size ())
                    mapQmlCheckbox.insert (listItemQmlObjects.at (i)->objectName (), (QCheckBox *) listItemQmlObjects.at (i));
            }

            //Поиск обЪектов 'QSlider'
            if (QString (listItemQmlObjects.at (i)->metaObject ()->className ()).contains ("Slider")) {
//                coutQmlObjectInfo (i, listItemQmlObjects.at (i));
                if (listItemQmlObjects.at (i)->objectName ().size ()) {
                    keySlider = listItemQmlObjects.at (i)->objectName ().right (listItemQmlObjects.at (i)->objectName ().length () - QString ("slider").length ());
//                    listItemSlider.append ((QSlider *) listItemQmlObjects.at (i));
                    m_mapQmlSlider.insert (keySlider, (QSlider *) listItemQmlObjects.at (i));

//                QObject::disconnect (rootObject (), SIGNAL (sgnRecalculateCameraVector (QString , QString )), this, SLOT (onSgnRecalculateCameraVector (QString , QString )));

                    if (keySlider.contains ("Object")) {
                        m_mapQmlSlider [keySlider]->setProperty("value", 0);
                        m_mapQmlSlider [keySlider]->setProperty("minimumValue", -1);
                        m_mapQmlSlider [keySlider]->setProperty("maximumValue", 1);
                        m_mapQmlSlider [keySlider]->setProperty("stepSize", 0.5);
                    }
                    else
                        ;

//                QObject::connect (rootObject (), SIGNAL (sgnRecalculateCameraVector (QString , QString )), this, SLOT (onSgnRecalculateCameraVector (QString , QString )));

//                if (keySlider.contains ("CameraX"))
//                    qmlContext (listItemQmlObjects.at (i))->setContextProperty ("mngSliderCameraX", m_mapManagementSlider ["cameraX"]);
//                else
//                    if (keySlider.contains ("CameraY"))
//                        qmlContext (listItemQmlObjects.at (i))->setContextProperty ("mngSliderCameraY", m_mapManagementSlider [keySlider]);
//                    else
//                        if (keySlider.contains ("CameraZ"))
//                            qmlContext (listItemQmlObjects.at (i))->setContextProperty ("mngSliderCameraZ", m_mapManagementSlider [keySlider]);
//                        else
//                            if (keySlider.contains ("ObjectX"))
//                                qmlContext (listItemQmlObjects.at (i))->setContextProperty ("mngLineLineX", m_mapManagementSlider [keySlider]);
//                            else
//                                if (keySlider.contains ("ObjectY"))
//                                    qmlContext (listItemQmlObjects.at (i))->setContextProperty ("mngLineLineY", m_mapManagementSlider [keySlider]);
//                                else
//                                    if (keySlider.contains ("ObjectZ"))
//                                        qmlContext (listItemQmlObjects.at (i))->setContextProperty ("mngLineLineZ", m_mapManagementSlider [keySlider]);
//                                    else
//                                        ;
                }
            }
        }
        //Итоговое количество найденных 'CheckBox' (для управления вызовом метода 'start ()' для каждого обЪекта 'QmlCVCapture')
        cout << "ОбЪектов 'CheckBox'..." << mapQmlCheckbox.size () << endl;

        //Итоговое количество найденных 'QSlider' (для управления значениями векторов 'Камер', 'Линий')
        //cout << "ОбЪектов 'QSlider'..." << listItemSlider.size () << endl;
        listKeysQmlCheckbox = m_mapQmlSlider.keys ();
        cout << "ОбЪектов 'QSlider'..." << m_mapQmlSlider.size () << endl;

        listItemQmlCVCapture = rootObject ()->findChildren <QmlCVCapture *> ();
        cout << "ОбЪектов 'QmlCVCapture'..." << listItemQmlCVCapture.size () << endl;

        listItemQmlObjectReality = rootObject ()->findChildren <HObjectReality *> ();
        cout << "ОбЪектов 'HObjectReality'..." << listItemQmlObjectReality.size () << endl;
        for (i = 0; i < listItemQmlObjectReality.size (); i ++)
            m_pSynchCoordinates->insertObjectReality (listItemQmlObjectReality.at (i)->objectName (), listItemQmlObjectReality.at (i));

        //Строки 'objectName' для определения соответствия управляющего 'CheckBox' и управляемой "камеры"
        QString strItemQmlCVCapture, strItemCheckbox;

        for (i = 0; i < listItemQmlCVCapture.count (); i ++) {
            itemQmlCVCapture = listItemQmlCVCapture.at (i);
            strItemQmlCVCapture = QString (itemQmlCVCapture->objectName ());
            cout << "ItemQmlCVCapture..." << strItemQmlCVCapture.toStdString () << " с номером порта для камеры=" << itemQmlCVCapture->getNumPort () << endl;
//            printf ("ItemQmlCVCapture...'%s' с номером порта для камеры=%i\n", strItemQmlCVCapture.constData(), itemQmlCVCapture->getNumPort ());

            m_mapQmlCVCapture.insert (strItemQmlCVCapture, itemQmlCVCapture);

            //Коннект событий 'Slider' и обЪектов 'QmlCVCapture'

            //Заполнение СПИСка контекста КАМЕр с изображением "КАРТИНки"
            //кол-во ЭЛЕМЕНТов д.б. = макс. из заданных номеров портов USB в 'Qml', но '+ 1', т.к. № 1-го порта USB = 0
            //После КАЖДого прохода получаем список с размером=максмальный номер порта USB для камеры,
            //заполненный контекстАМи РЕАЛьных камер для номеров ПОРТов USB, указанных в 'Qml', иначе элемент списка=Null
            if (m_listptrVideoCapture.count () < itemQmlCVCapture->getNumPort () + 1) {
                for (j = 0; j < itemQmlCVCapture->getNumPort () + 1; j ++) {
                    if (j == itemQmlCVCapture->getNumPort ()) {
                        m_listptrVideoCapture.insert (j, new cv::VideoCapture ());                     

                        int c = j;
                        for (c; c < 666; c ++) {
//                            cout << "Для камерЫ " << itemQmlCVCapture->objectName ().toStdString () << " с номерОМ порта USB=" << itemQmlCVCapture->getNumPort () << "; попытка читать ПОТок по индексу=" << c;
                            try { m_listptrVideoCapture.at (j)->open (c); }
                            catch (cv::Exception &err) {
                                std::cout << err.err.c_str () << std::endl;
                            }
                            if (m_listptrVideoCapture.at (j)->isOpened ()) {
                                itemQmlCVCapture->setIndexPort (c);
//                                m_listptrVideoCapture.at (j)->release ();
                                cout << " Success!" << endl;
                                break;
                            }
                            else {
//                                cout << " ОШиБкА!" << endl;
                            }
                        }
                    }
                    else
                        m_listptrVideoCapture.append (0x0);
                }
            }

            //if (itemQmlCVCapture->getVisible ())
            {
                if (! (m_listptrVideoCapture.at (itemQmlCVCapture->getNumPort ()) == 0x0)) {
                    //Есть камера с изображением!
                    //Регистрируем обЪект для вычисления координат в 'Qml'
                    //rootContext ()->setContextProperty (itemQmlCVCapture->objectName () + "_Coordinates", &itemQmlCVCapture->getObjectCoordinates ());

//                    itemQmlCVCapture->createWidgetCVCapture (m_ptrViewportGLWidget);
                    itemQmlCVCapture->createWidgetCVCapture (viewport (), m_OgreRoot, m_pSynchCoordinates, itemQmlCVCapture->objectName ().right (itemQmlCVCapture->objectName ().length () - QString ("camera").length ()));

                    //Инициализация обЪекта 'QmlCVCapture'
                    itemQmlCVCapture->getWidgetCVCapture ()->initAR (m_listptrVideoCapture.at (itemQmlCVCapture->getNumPort ()));
//                    itemQmlCVCapture->getWidgetCVCapture ()->cut (itemQmlCVCapture->getRectOutput());
                    itemQmlCVCapture->size (itemQmlCVCapture->width () - 20, itemQmlCVCapture->height () - 20);
                    itemQmlCVCapture->move (itemQmlCVCapture->x () + 20, itemQmlCVCapture->y () + 10);

//                    //Управление вызовом методом 'start ()'
////                    for (j = 0; j < mapQmlCheckbox.size (); j++) {
//                    for (j = 0; j < listKeysQmlCheckbox.size (); j++) {
////                    cout << itemQmlCVCapture->objectName ().toStdString () << " ? " << mapQmlCheckbox [listKeysQmlCheckbox.at (j)]->objectName ().toStdString () << endl;
//                        cout << itemQmlCVCapture->objectName ().toStdString () << " ? " << listKeysQmlCheckbox.at (j).toStdString () << endl;
////                    strItemCheckbox = QString (mapQmlCheckbox [listKeysQmlCheckbox.at (j)]->objectName ());
//                        strItemCheckbox = listKeysQmlCheckbox.at (j);
//                        if (strItemQmlCVCapture.contains (strItemCheckbox.right (4))) {
////                            cout << "Checkbox: " << listItemCheckbox.at (j)->objectName ().toStdString () << " checked is=" << listItemCheckbox.at (j)->checkState () << endl;
////                            cout << "Checkbox: " << mapQmlCheckbox [listKeysQmlCheckbox.at (j)]->objectName ().toStdString () << " checked is=" << ((QAbstractButton *) mapQmlCheckbox [listKeysQmlCheckbox.at (j)])->isChecked () << endl;
//                            cout << "Checkbox: " << listKeysQmlCheckbox.at (j).toStdString () << " checked is=" << ((QAbstractButton *) mapQmlCheckbox [listKeysQmlCheckbox.at (j)])->isChecked () << endl;
////                            if (((QCheckBox *) listItemCheckbox.at (j))->checkState () == Qt::Checked)
//                            if (((QAbstractButton *) mapQmlCheckbox [listKeysQmlCheckbox.at (j)])->isChecked ()) {
//                                itemQmlCVCapture->getWidgetCVCapture ()->initOgre ();
//                                itemQmlCVCapture->start ();
//                            }
//                            else
//                                ;
//                        }
//                        else
//                            cout << "Different 'objectName'" << endl;
//                    }
                }
                else
                    cout << "QmlCVCapture без изображения!" << endl;
            }
            //else
                ;
        }
    }
}

int HQDeclarativeViewForm::initOgre (void) {
    int iRes = -1; //Error

    m_OgreRoot = new Ogre::Root ();

    if (m_OgreRoot)
            if (loadResources () == 0)
////                if (isInitAR () == 0)
                    if (initRenderSystem () == 0)
//                    if (createOgreRenderWindow () == 0)
//                        if (createOgreSceneManager () == 0)
//                            if (setupResources () == 0)
//                                if (createCameraBackground () == 0)
//                                    if (createOgreCamera () == 0)
//                                        if (createOgreViewport () == 0)
//                                            if (createOgreScene () == 0)
                                                iRes = 0;

    if (! (iRes == 0))
        releaseOgre ();

    cout << metaObject ()->className () << "::initOgre: " << iRes << endl;

    return iRes;
}

int HQDeclarativeViewForm::initRenderSystem (void) {
    int iRes = 0; //Success

    if(! (m_OgreRoot->restoreConfig () || m_OgreRoot->showConfigDialog ()))
        return -1;

    // setup a renderer OF KTHUCHA's
    Ogre::RenderSystemList::const_iterator renderers = m_OgreRoot->getAvailableRenderers ().begin ();
    while (renderers != m_OgreRoot->getAvailableRenderers().end ()) {
        Ogre::String rName = (*renderers)->getName ();
        if (rName == "OpenGL Rendering Subsystem")
            break;

        renderers++;
    }

    if (*renderers != NULL) {
        m_OgreRoot->setRenderSystem (*renderers);

//        QString dimensions = QString ("%1x%2").arg (this->width ()).arg (this->height ());

//        m_OgreRoot->getRenderSystem ()->setConfigOption ("Video Mode", dimensions.toStdString ());
//        m_OgreRoot->getRenderSystem ()->setConfigOption ("Video Mode", "800 x 600 @ 32-bit colour");

        // initialize without creating window
//        m_OgreRoot->getRenderSystem ()->setConfigOption ("Full Screen", "No");

        m_OgreRoot->saveConfig ();
    }
    else
        iRes = -1;

    cout << metaObject ()->className () << "::initRenderSystem: " << iRes << endl;

    return iRes;
}

int HQDeclarativeViewForm::loadResources (void) {
    int iRes = 0; //Success

    // set up resources
    // Load resource paths from config file
    Ogre::ConfigFile cf;
    try { cf.load (m_strOgreResourcesCfg); }
    catch (Ogre::Exception &e) {
        iRes = -1;
        std::cerr << "An exception has occured: " << e.getFullDescription ().c_str () << std::endl;
    }

    Ogre::String secName, typeName, archName;

//    if ((iRes == 0) && (! (Ogre::ResourceGroupManager::getSingletonPtr () == 0x0))) {
//        // Go through all sections & settings in the file
//        Ogre::ConfigFile::SectionIterator seci = cf.getSectionIterator ();

//        while (seci.hasMoreElements ())
//        {
//            secName = seci.peekNextKey ();
//            Ogre::ConfigFile::SettingsMultiMap *settings = seci.getNext ();
//            Ogre::ConfigFile::SettingsMultiMap::iterator i;
//            for (i = settings->begin (); i != settings->end (); ++i)
//            {
//                typeName = i->first;
//                archName = i->second;
//                Ogre::ResourceGroupManager::getSingleton ().addResourceLocation (archName, typeName, secName);
//                cout << "archName=" << archName << ", typeName=" << typeName << ", secName=" << secName << endl;
//            }
//        }
//    }
//    else
//        iRes = -1;

    archName = "/home/treadmill/Repos/res/Trace";
    typeName = "FileSystem";
//    secName = "";
    Ogre::ResourceGroupManager::getSingleton ().addResourceLocation (archName, typeName);

    archName = "/home/treadmill/Repos/res/Line";
    typeName = "FileSystem";
//    secName = "";
    Ogre::ResourceGroupManager::getSingleton ().addResourceLocation (archName, typeName);

    archName = "/home/treadmill/Repos/res/Test010";
    typeName = "FileSystem";
//    secName = "";
    Ogre::ResourceGroupManager::getSingleton ().addResourceLocation (archName, typeName);

    cout << metaObject ()->className () << "::loadResources: " << iRes << endl;

//    Ogre::TextureManager::getSingletonPtr ()->createManual ("texture32",
//                                                            Ogre::ResourceGroupManager::DEFAULT_RESOURCE_GROUP_NAME,
//                                                            Ogre::TEX_TYPE_2D,
//                                                            localWidth,
//                                                            localHeight,
//                                                            0,
//                                                            Ogre::PF_FLOAT32_RGB,
//                                                            Ogre::TU_RENDERTARGET);

//    if (Ogre::TextureManager::getSingletonPtr ()) {
//        // Set default mipmap level (note: some APIs ignore this)
//        Ogre::TextureManager::getSingletonPtr ()->setDefaultNumMipmaps (5);
//        // initialise all resource groups
//        Ogre::ResourceGroupManager::getSingletonPtr ()->initialiseAllResourceGroups ();
//    }
//    else
//        iRes = -1;

    return iRes;
}

void HQDeclarativeViewForm::releaseOgre (void) {
    if (m_OgreRoot) {
        m_OgreRoot->destroyAllRenderQueueInvocationSequences ();

        delete m_OgreRoot;
    }
    else
        ;

    m_OgreRoot = NULL;
}

void HQDeclarativeViewForm::onSgnRecoverySliderValueObject (QString nameObject, QString nameItemManagement) {
    QString keySlider, keyValue;
    HManagementSlider *sliderParams;

    cout << metaObject ()->className () << "::onSgnRecoverySliderValueObject" << endl;

    if (nameObject.isEmpty () || nameItemManagement.isEmpty ()) {
        cout << "Ошибка! Обработка не корректного сигнала от Qml!" << endl;
    }
    else {
        QObject::disconnect (rootObject (), SIGNAL (sgnReplacmentObject (QString , QString )), this, SLOT (onSgnReplacmentObject (QString , QString )));

        if (nameObject.compare("Gamma", Qt::CaseInsensitive) == 0)
            nameObject += "1";
        else
            ;

        keySlider = "ObjectX";
        keyValue = "X";
        sliderParams = m_pSynchCoordinates->getObjectReality (nameObject)->placement (nameItemManagement)->sliderParamsAxis (keyValue);
        m_mapQmlSlider [keySlider]->setProperty ("minimumValue", sliderParams->minValue ());
        m_mapQmlSlider [keySlider]->setProperty ("maximumValue", sliderParams->maxValue ());
        m_mapQmlSlider [keySlider]->setProperty ("stepSize", sliderParams->stepValue ());
        m_mapQmlSlider [keySlider]->setProperty ("value", sliderParams->sliderValue ());

        keySlider = "ObjectY";
        keyValue = "Y";
        sliderParams = m_pSynchCoordinates->getObjectReality (nameObject)->placement (nameItemManagement)->sliderParamsAxis (keyValue);
        m_mapQmlSlider [keySlider]->setProperty ("minimumValue", sliderParams->minValue ());
        m_mapQmlSlider [keySlider]->setProperty ("maximumValue", sliderParams->maxValue ());
        m_mapQmlSlider [keySlider]->setProperty ("stepSize", sliderParams->stepValue ());
        m_mapQmlSlider [keySlider]->setProperty ("value", sliderParams->sliderValue ());

        if ((nameObject.contains ("Gamma", Qt::CaseInsensitive)) && (nameItemManagement.compare ("size", Qt::CaseInsensitive) == 0))
            nameObject.replace("1", "2");
        else
            ;

        keySlider = "ObjectZ";
        keyValue = "Z";
        sliderParams = m_pSynchCoordinates->getObjectReality (nameObject)->placement (nameItemManagement)->sliderParamsAxis (keyValue);
        m_mapQmlSlider [keySlider]->setProperty ("minimumValue", sliderParams->minValue ());
        m_mapQmlSlider [keySlider]->setProperty ("maximumValue", sliderParams->maxValue ());
        m_mapQmlSlider [keySlider]->setProperty ("stepSize", sliderParams->stepValue ());
        m_mapQmlSlider [keySlider]->setProperty ("value", sliderParams->sliderValue ());

        if ((nameObject.contains ("Gamma", Qt::CaseInsensitive)) && (nameItemManagement.compare ("size", Qt::CaseInsensitive) == 0))
            nameObject = "Gamma";
        else
            ;

        QObject::connect (rootObject (), SIGNAL (sgnReplacmentObject (QString , QString )), this, SLOT (onSgnReplacmentObject (QString , QString )));
        onSgnReplacmentObject (nameObject, nameItemManagement);
    }
}

void HQDeclarativeViewForm::onSgnManagementTreadmill (QString cmd) {
    cout << "command management of tradmill = " << cmd.toStdString () << endl;
    m_ManagementTreadmill.executeCommand (cmd);
}

void HQDeclarativeViewForm::onSgnQueryPulse (QString cmd) {
    cout << "command query pulse of tradmill = " << cmd.toStdString () << endl;
    m_ManagementTreadmill.executeCommand (cmd);

    emit sgnPulseTreadmill (m_ManagementTreadmill.readPulse ());
}

void HQDeclarativeViewForm::onSgnReplacmentObject (QString nameObject, QString nameItemManagement) {
//    Следы (1, 2) на ИСХОДную позицию
    int countSubObject = 1;
    QVector3D vec3DPlacementCurrent, vec3DPlacementPrev;
    float fltDiffZ = 0;
    cout << metaObject ()->className () << "::onSgnReplacmentObject" << endl;

    vec3DPlacementCurrent = QVector3D (m_mapQmlSlider ["ObjectX"]->property ("value").toFloat (),
                                    m_mapQmlSlider ["ObjectY"]->property ("value").toFloat (),
                                    m_mapQmlSlider ["ObjectZ"]->property ("value").toFloat ());

    if (nameObject.compare ("Gamma", Qt::CaseInsensitive) == 0) {
        countSubObject = 2;

//        switch (nameItemManagement) {
//            case "position":
//                break;
//            case "rotation":
//                break;
//            case "size":
//                break;
//            default:
//                ;
//        }

        vec3DPlacementPrev = m_pSynchCoordinates->getValues (nameObject + "1", nameItemManagement);

        if (nameItemManagement.compare ("position") == 0) {
            //Позиция БЕЗ изменнеий для ВСЕХ частЕЙ составнОГО обЪекта
            m_pSynchCoordinates->initValues (nameObject + "1", nameItemManagement, vec3DPlacementCurrent);

    //        m_pSynchCoordinates->calculate (nameObject, nameItemManagement);

            m_pSynchCoordinates->changeValues (nameObject + "2", nameItemManagement, vec3DPlacementCurrent - vec3DPlacementPrev);
        }
        else {
            if (nameItemManagement.compare ("rotation") == 0) {
                //ВраЩениЕ БЕЗ изменнеий для ВСЕХ частЕЙ составнОГО обЪекта
                m_pSynchCoordinates->initValues (nameObject + "1", nameItemManagement, vec3DPlacementCurrent);

        //        m_pSynchCoordinates->calculate (nameObject, nameItemManagement);

                m_pSynchCoordinates->changeValues (nameObject + "2", nameItemManagement, vec3DPlacementCurrent - vec3DPlacementPrev);
            }
            else {
                if (nameItemManagement.compare ("size") == 0) {
                    if (! ((vec3DPlacementCurrent - vec3DPlacementPrev).x () == 0x0)) {
                        //ИзмениЛАСь "X" - ширина
                        //ШИРИНа БЕЗ изменнеий для ВСЕХ частЕЙ составнОГО обЪекта
                        m_pSynchCoordinates->initValue (nameObject + "1", nameItemManagement, "X", vec3DPlacementCurrent.x ());

                //        m_pSynchCoordinates->calculate (nameObject, nameItemManagement);

                        m_pSynchCoordinates->changeValue (nameObject + "2", nameItemManagement, "X", (vec3DPlacementCurrent - vec3DPlacementPrev).x ());
                    }
                    else {
                        if (! ((vec3DPlacementCurrent - vec3DPlacementPrev).y () == 0x0)) {
                            //ИзмениЛАСь "Y" - высота
                            //ВЫСОТа ТОЛьКО для ОСНовного (1-го) обЪекта
                            m_pSynchCoordinates->changeValue (nameObject + "1", nameItemManagement, "Y", (vec3DPlacementCurrent - vec3DPlacementPrev).y ());
                            m_pSynchCoordinates->changeValue (nameObject + "2", "position", "Y", (vec3DPlacementCurrent - vec3DPlacementPrev).y () * 2 * 0.027);
                        }
                        else {
                            if (! ((vec3DPlacementCurrent - vec3DPlacementPrev).z () == 0x0)) {
                                //ИзмениЛАСь "Z" - глубина
                                //ГЛУБИНа ТОЛьКО для ДОПОЛНительного (2-го) обЪекта
                                fltDiffZ = (vec3DPlacementCurrent - vec3DPlacementPrev).z ();
//                                vec3DPlacementPrev = m_pSynchCoordinates->getValue (nameObject + "2", nameItemManagement);
                                m_pSynchCoordinates->initValue (nameObject + "2", nameItemManagement, "Z", vec3DPlacementCurrent.z ());
                                cout << fltDiffZ << endl;
                            }
                            else {
                            }
                        }
                    }
                }
                else {
                    cout << "Другого типа управления ОБъЕКТом НЕ предусмотрено" << endl;
                }
            }
        }
    }
    else {
        m_pSynchCoordinates->initValues (nameObject, nameItemManagement, vec3DPlacementCurrent);

//        m_pSynchCoordinates->calculate (nameObject, nameItemManagement);
    }
}

void HQDeclarativeViewForm::coutQmlObjectInfo (int i, QObject *obj) {
    cout << "id=" << i;
    cout << " className=" << obj->metaObject ()->className ();
    cout << " objectName=";
    if (obj->objectName ().size ())
         cout << obj->objectName ().toStdString ();
    else
        cout << "Null";
    cout << " parent=" << obj->parent ()->metaObject ()->className () << endl;
}

void HQDeclarativeViewForm::onSgnTrainingStart (double speed, int tilt, double stepsLength) {
    QDateTime dtCurrent = QDateTime ();
//    мОЖНО ДОБАВИТЬ НОВ. ОБъЕКТ тренировкА
    m_TrainingDesc.start (speed, tilt, stepsLength);
}

void HQDeclarativeViewForm::onSgnTrainingChange (double speed, int tilt, double stepsLength) {
    m_TrainingDesc.addItem (speed, tilt, stepsLength);
}

void HQDeclarativeViewForm::onSgnTrainingStop () {
    m_TrainingDesc.stop ();
}
