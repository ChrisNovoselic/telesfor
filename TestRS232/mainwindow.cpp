#include "mainwindow.h"
#include "ui_mainwindow.h"

//#include <serial.h>

MainWindow::MainWindow(QWidget *parent) :  QMainWindow(parent), ui (new Ui::MainWindow) {
#if defined __USB_H__
#else
    m_ctx = 0x0;
#endif

    husb_init ();

    ui->setupUi (this);
    ui->comboBoxPrefix1->addItem ("tty");
    ui->comboBoxPrefix1->addItem ("ram");
    ui->comboBoxPrefix1->addItem ("vcs");
    ui->comboBoxPrefix1->addItem ("loop");
    ui->comboBoxPrefix1->addItem ("sda");

//    QStringList *listCommand = 0x0;
//    QStringList keys;

//    keys.insert (0, tr ("Управление"));
//    keys.insert (1, tr (""));
//    keys.insert (2, tr (""));

    addTrackCommand (666, 0, tr ("Управление"));
    ui->comboBoxTypeManagement->addItem (tr ("Управление"));
    addTrackCommand (666, 105, tr ("Настройка"));
    ui->comboBoxTypeManagement->addItem (tr ("Настройка"));
    addTrackCommand (666, 111, tr ("Запрос"));
    ui->comboBoxTypeManagement->addItem (tr ("Запрос"));

//    listCommand = new QStringList;
//    listCommand->append ("");
//    listCommand->append ("");
//    listCommand->append ("");
//    listCommand->append ("");
//    listCommand->append ("");
//    listCommand->append ("");
//    ui->comboBoxTypeManagement->addItem (keys.at (0));
//    m_mapStringListCommand.insert (keys.at (0), listCommand);

    addTrackCommand (0, 600, tr ("Запуск"));
    addTrackCommand (0, 601, tr ("Остановка"));
    addTrackCommand (0, 602, tr ("Включение обдува"));
    addTrackCommand (0, 603, tr ("Выключение обдува"));
    addTrackCommand (0, 604, tr ("Задать скорость"), true);
    addTrackCommand (0, 605, tr ("Задать угол"), true);

//    listCommand = new QStringList;
//    listCommand->append ("");
//    listCommand->append ("");
//    listCommand->append ("");
//    listCommand->append ("");
//    listCommand->append ("");
//    listCommand->append ("");
//    listCommand->append ("");
//    listCommand->append ("");
//    listCommand->append ("");
//    ui->comboBoxTypeManagement->addItem (keys.at (1));
//    m_mapStringListCommand.insert (keys.at (1), listCommand);

    addTrackCommand (105, 110, tr ("Коэффициент K для скорости"), true);
    addTrackCommand (105, 111, tr ("Коэффициент B для скорости"), true);
    addTrackCommand (105, 112, tr ("Коэффициент К для угла"), true);
    addTrackCommand (105, 113, tr ("Коэффициент B для угла"), true);
    addTrackCommand (105, 114, tr ("Точность установки скорости"), true);
    addTrackCommand (105, 115, tr ("Точность установки угла"), true);
    addTrackCommand (105, 116, tr ("Угол верхнего положения платформы"), true);
    addTrackCommand (105, 117, tr ("Угол нижнего положения платформы"), true);
    addTrackCommand (105, 120, tr ("Период вызова модуля контроля"), true);

//    listCommand = new QStringList;
//    listCommand->append (tr (""));
//    listCommand->append ("");
//    listCommand->append ("");
//    listCommand->append ("");
//    listCommand->append ("");
//    listCommand->append ("");
//    ui->comboBoxTypeManagement->addItem (keys.at (2));
//    m_mapStringListCommand.insert (keys.at (2), listCommand);

    addTrackCommand (111, 30, tr ("Значение скорости"));
    addTrackCommand (111, 31, tr ("Значение угла"));
    addTrackCommand (111, 32, tr ("Пройденная дистанция"));
    addTrackCommand (111, 33, tr ("Время (сек.) после запуска"));
    addTrackCommand (111, 34, tr ("Пульс 1"));
    addTrackCommand (111, 35, tr ("Пульс 2"));


    QTextCodec* codec = QTextCodec::codecForName ("System");
    QTextCodec::setCodecForTr (codec);
    QTextCodec::setCodecForCStrings (codec);
    QTextCodec::setCodecForLocale (codec);

//    for (i = 0; i < m_mapStringListCommand [keys.at (0)].size (); i ++) {
//    if (m_mapStringListCommand [keys.at (0)])
//        ui->comboBoxCommand->clear ();
//        ui->comboBoxCommand->addItems (getStringListCommand (ui->comboBoxTypeManagement->currentText ()));
        ui->comboBoxCommand->addItems (getStringListCommand (0));
//    }

    ui->lineEditAbsolutePath->setText (QDir::currentPath ());

//    keys.clear ();
}

