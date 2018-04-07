#include "temp.h"

#include <QString>
#include <QFile>
#include <QFileInfo>

//int init_libusb  (void) {
//    int iRes = 0; //Success
//    return iRes;
//}


//void printdev (libusb_device *dev) {
//    husb_device_desc *ptrUsbDeviceDesc = new husb_device_desc;

//    int i, j, k;
//    libusb_device_descriptor desc;

//    int r = libusb_get_device_descriptor  (dev, &desc);
//    if  (r < 0) {
//        cout << "failed to get device descriptor" << endl;
//        return ;
//    }

//    memcpy (&ptrUsbDeviceDesc->desc, &desc, sizeof (libusb_device_descriptor));

//    ptrUsbDeviceDesc->numBus = libusb_get_bus_number (dev);

//    cout << "Номер шины: " << (int) ptrUsbDeviceDesc->numBus << " | ";
//    cout << "Number of possible configurations: " <<  (int) desc.bNumConfigurations << " | ";
//    cout << "Device Class: " <<  (int) desc.bDeviceClass << " | ";
//    cout << "VendorID: " << desc.idVendor << " | ";
//    cout << "ProductID: " << desc.idProduct << endl;

//    libusb_config_descriptor *config;
//    libusb_get_config_descriptor (dev, 0, &config);
//    cout << "Interfaces: " << (int) config->bNumInterfaces << " ||| " << endl;

//    ptrUsbDeviceDesc->vecInterfaceDetail.resize (config->bNumInterfaces);

//    const libusb_interface *inter;
//    const libusb_interface_descriptor *interdesc;
//    const libusb_endpoint_descriptor *epdesc;
//    for  (i = 0; i < (int) config->bNumInterfaces; i++) {
//        inter = &config->interface [i];
//        cout << "Number of alternate settings: " << inter->num_altsetting << " || " << endl;

//        memcpy (&ptrUsbDeviceDesc->vecInterfaceDetail [i].interDesc, inter, sizeof (libusb_interface_descriptor));
////        extra, extra_length ???
//        ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings.resize (inter->num_altsetting);

//        for (j = 0; j < inter->num_altsetting; j++) {
//            interdesc = &inter->altsetting [j];
//            cout << "Interface Number: " <<  (int) interdesc->bInterfaceNumber << " | ";
//            cout << "Number of endpoints: " <<  (int) interdesc->bNumEndpoints << " || ";

//            ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings [j].vecEPDesc.resize (interdesc->bNumEndpoints);

//            for (k = 0; k < (int) interdesc->bNumEndpoints; k++) {
//                epdesc = &interdesc->endpoint [k];
//                cout << "Descriptor Type: " <<  (int) epdesc->bDescriptorType << " | ";
//                cout << "EP Address: " << (int) epdesc->bEndpointAddress << " | ";

//                memcpy (&ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings [j].vecEPDesc [k], epdesc, sizeof (libusb_endpoint_descriptor));
////                extra, extra_length ???
//                ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings [j].vecEPDesc [k].extra = 0x0;
//                ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings [j].vecEPDesc [k].extra_length = 0;
//            }
////            if ((int) interdesc->bNumEndpoints == 0)
//                cout << endl;
//        }
//    }

//    for (i = 0; i < 6; i ++)
//        cout << "*";
//    cout << endl << endl << endl;

//    libusb_free_config_descriptor (config);

////    Повторим ПОСЛе освобождения РЕСУРСов
//    for (i = 0; i < ptrUsbDeviceDesc->vecInterfaceDetail.size (); i ++) {
//        for (j = 0; j < ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings.size (); j ++) {
//            for (k = 0; k < ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings [j].vecEPDesc.size (); k ++) {
//                cout << "Descriptor Type: " <<  (int) ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings [j].vecEPDesc [k].bDescriptorType << " | ";
//                cout << "EP Address: " << (int) ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings [j].vecEPDesc [k].bEndpointAddress << " | ";
//            }
//            cout << endl;
//        }
//    }

//    for (i = 0; i < 13; i ++)
//        cout << "*";
//    cout << endl << endl << endl;

////    m_vecUsbDeviceDesc.push_back (ptrUsbDeviceDesc);

////    for (i = 0; i < ptrUsbDeviceDesc->vecInterfaceDetail.size (); i ++) {
////        for (j = 0; j < ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings.size (); j ++) {
////            ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings [j].vecEPDesc.clear ();
////        }
////        ptrUsbDeviceDesc->vecInterfaceDetail [i].vecAltSettings.clear ();
////    }

////    delete ptrUsbDeviceDesc;
//}

