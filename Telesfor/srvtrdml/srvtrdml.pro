#-------------------------------------------------
#
# Project created by QtCreator 2012-09-11T16:54:35
#
#-------------------------------------------------

QT       += core gui network

TARGET = srvtrdml
TEMPLATE = app


SOURCES += main.cpp \
    hmanagementtreadmill.cpp

HEADERS  += \
    hmanagementtreadmill.h

INCLUDEPATH += \
            /usr/include/libusb-1.0

LIBS  +=    \
            -lusb