void contentComboBoxCommand (QString typeManagement) {

}

MainWindow::~MainWindow () {
//    QStringList *listCommand;
//    QList <QString> listKeys = m_mapStringListCommand.keys ();
//    while (listKeys.size ()) {
//        listCommand = (QStringList *) m_mapStringListCommand [listKeys.at (0)];
//        delete listCommand;
//        listKeys.removeAt (0);
//    }

    track_cmd *ptrTrackCmd = 0x0;
    while (m_vecTrackCommands.size ()) {
        ptrTrackCmd = m_vecTrackCommands.back ();
        delete ptrTrackCmd;
        m_vecTrackCommands.pop_back ();
    }

    free_usb_device_descs ();
#if defined __USB_H__
#else
    libusb_exit (m_ctx); //close the session
#endif

    delete ui;
}

QObject *MainWindow::getChildAtObjectName (QObject *parent, QString objName) {
    QObject *ptrObj = 0x0;
    unsigned short i = -1;

    QObjectList listChildren = parent->children ();

    for (i = 0; i < listChildren.size (); i ++) {
        ptrObj = listChildren.at (i);

        cout << ptrObj->objectName ().toStdString () << endl;
        if (ptrObj->objectName ().compare (objName) == 0)
            break;
        else
            ptrObj = getChildAtObjectName (ptrObj, objName);
    }

    if (i < listChildren.size ()) {
        return ptrObj;
    }
    else
        return 0x0;
}

QObject *MainWindow::getChildAtObjectName (QString objNameParent, QString objName) {
    QObject *ptrObj = 0x0;
    unsigned short i = -1;

    QObjectList listChildren = children ();

    for (i = 0; i < listChildren.size (); i ++) {
        ptrObj = listChildren.at (i);
        cout << ptrObj->objectName ().toStdString () << endl;
        if (ptrObj->objectName ().compare ("centralWidget") == 0)
            break;
    }

    if (i < listChildren.size ()) {
//            Потомки 'centralWidget'
        listChildren = ptrObj->children ();

        for (i = 0; i < listChildren.size (); i ++) {
            ptrObj = listChildren.at (i);
            cout << ptrObj->objectName ().toStdString () << endl;
            if (ptrObj->objectName ().compare (objNameParent) == 0)
                break;
        }

        if (i < listChildren.size ()) {
            listChildren = ptrObj->children ();

            for (i = 0; i < listChildren.size (); i ++) {
                ptrObj = listChildren.at (i);
                cout << ptrObj->objectName ().toStdString () << endl;
                if (ptrObj->objectName ().compare (objName) == 0)
                    break;
            }
        }
        else
            ;
    }
    else
        ;

    return ptrObj;
}

int MainWindow::countChildAtObjectName (QString objName) {
    getChildAtObjectName (this, objName);
}

void MainWindow::on_pushButtonAddPrefixFile_clicked () {
    QString commonPartObjectName = "comboBoxPrefix";
    QComboBox *ptrNewComboBoxPrefix = new QComboBox (ui->comboBoxPrefix1);

    ptrNewComboBoxPrefix->setObjectName (commonPartObjectName + QString::number (countChildAtObjectName (commonPartObjectName)));
}

