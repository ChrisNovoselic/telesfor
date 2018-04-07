#ifndef MAINWINDOW_H
#define MAINWINDOW_H

//#include <iostream>
//using namespace std;

#include <QMainWindow>
#include <QSpinBox>
#include <QLineEdit>

#include <QTextCodec>

#include <QFileDialog>
#include <QDir>

#include "temp.h"

struct track_cmd {
    QString strDesc;
    unsigned short usId;
    unsigned short usParent;
    bool bVal;
};

namespace Ui {
    class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT
    
public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();

    Ui::MainWindow *ui; //move to PUBLIC temporarily
    vector <husb_device_desc *> m_vecUsbDeviceDesc; //still PUBLIC temporarily

//#if defined __USB_H__
//    int fill_usb_device_desc ();
//#else
    int fill_usb_device_desc (struct libusb_device *);
//#endif

    void fill_control_usb_value (void);
    int free_usb_device_descs (void);

    QObject *getChildAtObjectName (QString , QString );
    QObject *getChildAtObjectName (QObject *, QString );

    QString getCommand (QString management, QString cmd) {
        QString strRes = "";
        unsigned short usManagementId = getId (management), usCmdId = getId (cmd);

        if (! (usCmdId == 666)) {
            cout << "management id=" << usManagementId << endl;
            cout << "command id=" << usCmdId << endl;

            strRes = "*";

            if ((int) usManagementId == 0) {
                strRes += QString::number (usCmdId) + "*";
            }
            else {
                strRes += QString::number (usManagementId) + "#" + QString::number (usCmdId);
                if ((int) usManagementId == 111)
                    strRes += "*";
                else
                    strRes += "#" + QString::number (0) + "*";
            }
        }
        else
            ;

        return strRes;
    }

public slots:
    void on_pushButtonRun_clicked();

private slots:
    void on_pushButtonAddPrefixFile_clicked();

    void on_pushButtonExit_clicked();

    void on_comboBoxTypeManagement_currentIndexChanged(const QString &arg1);

    void on_pushButtonAbsolutePath_clicked();

    void on_radioButtonSelectFile_clicked();

    void on_radioButtonSelectDir_clicked();

    void on_spinBoxIteratorNumberDevice_valueChanged(int arg1);

    void on_comboBoxCommand_currentIndexChanged(const QString &arg1);

    void on_spinBoxIteratorNumberInterface_valueChanged(int arg1);

    void on_spinBoxIteratorNumberSetinngs_valueChanged(int arg1);

    void on_spinBoxIteratorNumberEP_valueChanged(int arg1);

private:
#if defined __USB_H__
#else
    libusb_context *m_ctx; //a libusb session
#endif

    int husb_init (void) {
        ssize_t cnt; //holding number of devices in list
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
        int cnt_buses = usb_find_busses();
        cnt = usb_find_devices ();
#else
        libusb_set_debug (m_ctx, 3); //set verbosity level to 3, as suggested in the documentation
        cnt = libusb_get_device_list (m_ctx, &devs); //get the list of devices
#endif

        if(cnt < 0) {
            cout << "Get Device Error" << endl; //there was an error
        }

    //    w.uispinBoxIteratorNumberDevice->;
        cout << cnt << " Devices in list." << endl; //print total number of usb devices

//        libusb_device_handle **handles;
//        int iOpenRes = 0;

//        libusb_init_device ()

    //        printdev (devs [i]); //print specs of this device
#if defined __USB_H__
        struct usb_bus *usb_bus;
        struct libusb_device *dev;

        for (usb_bus = usb_busses; usb_bus; usb_bus = usb_bus->next) {
            for (dev = usb_bus->devices; dev; dev = dev->next) {
                r = fill_usb_device_desc (dev);
            }
#else
        ssize_t i; //for iterating through the list
        for(i = 0; i < cnt; i++) {
            r = fill_usb_device_desc (devs [i]);  //print AND member specs of this device
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

    static struct libusb_device *usb_get_device_with_vid_pid (uint16_t usVendorId, uint16_t usProductId)
    {
        struct usb_bus *usb_bus;
        struct libusb_device *dev;

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

        return 0x0;
    }

    vector <track_cmd *> m_vecTrackCommands;
    void addTrackCommand (unsigned short parent, unsigned int cmd, QString desc, bool val = false) {
        track_cmd *ptrTrackCmd = new track_cmd;
        ptrTrackCmd->strDesc = desc;
        ptrTrackCmd->usId = cmd;
        ptrTrackCmd->usParent = parent;
        ptrTrackCmd->bVal = val;

        m_vecTrackCommands.push_back (ptrTrackCmd);
    }

    QStringList getStringListCommand (QString strParent) {
        QStringList strListRes;
        unsigned short idParent = getId (strParent);
        // ???
        if (idParent == 666)
            idParent = 0;
        // ???

        cout << "::getStringListCommand: arg=" << strParent.toStdString () << endl;

        track_cmd *ptrTrackCmd = 0x0;
        int i = 0;
        for (i; i < m_vecTrackCommands.size (); i ++) {
            ptrTrackCmd = m_vecTrackCommands.at (i);
            if (ptrTrackCmd->usParent == idParent)
                strListRes.append (ptrTrackCmd->strDesc);
        }

        return strListRes;
    }


    QStringList getStringListCommand (unsigned short idParent) {
        QStringList strListRes;

        cout << "::getStringListCommand: arg=" << QString::number (idParent).toStdString () << endl;

        track_cmd *ptrTrackCmd = 0x0;
        int i = 0;
        for (i; i < m_vecTrackCommands.size (); i ++) {
            ptrTrackCmd = m_vecTrackCommands.at (i);
            if (ptrTrackCmd->usParent == idParent)
                strListRes.append (ptrTrackCmd->strDesc);
        }

        return strListRes;
    }


    unsigned short getId (QString desc) {
        unsigned short usRes = 666;
        track_cmd *ptrTrackCmd = 0x0;
        int i = 0;
        for (i; i < m_vecTrackCommands.size (); i ++) {
            ptrTrackCmd = m_vecTrackCommands.at (i);
            if (ptrTrackCmd->strDesc.compare (desc) == 0)
                break;
        }

        if (i < m_vecTrackCommands.size ())
            usRes = ptrTrackCmd->usId;

        return usRes;
    }

    void setSpinBoxValues (QSpinBox *ptrSpinBox, int max, int val = 0) {
        cout << "::setSpinBoxValues:" << "max=" << max << ", val=" << val << endl;

        if (max < 0) {
            ptrSpinBox->setEnabled (false);
            ptrSpinBox->setMaximum (0);
            ptrSpinBox->setValue (0);
        }
        else {
            ptrSpinBox->setEnabled (true);
            ptrSpinBox->setMaximum (max);
            if (val < max + 1)
                ptrSpinBox->setValue (val);
            else
                ptrSpinBox->setValue (max);
        }
    }

    int countChildAtObjectName (QString );
    void contentComboBoxCommand (QString );
};

#endif // MAINWINDOW_H
