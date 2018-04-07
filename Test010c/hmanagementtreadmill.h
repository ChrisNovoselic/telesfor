#ifndef HMANAGEMENTTREADMILL_H
#define HMANAGEMENTTREADMILL_H

#include <QObject>

#include <vector>

//#include <libusb.h>
#include <usb.h>

#if defined LIBUSB_H
#else
#define libusb_interface                usb_interface
#define libusb_config_descriptor        usb_config_descriptor
#define libusb_open_device_with_vid_pid usb_open_device_with_vid_pid
#define libusb_device_handle            usb_dev_handle
#define libusb_set_debug                usb_set_debug
#define libusb_context                  usb_context
#define libusb_init                     usb_init
#define libusb_device                   usb_device
#define libusb_device_descriptor        usb_device_descriptor
#define libusb_interface_descriptor     usb_interface_descriptor
#define libusb_endpoint_descriptor      usb_endpoint_descriptor
#define libusb_close                    usb_close
#endif

struct haltsetting_desc {
    std::vector <libusb_endpoint_descriptor> vecEPDesc;
};

struct husb_interface_desc {
    libusb_interface_descriptor interDesc;
    std::vector <haltsetting_desc> vecAltSettings;
};

struct husb_device_desc {
    libusb_device_descriptor desc;
    uint8_t numBus;
    std::vector <husb_interface_desc> vecInterfaceDetail;
};

class HManagementTreadmill : public QObject
{
    Q_OBJECT
public:
    explicit HManagementTreadmill(QObject *parent = 0);

    std::vector <husb_device_desc *> m_vecUsbDeviceDesc; //still PUBLIC temporarily

    int husb_init (void);
    static struct libusb_device *usb_get_device_with_vid_pid (uint16_t , uint16_t );
    int executeCommand (QString );
    QString readPulse (void);

    int fill_usb_device_desc (struct libusb_device *);
#if defined __USB_H__
//    int fill_usb_device_desc ();
#else
    libusb_context *m_ctx;
#endif

//    void fill_control_usb_value (void);
    int free_usb_device_descs (void);
    
signals:
    
public slots:

private:
    char m_recieve [64];
    
};

#endif // HMANAGEMENTTREADMILL_H