int readCommandLine  (int argc, char **argv)
{
    int iRes = ARGV_NOT_READ;

    if  (argc < 2) {
        cerr << "Invalid number of arguments\n" << endl;
        cerr << "Usage:  ([gui] start|stop)" << endl;

        iRes = ARGV_INVALID;
    }
    else {
        if  (strcmp  (argv [1], "gui") == 0) {
            iRes = ARGV_GUI;
        }
        else
            if  (strcmp  (argv [1], "start") == 0) {
                iRes = ARGV_CMD_START;
            }
            else
                if  (strcmp  (argv [1], "stop") == 0) {
                    iRes = ARGV_CMD_STOP;
                }
                else
                    ;
    }

    return iRes;
}

#define TYPE_LIB_FILE_STDLIB 0
#define TYPE_LIB_FILE_FSTREAM 1

FILE *fNotEmpty  (char *dev, char *prefix) {
    unsigned short TYPE_LIB_FILE;
    TYPE_LIB_FILE = TYPE_LIB_FILE_STDLIB;

    char *typeLibFile;
    switch  (TYPE_LIB_FILE) {
        case TYPE_LIB_FILE_STDLIB:
            typeLibFile = "<stdlib>";
            break;
        case TYPE_LIB_FILE_FSTREAM:
            typeLibFile = "<fstream>";
            break;
        default:
            ;
    }

    QFile qf;
    QFileInfo qfi;
    QString fname;
    int i = -1;
    qint64 lfile = -1;
    FILE *portFile = 0x0;
    int portHandle = -1; ssize_t sz_read; size_t sz_buffer = 1; char buffer [sz_buffer];

//    stringstream  fnamestream;
//    fnamestream.str  (std::string  ());
//    fnamestream << "/dev/" << dev << prefix << "6";

//    cout << fnamestream.str  () << endl;

//    fname.fromStdString  (fnamestream.str  ());
//    fname = QString  (fnamestream.get  (), fnamestream.gcount  ());

//    spinBoxIteratorFiles
    for  (i = 0; i < 66; i ++) {
        fname = "/dev/" + QString  (dev) + QString  (prefix) + QString::number  (i);

        qf.setFileName  (fname);
        qfi = QFileInfo  (fname);
        cout << "Length of " << fname.toStdString  () << ": " << qfi.size  () << endl;
        if  (qf.open  (QFile::ReadWrite)) {
            portHandle = qf.handle  ();
            lfile = qf.bytesAvailable  ();
            cout << "Succes open " << "QFile" << " file with name=" << fname.toStdString  () << ", length=" << lfile << endl;
            qf.close  ();
        }
        else
            ;

//        cout << fname.toAscii  () << endl;

        switch  (TYPE_LIB_FILE) {
            case TYPE_LIB_FILE_STDLIB:
                portHandle = open  (fname.toAscii  (), O_RDWR | O_NOCTTY);
//                portHandle = open  ("/dev/ttyS31", O_RDWR | O_NOCTTY);
                break;
            case TYPE_LIB_FILE_FSTREAM:
//                portFile = fopen  (fname.toAscii  (), "r");
                portFile = fopen  (fname.toAscii  (), "r+");
                break;
            default:
                ;
        }

        if  ( (! portFile == 0x0) ||  (!  (portHandle == -1))) {
            cout << "Succes open " << typeLibFile << " file with name=" << fname.toStdString  () << endl;

            switch  (TYPE_LIB_FILE) {
                case TYPE_LIB_FILE_STDLIB:
                    lfile = lseek  (portHandle, 0x0, SEEK_END);

                    if  (lfile > -1) {
                        sz_read = read  (portHandle, buffer, sz_buffer);

                        qf.open  (portHandle, QFile::ReadWrite);
                    }
                    else
                        ;
                    break;
                case TYPE_LIB_FILE_FSTREAM:
                    if  (fseek  (portFile, 0x0, SEEK_END)== 0) {
                        lfile = ftell  (portFile);

                        sz_read = fread  (buffer, sz_buffer, sz_buffer, portFile);

                        qf.open  (portFile, QFile::ReadWrite);
                    }
                    else
                        ;
                    break;
                default:
                    ;
            }

            if  (qf.isOpen  ()) {
                lfile = qf.bytesAvailable  ();

//                qf.read ()
                qf.close  ();
            }
            else
                ;

            switch  (TYPE_LIB_FILE) {
                case TYPE_LIB_FILE_STDLIB:
                    close  (portHandle);
                    break;
                case TYPE_LIB_FILE_FSTREAM:
                    fclose  (portFile);
                    break;
                default:
                    ;
            }

            portFile = 0x0;
            portHandle = -1;
        }
        else
            cout << "Error open " << typeLibFile << "file with name=" << fname.toStdString  () << endl;
    }
}