void MainWindow::on_pushButtonExit_clicked () {
    close ();
}

void MainWindow::on_comboBoxTypeManagement_currentIndexChanged (const QString &arg1) {
    cout << arg1.toStdString () << endl;
//    cout << m_mapStringListCommand [arg1]->at (1).toStdString () << endl;
//    cout << m_mapStringListCommand ["Управление"] << endl;
    ui->comboBoxCommand->clear ();
    if (! arg1.isEmpty ())
        ui->comboBoxCommand->addItems (getStringListCommand (arg1));
}

void MainWindow::on_pushButtonAbsolutePath_clicked () {
    QDir dir (ui->lineEditAbsolutePath->text ());

    if (ui->radioButtonSelectFile->isChecked ()) {
//        QFileDialog::getOpenFileName (this,
//                                      tr ("Open Document"),
//                                      dir.absolutePath (),
//                                      tr ("Document files (*.doc *.rtf);;All files (*.*)"),
//                                      0,
//                                      QFileDialog::DontUseNativeDialog);

        QString filename = QFileDialog::getOpenFileName (this,
                                                         tr ("Выбрать файл порта"),
                                                         dir.absolutePath (),
//                                                         tr ("Document files (*.doc *.rtf);;All files (*.*)"));
                                                         tr ("Все файлы (*.*)"),
                                                         0,
                                                         QFileDialog::DontUseNativeDialog);
        if( !filename.isNull() )
        {
            qDebug( filename.toAscii() );
        }
    }
    else
        if (ui->radioButtonSelectDir->isChecked ()) {
            QString dirname = QFileDialog::getExistingDirectory (this,
                                                                 tr ("Выберите директорию с файлами для порта"),
                                                                 dir.absolutePath ());
            if (! dirname.isNull ()) {
                qDebug (dirname.toAscii ());
                ui->lineEditAbsolutePath->setText (dirname.toAscii ());
            }
            else
                ;
        }
        else
            ;
}

void MainWindow::on_radioButtonSelectFile_clicked () {
    bool state = false;
    ui->comboBoxPrefix1->setEnabled (state);
    ui->pushButtonAddPrefixFile->setEnabled (state);
    ui->spinBoxIteratorFiles->setEnabled (state);
    ui->pushButtonFindFile->setEnabled (state);
}

void MainWindow::on_radioButtonSelectDir_clicked () {
    bool state = true;
    ui->comboBoxPrefix1->setEnabled (state);
    ui->pushButtonAddPrefixFile->setEnabled (state);
    ui->spinBoxIteratorFiles->setEnabled (state);
    ui->pushButtonFindFile->setEnabled (state);
}

int MainWindow::fill_usb_device_desc
//#if defined __USB_H__
//    (void) {

//    struct usb_bus *usb_bus;
//    struct libusb_device *dev;

////    Уже ВЫПОЛНЕНо
////    usb_init();
////    usb_find_busses();
////    usb_find_devices();

