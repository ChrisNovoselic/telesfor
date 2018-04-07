QT       += core gui network thread

TARGET = srvtrdml
TEMPLATE = app


SOURCES += main.cpp \
    hmanagementtreadmill.cpp \
    hthreadtcpsocket.cpp \
    happlication.cpp

HEADERS  += \
    hmanagementtreadmill.h \
    hthreadtcpsocket.h \
    happlication.h \
    hthreadtcpsocket.h \
    hmanagementtreadmill.h \
    happlication.h

INCLUDEPATH += \
            /usr/include/libusb-1.0

LIBS  +=    \
            -lusb
