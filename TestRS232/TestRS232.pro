#-------------------------------------------------
#
# Project created by QtCreator 2012-06-16T14:35:23
#
#-------------------------------------------------

QT       += core gui

INCLUDEPATH += \
            /usr/include/libusb-1.0
#            /usr/include/linux

TARGET = TestRS232
TEMPLATE = app

LIBS  +=    \
#            -L /usr/lib/x86_64-linux-gnu \
#            -L /usr/lib/x86_64-linux-gnu/libusb-1.0.so
#            -L /usr/lib/i386-linux-gnu \
#            -l /usr/lib/i386-linux-gnu/libusb-1.0.so.0 \
            -lusb


SOURCES += main.cpp\
        mainwindow.cpp \
        temp.cpp

HEADERS  += mainwindow.h \
            temp.h

FORMS    += mainwindow.ui
