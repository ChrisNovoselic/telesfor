#include "hmanagementtreadmill.h"

#include <iostream> //cout
using namespace std;

HManagementTreadmill::HManagementTreadmill(QObject *parent) : QObject(parent) {
//    В дальнейшем из 'main.qml'
    m_usVendorId = 0x8765; m_usProductId = 0x1116;
    m_numUSBDevice = -1;
    m_iCountInterfaces = 2; m_numInterface = 1;
    m_numAltSettings = 1;
    m_numEPIn = 1;
    m_adresNumEPIn = 0x01;
    m_numEPOut = 0;
    m_adresNumEPOut = 0x82;

    m_hDevice = 0x0;
    m_UsbDevice = 0x0;
}

HManagementTreadmill::~HManagementTreadmill (void) {
    if (m_hDevice) {
#if defined __USB_H__
        cout << "device close: " <<
#else
#endif
        libusb_close (m_hDevice)
#if defined __USB_H__
        << endl
#else
#endif
        ;
    }
    else
        ;

    cout << "~HManagementTreadmill = " << endl;
}

int HManagementTreadmill::fill_usb_device_desc
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

int HManagementTreadmill::free_usb_device_descs (void) {
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

int HManagementTreadmill::husb_device_init (void) {
    int iRes = husb_init ();

    m_UsbDevice = usb_get_device_with_vid_pid ();

#if defined __USB_H__
    if (m_UsbDevice) {
        m_hDevice = usb_open (m_UsbDevice);
        if (m_hDevice) {
            cout << "open device as: " << m_UsbDevice->bus->location << "|||" <<
                                            m_UsbDevice->bus->dirname << "||" <<
                                            m_UsbDevice->filename << endl;

            usb_device_settings ();
        }
        else
            ;
#else
    if (m_ctx) {
        m_hDevice = libusb_open_device_with_vid_pid (m_ctx, usVendorId, usProductId);
#endif
    }
    else {
        iRes = -1;
        cout << "device not init!" << endl;
    }

    if (m_hDevice == 0x0) {
        iRes = -2;
        cout << "open device is failed!" << endl;
    }
    else
        ;

    return iRes;
}

int HManagementTreadmill::husb_init (void) {
    ssize_t cnt_devices, cnt_buses; //holding number of devices in list
    int r; //for return values

#if defined __USB_H__
#else
    libusb_device **devs;//pointer to pointer of device, used to retrieve a list of devices

    r = libusb_init (&m_ctx); //initialize a library session
    if (r < 0) {
        cout << "Init Error "<< r << endl; //there was an error
        return -1;
    }
#endif

#if defined __USB_H__
    libusb_init ();
    libusb_set_debug (255); //set verbosity level to 3, as suggested in the documentation
    cnt_buses = usb_find_busses();
    cnt_devices = usb_find_devices ();
#else
    libusb_set_debug (m_ctx, 3); //set verbosity level to 3, as suggested in the documentation
    cnt_devices = libusb_get_device_list (m_ctx, &devs); //get the list of devices
#endif

    if(cnt_devices < 0) {
        cout << "Get Device Error" << endl; //there was an error
    }

//    w.uispinBoxIteratorNumberDevice->;
    cout << cnt_devices << " Devices in list." << endl; //print total number of usb devices

//        libusb_device_handle **handles;
//        int iOpenRes = 0;

//        libusb_init_device ()

//        printdev (devs [i]); //print specs of this device
#if defined __USB_H__
    struct usb_bus *usb_bus;
    struct libusb_device *dev;

    for (usb_bus = usb_busses; usb_bus; usb_bus = usb_bus->next) {
        for (dev = usb_bus->devices; dev; dev = dev->next) {
//            r = fill_usb_device_desc (dev);
        }
#else
    ssize_t i; //for iterating through the list
    for(i = 0; i < cnt_devices; i++) {
//        r = fill_usb_device_desc (devs [i]);  //print AND member specs of this device
//            iOpenRes = libusb_open (devs [i], handles);
#endif
    }

//    libusb_device *strUSBDevice;
//    libusb_device_handle *h = libusb_open (strUSBDevice);

#if defined __USB_H__
#else
    libusb_free_device_list (devs, 1); //free the list, unref the devices in it
#endif
}

struct libusb_device *HManagementTreadmill::usb_get_device_with_vid_pid (uint16_t usVendorId, uint16_t usProductId) {
    struct libusb_device *dev;

#if defined __USB_H__
    struct usb_bus *usb_bus;

//    usb_init();
//    usb_find_busses();
//    usb_find_devices();

    for (usb_bus = usb_busses; usb_bus; usb_bus = usb_bus->next) {
        for (dev = usb_bus->devices; dev; dev = dev->next) {
            if ((dev->descriptor.idVendor == usVendorId) &&
                (dev->descriptor.idProduct == usProductId)) {
                return dev;
            }
        }
    }
#else
#endif

    return 0x0;
}

int HManagementTreadmill::executeCommand (QString cmd) {
    int iRes = 0; //Succeess

    cout << "HManagementTreadmill::executeCommand: cmd=" << cmd.toStdString () << "; length = " << cmd.length () << endl;

    cmd.append ('\r');
    cmd.append ('\n');
    cmd.append (0);

    if (m_hDevice) {
#if defined __USB_H__
        /*****************************************************************/
        /* ЗаписЬ в КУЧу */
//        usb_bulk_write (h_device, int ep, const char *bytes, int size, int timeout);
//        iRes = usb_bulk_write (h_device, m_vecUsbDeviceDesc [indxUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc [numEP].bEndpointAddress, cmd.toAscii (), 5, 5000);
//        iRes = usb_bulk_write (h_device, m_vecUsbDeviceDesc [indxUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc [0].bEndpointAddress, "*601*\r\n", 7, 5000);
//        iRes = usb_bulk_write (h_device, m_vecUsbDeviceDesc [indxUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc [0].bEndpointAddress, cmd.toAscii (), cmd.toAscii ().length (), 5000);
        iRes = usb_bulk_write (m_hDevice, m_adresNumEPIn, cmd.toAscii (), cmd.toAscii ().length (), 5000);
//        iRes = usb_interrupt_write (h_device, 0x83, cmd.toAscii (), cmd.toAscii ().length (), 5000);
//        cout << "result of usb_bulk_write () = " << iRes << endl;
//        usb_bulk_read (h_device, int ep, const char *bytes, int size, int timeout);
        /*****************************************************************/

        /*****************************************************************/
        /* Чтение КУЧи */
//        iRes = usb_bulk_read (h_device, m_vecUsbDeviceDesc [indxUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc [numEP].bEndpointAddress, cmdRN, 7, 5000);
//        iRes = usb_bulk_read (h_device, m_vecUsbDeviceDesc [indxUSBDevice]->vecInterfaceDetail [numInterface].vecAltSettings [numAltSettings].vecEPDesc [1].bEndpointAddress, recieve, 64, 10000);
        memset (m_recieveCommand, 0x0, 64);
        iRes = usb_bulk_read (m_hDevice, m_adresNumEPOut, m_recieveCommand, 64, 10);
//        cout << "result of usb_bulk_read () = " << iRes << "; recieve = " << m_recieve << endl;
        iRes = usb_bulk_read (m_hDevice, m_adresNumEPOut, m_recieveCommand, 64, 10);
//        cout << "result of usb_bulk_read () = " << iRes << "; recieve = " << m_recieve << endl;
//        cout << "error state: " << usb_strerror () << endl;
        /*****************************************************************/
#else
        int actualLength = -1;
        iRes = libusb_bulk_transfer (h_device, m_adresNumEPIn, (unsigned char *) cmd.data (), cmd.length (), &actualLength, 5000);
//        cout << "result of libusb_bulk_transfer () = " << iRes << "; recieve = " << m_recieve << endl;
        iRes = libusb_bulk_transfer (h_device, m_adresNumEPOut, (unsigned char *) cmd.data (), cmd.length (), &actualLength, 5000);
//        cout << "result of libusb_bulk_transfer () = " << iRes << "; recieve = " << m_recieve << endl;
#endif
    }
    else
        ; //hdevice is NULL

    cout << "HManagementTreadmill::executeCommand: result byte = ";
    if (m_recieveCommand [0]) {
        cout << m_recieveCommand;

        int posPulse = -1;
        if ((cmd.indexOf ("111") > -1) && ((cmd.indexOf ("34") > -1) || (cmd.indexOf ("35") > -1)) && (posPulse = cmd.indexOf (":") > -1)) {
            memset (m_recievePulse, 0x0, 64);
            posPulse ++;
            memcpy (m_recievePulse, m_recieveCommand + posPulse, 64 - posPulse);
        }
    }
    else
        cout << endl;
}

QString HManagementTreadmill::readRecieve (void) {
    int i = 0;
//    while (! (m_recieveCommand [i] == '='))
//        i ++;

//    return QString (m_recieveCommand + ++ i);
    return QString (m_recieveCommand);
}

QString HManagementTreadmill::readPulse (void) {
    QString strRes (m_recievePulse);
    if ((m_recievePulse [0] < 48) || (m_recievePulse [0] > 57)) {
        strRes = QString ("NaN");
    }
    else {
        strRes = QString (m_recievePulse);
    }

    cout << "HManagementTreadmill::readPulse () = " << strRes.toStdString () << endl;

    return strRes;
}

int HManagementTreadmill::usb_device_settings (void) {
    int iRes = 0; //Success

    if (m_hDevice) {
//        iRes = usb_get_driver_np (h_device, numInterface, name_driver_interface [numInterface], NAME_MAX);
//        cout << "usb_get_driver_np () = " << iRes << endl;
//        cout << "name interface of " << QString::number (numInterface).toStdString () << ":" << tr (name_driver_interface [numInterface]).toStdString () << endl;

        // Сброс  ДРАЙВЕРа по умолчанию
        iRes = usb_detach_kernel_driver_np (m_hDevice, m_numInterface);
        cout << "usb_detach_kernel_driver_np () = " << iRes << endl;
        if ((! (iRes == 0)) && (! (iRes == -61)))
            cout << "error state: " << usb_strerror () << endl;
        else {
            iRes = usb_reset (m_hDevice);
            cout << "usb_reset () = " << iRes << endl;
            if (! (iRes == 0))
                cout << "error state: " << usb_strerror () << endl;
            else {
                // Установка НОМЕРа интерфейсА
                iRes = usb_claim_interface (m_hDevice, m_numInterface);
                cout << "usb_claim_interface (" << m_numInterface << ") = " << iRes << endl;
                if (! (iRes == 0))
                    cout << "error state: " << usb_strerror () << endl;
                else {
//                    Установка номерА настроЕК
//                    usb_set_configuration (m_hDevice, numAltSettings);
//                    iRes = usb_set_altinterface (m_hDevice, numAltSettings);
//                    cout << "usb_set_altinterface (" << numAltSettings << ") = " << iRes << endl;
//                    cout << "error state: " << usb_strerror () << endl;
                }
            }
        }
    }
    else { //Для устройства не вызван метод 'open'
        cout << "HManagementTreadmill::usb_device_settings () " << "Для устройства не вызван метод 'open'" << endl;
        iRes = -1;
    }

    return iRes;
}