//    for (usb_bus = usb_busses; usb_bus; usb_bus = usb_bus->next) {
//        for (dev = usb_bus->devices; dev; dev = dev->next) {
//            if ((dev->descriptor.idVendor == usVendorId) &&
//                (dev->descriptor.idProduct == usProductId))
//                return dev;
//            else
//                ;
//        }
//    }
//    return NULL;
//}
//#else
    (struct libusb_device *dev) {
    int iRes = 0; //Success

    husb_device_desc *ptrUsbDeviceDesc = new husb_device_desc;

    int r, i, j, k;
    libusb_device_descriptor desc;

#if defined __USB_H__
    desc = dev->descriptor;
    memcpy (&desc, &dev->descriptor, sizeof (libusb_device_descriptor));
#else
    r = libusb_get_device_descriptor  (dev, &desc);
    if  (r < 0) {
        cout << "failed to get device descriptor" << endl;
        iRes = -1;
    }
#endif
    if (iRes == 0) {
        memcpy (&ptrUsbDeviceDesc->desc, &desc, sizeof (libusb_device_descriptor));

#if defined __USB_H__
        ptrUsbDeviceDesc->numBus = -1;
#else
        ptrUsbDeviceDesc->numBus = libusb_get_bus_number (dev);
#endif

        cout << "Номер шины: " << (int) ptrUsbDeviceDesc->numBus << " | ";
        cout << "Number of possible configurations: " <<  (int) desc.bNumConfigurations << " | ";
        cout << "Device Class: " <<  (int) desc.bDeviceClass << " | ";
        cout << "VendorID: " << desc.idVendor << " | ";
        cout << "ProductID: " << desc.idProduct << endl;

        libusb_config_descriptor *config = 0x0;
#if defined __USB_H__
        config = new libusb_config_descriptor;
        memcpy (config, dev->config, sizeof (libusb_device_descriptor));
#else
        libusb_get_config_descriptor (dev, 0, &config);
#endif
        cout << "Interfaces: " << (int) config->bNumInterfaces << " ||| " << endl;

        ptrUsbDeviceDesc->vecInterfaceDetail.resize (config->bNumInterfaces);

        const libusb_interface *inter;
        const libusb_interface_descriptor *interdesc;
        const libusb_endpoint_descriptor *epdesc;
        for  (i = 0; i < (int) config->bNumInterfaces; i++) {
            inter = &config->interface [i];
            cout << "Number of alternate settings: " << inter->num_altsetting << " || " << endl;

            memcpy (&ptrUsbDeviceDesc->vecInterfaceDetail [i].interDesc, inter, sizeof (libusb_interface_descriptor));
//          extra, extra_length ???
            ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings.resize (inter->num_altsetting);

            for (j = 0; j < inter->num_altsetting; j++) {
                interdesc = &inter->altsetting [j];
                cout << "Interface Number: " <<  (int) interdesc->bInterfaceNumber << " | ";
                cout << "Number of endpoints: " <<  (int) interdesc->bNumEndpoints << " || ";

                ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings [j].vecEPDesc.resize (interdesc->bNumEndpoints);

                for (k = 0; k < (int) interdesc->bNumEndpoints; k++) {
                    epdesc = &interdesc->endpoint [k];
                    cout << "Descriptor Type: " <<  (int) epdesc->bDescriptorType << " | ";
                    cout << "EP Address: " << (int) epdesc->bEndpointAddress << " | ";

                    memcpy (&ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings [j].vecEPDesc [k], epdesc, sizeof (libusb_endpoint_descriptor));

//                    extra, extra_length ???
                    ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings [j].vecEPDesc [k].extra = 0x0;
#if defined __USB_H__
#else
                    ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings [j].vecEPDesc [k].extra_length = 0;
#endif
                }
//                if ((int) interdesc->bNumEndpoints == 0)
                    cout << endl;
            }
        }

        for (i = 0; i < 6; i ++)
            cout << "*";
        cout << endl << endl << endl;

#if defined __USB_H__
        delete config;
#else
        libusb_free_config_descriptor (config);
#endif

//        Повторим ПОСЛе освобождения РЕСУРСов
        for (i = 0; i < ptrUsbDeviceDesc->vecInterfaceDetail.size (); i ++) {
            for (j = 0; j < ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings.size (); j ++) {
                for (k = 0; k < ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings [j].vecEPDesc.size (); k ++) {
                    cout << "Descriptor Type: " <<  (int) ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings [j].vecEPDesc [k].bDescriptorType << " | ";
                    cout << "EP Address: " << (int) ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings [j].vecEPDesc [k].bEndpointAddress << " | ";
                }
                cout << endl;
            }
        }

        for (i = 0; i < 13; i ++)
            cout << "*";
        cout << endl << endl << endl;

        m_vecUsbDeviceDesc.push_back (ptrUsbDeviceDesc);

//        for (i = 0; i < ptrUsbDeviceDesc->vecInterfaceDetail.size (); i ++) {
//            for (j = 0; j < ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings.size (); j ++) {
//                ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings [j].vecEPDesc.clear ();
//            }
//            ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings.clear ();
//        }

//        delete ptrUsbDeviceDesc;
    }
    else
        ;

    return iRes;
}
//#endif

