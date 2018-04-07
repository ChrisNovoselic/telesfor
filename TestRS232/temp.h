#ifndef TEMP_H
#define TEMP_H

#include <vector>

//#include <stdlib.h>
//#include <stdio.h>
//#include <stdlib.h>
#include <iostream> //cout
#include <sstream> //stringstream
#include <string.h> //strcmp
#include <sys/fcntl.h> //open, read, write, vlose

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

using namespace std;

#define ARGV_SUCCESS 0
#define ARGV_GUI 3
#define ARGV_CMD_START 1
#define ARGV_CMD_STOP 2
#define ARGV_NOT_READ -1
#define ARGV_INVALID -2
int readCommandLine (int , char **);
FILE *fNotEmpty (char *, char *);

struct haltsetting_desc {
    vector <libusb_endpoint_descriptor> vecEPDesc;
};

struct husb_interface_desc {
    libusb_interface_descriptor interDesc;
    vector <haltsetting_desc> vecAltSettings;
};

struct husb_device_desc {
    libusb_device_descriptor desc;
    uint8_t numBus;
    vector <husb_interface_desc> vecInterfaceDetail;
};

int readCommandLine  (int , char **);
//static struct libusb_device *usb_get_device_with_vid_pid (uint16_t , uint16_t );
//void printdev (libusb_device *);

#endif // TEMP_H