int MainWindow::free_usb_device_descs (void) {
    int iRes = 0; //Success
    int i, j;

    husb_device_desc *ptrUsbDeviceDesc = 0x0;
    while (! m_vecUsbDeviceDesc.empty ()) {
        ptrUsbDeviceDesc = m_vecUsbDeviceDesc.back ();

        for (i = 0; i < ptrUsbDeviceDesc->vecInterfaceDetail.size (); i ++) {
            for (j = 0; j < ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings.size (); j ++) {
                ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings [j].vecEPDesc.clear ();
            }
            ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings.clear ();
        }

        delete ptrUsbDeviceDesc;
        m_vecUsbDeviceDesc.pop_back ();
    }

    return iRes;
}

void MainWindow::fill_control_usb_value (void) {
    int numUSBDevice = 0, numInterface = 0, numAltSettings = 0, numEP = 0;

    cout << "Число USB устройств=" << m_vecUsbDeviceDesc.size () << endl;
    ui->spinBoxIteratorNumberDevice->setMinimum (numUSBDevice);
    ui->spinBoxIteratorNumberDevice->setValue (numUSBDevice);
//    cout << "Максимум для 'spinBoxIteratorNumberDevice'=" << ui->spinBoxIteratorNumberDevice->maximum () << endl;
    setSpinBoxValues (ui->spinBoxIteratorNumberDevice, m_vecUsbDeviceDesc.size () - 1);
//    cout << "Максимум для 'spinBoxIteratorNumberDevice'=" << ui->spinBoxIteratorNumberDevice->maximum () << endl;
    ui->labelVendorID->setText (QString::number (m_vecUsbDeviceDesc [numUSBDevice]->desc.idVendor).toAscii ());
    ui->labelProductID->setText (QString::number (m_vecUsbDeviceDesc [numUSBDevice]->desc.idProduct).toAscii ());
    ui->labelClassDevice->setText (QString::number (m_vecUsbDeviceDesc [numUSBDevice]->desc.bDeviceClass).toAscii ());

    setSpinBoxValues (ui->spinBoxIteratorNumberInterface, m_vecUsbDeviceDesc [numUSBDevice]->vecInterfaceDetail.size () - 1, numInterface);

    setSpinBoxValues (ui->spinBoxIteratorNumberSetinngs, m_vecUsbDeviceDesc [numUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings.size () - 1, numAltSettings);

    setSpinBoxValues (ui->spinBoxIteratorNumberEP, m_vecUsbDeviceDesc [numUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc.size () - 1, numEP);

    ui->labelTypeEP->setText (QString::number (m_vecUsbDeviceDesc [numUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc [numEP].bDescriptorType));
    ui->labelAdresEP->setText (QString::number (m_vecUsbDeviceDesc [numUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc [numEP].bEndpointAddress));
}

void MainWindow::on_spinBoxIteratorNumberDevice_valueChanged(int arg1) {
    int numUSBDevice = arg1, numInterface = 0, numAltSettings = 0, numEP = 0;

//    cout << "Максимум для 'spinBoxIteratorNumberDevice'=" << ui->spinBoxIteratorNumberDevice->maximum () << endl;
    if ((arg1) > -1 && (m_vecUsbDeviceDesc.size ())) {
        ui->labelVendorID->setText (QString::number (m_vecUsbDeviceDesc [numUSBDevice]->desc.idVendor).toAscii ());
        ui->labelProductID->setText (QString::number (m_vecUsbDeviceDesc [numUSBDevice]->desc.idProduct).toAscii ());
        ui->labelClassDevice->setText (QString::number (m_vecUsbDeviceDesc [numUSBDevice]->desc.bDeviceClass).toAscii ());

        setSpinBoxValues (ui->spinBoxIteratorNumberInterface, m_vecUsbDeviceDesc [numUSBDevice]->vecInterfaceDetail.size () - 1, numInterface);

        setSpinBoxValues (ui->spinBoxIteratorNumberSetinngs, m_vecUsbDeviceDesc [numUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings.size () - 1, numAltSettings);

        setSpinBoxValues (ui->spinBoxIteratorNumberEP, m_vecUsbDeviceDesc [numUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc.size () - 1, numEP);

        ui->labelTypeEP->setText (QString::number (m_vecUsbDeviceDesc [numUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc [numEP].bDescriptorType));
        ui->labelAdresEP->setText (QString::number (m_vecUsbDeviceDesc [numUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc [numEP].bEndpointAddress));
    }
    else
        ; //НЕ КОРРЕКТНые АРГументы
}

void MainWindow::on_pushButtonRun_clicked () {
    int i = -1;

    QString cmd = ui->lineEditCommand->text ();
    cout << "::on_pushButtonRun_clicked: cmd=" << cmd.toStdString () << "; length = " << cmd.length () << endl;

    cmd.append ('\r');
    cmd.append ('\n');
    cmd.append (0);
    cout << "length of command = " << cmd.length () << endl;

//    cout << "Send to treadmill = ";
//    for (i = 0; i < cmd.toAscii ().length (); i ++) {
//        cout << cmd.at (i).digitValue ();
//    }
//    cout << endl;

//    unsigned short LEN_CMD_RN = 0;
//    LEN_CMD_RN = cmd.toAscii ().length ();
//    char cmdRN [LEN_CMD_RN];
//    for (i = 0; i < cmd.toAscii ().length (); i ++) {
//        cmdRN [i] = cmd.at (i).toAscii ();
//    }
////    cmdRN [LEN_CMD_RN - 2] = 13;
////    cmdRN [LEN_CMD_RN - 1] = 10;

//    cout << "Send to treadmill = ";
//    for (i = 0; i < LEN_CMD_RN; i ++) {
//        cout << cmdRN [i];
//    }
//    cout << endl;

    char recieve [64];

    uint16_t usVendorId = -1, usProductId = -1;
    char name_driver_interface [2][NAME_MAX];
    int numUSBDevice = ui->spinBoxIteratorNumberDevice->value (),
        numInterface = ui->spinBoxIteratorNumberInterface->value (),
        numAltSettings = ui->spinBoxIteratorNumberSetinngs->value (),
        numEP = ui->labelAdresEP->text ().toInt ();

//    libusb_open_device ();

    libusb_device_handle *h_device = 0x0;
    int indxUSBDevice = -1;
    int iRes = 0;

    indxUSBDevice = QString (ui->spinBoxIteratorNumberDevice->text ()).toInt ();

    usVendorId = m_vecUsbDeviceDesc [indxUSBDevice]->desc.idVendor,
    usProductId = m_vecUsbDeviceDesc [indxUSBDevice]->desc.idProduct;

#if defined __USB_H__
    struct libusb_device *dev = 0x0;
    dev = usb_get_device_with_vid_pid (usVendorId, usProductId);

    if (dev) {
        h_device = usb_open (dev);
        cout << "open device as: " << dev->bus->location << "|||" << dev->bus->dirname << "||" << dev->filename << endl;

//        if (h_device) {
//        iRes = usb_get_driver_np (h_device, numInterface, name_driver_interface [numInterface], NAME_MAX);
//        cout << "usb_get_driver_np () = " << iRes << endl;
//        cout << "name interface of " << QString::number (numInterface).toStdString () << ":" << tr (name_driver_interface [numInterface]).toStdString () << endl;

        // Сброс  ДРАЙВЕРа по умолчанию
        iRes = usb_detach_kernel_driver_np (h_device, numInterface);
        cout << "usb_detach_kernel_driver_np () = " << iRes << endl;

        iRes = usb_reset (h_device);
        cout << "usb_reset () = " << iRes << endl;
        cout << "error state: " << usb_strerror () << endl;

        // Установка НОМЕРа интерфейсА
        cout << "usb_claim_interface (" << numInterface << ") = " << usb_claim_interface (h_device, numInterface) << endl;
        cout << "error state: " << usb_strerror () << endl;


//        Установка номерА настроЕК
//        usb_set_configuration (h_device, numAltSettings);
//        iRes = usb_set_altinterface (h_device, numAltSettings);
//        cout << "usb_set_altinterface (" << numAltSettings << ") = " << iRes << endl;
//        cout << "error state: " << usb_strerror () << endl;
    }
    else
        ;
#else
    h_device = libusb_open_device_with_vid_pid (m_ctx, usVendorId, usProductId);
#endif
    cout << "::on_pushButtonRun_clicked: handle(dev=" << indxUSBDevice << "," <<
                                                "vendor="<< m_vecUsbDeviceDesc [indxUSBDevice]->desc.idVendor << "," <<
                                                "product="<< m_vecUsbDeviceDesc [indxUSBDevice]->desc.idProduct <<
                                                ")=" << h_device << endl;

    /*****************************************************************/
    /* Контрольное сообщение */
    unsigned char uc;
    char *dummy;

//    iRes = usb_control_msg (h_device,

////                     USB_ENDPOINT_IN, //endpoint “pipe” to send the message to
////                    usb_sndctrlpipe (h_device, 0),

//                    0x12, //USB message request value
//                    0xc8, //USB message request type value
//                    (0x02 * 0x100) + 0x0a, //USB message value

//                    (0x00 * 0x100) + uc, //USB message index value
////                     0xff & (~uc),

//                     dummy, //pointer to the data to send
//                    8, //length in bytes of the data to send
//                    2 * HZ); //time in msecs to wait for the message to complete before timing out (if 0 the wait is forever)

//    iRes = usb_control_msg (h_device,

////                     USB_ENDPOINT_IN, //endpoint “pipe” to send the message to
////                    usb_sndctrlpipe (h_device, 0),

//                    0x83, //0x12, //USB message request value
//                    0xc8, //USB message request type value
//                    (0x02 * 0x100) + 0x0a, //USB message value

//                    (0x00 * 0x100) + uc, //USB message index value
////                     0xff & (~uc),

//                     dummy, //pointer to the data to send
//                    8, //length in bytes of the data to send
//                    2 * HZ); //time in msecs to wait for the message to complete before timing out (if 0 the wait is forever)
    /*****************************************************************/

    cout << "some time length of command = " << cmd.toAscii ().length () << endl;

    /*****************************************************************/
    /* ЗаписЬ в КУЧу */
//    usb_bulk_write (h_device, int ep, const char *bytes, int size, int timeout);
//    iRes = usb_bulk_write (h_device, m_vecUsbDeviceDesc [indxUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc [numEP].bEndpointAddress, cmd.toAscii (), 5, 5000);
//    iRes = usb_bulk_write (h_device, m_vecUsbDeviceDesc [indxUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc [0].bEndpointAddress, "*601*\r\n", 7, 5000);
    iRes = usb_bulk_write (h_device, m_vecUsbDeviceDesc [indxUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc [0].bEndpointAddress, cmd.toAscii (), cmd.toAscii ().length (), 5000);
    cout << "result of usb_bulk_write () = " << iRes << endl;
//    usb_bulk_read (h_device, int ep, const char *bytes, int size, int timeout);
    /*****************************************************************/

    /*****************************************************************/
    /* Чтение КУЧи */
    //iRes = usb_bulk_read (h_device, m_vecUsbDeviceDesc [indxUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc [numEP].bEndpointAddress, cmdRN, 7, 5000);
    iRes = usb_bulk_read (h_device, m_vecUsbDeviceDesc [indxUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc [1].bEndpointAddress, recieve, 64, 10000);
    cout << "result of usb_bulk_read () = " << iRes << "; recieve = " << recieve << endl;
//    cout << "error state: " << usb_strerror () << endl;
    /*****************************************************************/

    /*****************************************************************/
    /* ЗаписЬ по ПРЕРЫВАНию */
//    iRes = usb_interrupt_read (h_device, 0x83, cmdRN, LEN_CMD, 5000);
//    cout << "result of usb_interrupt_write () = " << iRes << endl;
//    cout << "error state: " << usb_strerror () << endl;
    /*****************************************************************/

    /*****************************************************************/
    /* Чтение по ПРЕРЫВАНию */
//    usb_interrupt_read (h_device, m_vecUsbDeviceDesc [indxUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc [numEP].bEndpointAddress, "*600*", 5, 5000);
    /*****************************************************************/

    ui->textEditCommands->insertPlainText (ui->lineEditCommand->text () + "\n");

    cout << "device close: " << libusb_close (h_device) << endl;
}

void MainWindow::on_comboBoxCommand_currentIndexChanged(const QString &arg1) {
    QString strCmd = getCommand (ui->comboBoxTypeManagement->currentText (), arg1);
    if (! strCmd.isEmpty ()) {
        ui->lineEditCommand->setText (strCmd);
    }
    else
        cout << "::on_comboBoxCommand_currentIndexChanged: " << "Empty command!" << endl;
}

void MainWindow::on_spinBoxIteratorNumberInterface_valueChanged (int arg1) {
    int numUSBDevice = ui->spinBoxIteratorNumberDevice->value (), numInterface = arg1, numAltSettings = 0, numEP = 0;

    setSpinBoxValues (ui->spinBoxIteratorNumberSetinngs, m_vecUsbDeviceDesc [numUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings.size () - 1, numAltSettings);

    setSpinBoxValues (ui->spinBoxIteratorNumberEP, m_vecUsbDeviceDesc [numUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc.size () - 1, numEP);

    if (m_vecUsbDeviceDesc [numUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc.size ()) {
        ui->labelTypeEP->setText (QString::number (m_vecUsbDeviceDesc [numUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc [numEP].bDescriptorType));
        ui->labelAdresEP->setText (QString::number (m_vecUsbDeviceDesc [numUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc [numEP].bEndpointAddress));
    }
    else {
        ui->labelTypeEP->setText (QString::number (-1));
        ui->labelAdresEP->setText (QString::number (-1));
    }
}

void MainWindow::on_spinBoxIteratorNumberSetinngs_valueChanged(int arg1) {
    int numUSBDevice = ui->spinBoxIteratorNumberDevice->value (), numInterface = ui->spinBoxIteratorNumberInterface->value (), numAltSettings = arg1, numEP = 0;

    setSpinBoxValues (ui->spinBoxIteratorNumberEP, m_vecUsbDeviceDesc [numUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc.size () - 1, numEP);

    if (m_vecUsbDeviceDesc [numUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc.size ()) {
        ui->labelTypeEP->setText (QString::number (m_vecUsbDeviceDesc [numUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc [numEP].bDescriptorType));
        ui->labelAdresEP->setText (QString::number (m_vecUsbDeviceDesc [numUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc [numEP].bEndpointAddress));
    }
    else {
        ui->labelTypeEP->setText (QString::number (-1));
        ui->labelAdresEP->setText (QString::number (-1));
    }
}

void MainWindow::on_spinBoxIteratorNumberEP_valueChanged(int arg1) {
    int numUSBDevice = ui->spinBoxIteratorNumberDevice->value (),
        numInterface = ui->spinBoxIteratorNumberInterface->value (),
        numAltSettings = ui->spinBoxIteratorNumberSetinngs->value (), numEP = arg1;

    ui->labelTypeEP->setText (QString::number (m_vecUsbDeviceDesc [numUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc [numEP].bDescriptorType));
    ui->labelAdresEP->setText (QString::number (m_vecUsbDeviceDesc [numUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc [numEP].bEndpointAddress));
}
