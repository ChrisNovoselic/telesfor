TEMPLATE = app
CONFIG += \
            qt3dquick \
#            qt3d
#            qtdesktop
            network

QT    +=    \
            core \
#            gui \
            declarative \
            opengl

INCLUDEPATH += \
            /usr/include/OGRE \
#            /usr/include/OIS \
#            /usr/local/include/aruco_ogre \
            /usr/include/libusb-1.0

LIBS  +=    \
            -l /usr/local/lib/libopencv_core.so \
            -l /usr/local/lib/libopencv_highgui.so \
#            -L/usr/local/lib/libopencv_calib3d.so \
            -l /usr/local/lib/libopencv_imgproc.so \
            \
            -l /usr/local/lib/libaruco.so \
            -l /usr/lib/libOgreMain.so \
#            -l /usr/lib/libOIS.so \
            -lusb

OTHER_FILES += \
    trainings.js \
    slidermanage.js \
    res/resources.cfg \
    res/plugins.cfg \
    res/ogre.cfg \
    patientList.js \
    objectReality.js \
    hcouch.js \
    cvcapture.js \
    res/cameraParametrs.yml \
    objectReality.qml \
    main.qml \
    HValueParams.qml \
    HRowsStepsLength.qml \
    HPopupWindow.qml \
    HManagementObjectReality.qml \
    HLatticeLine.qml \
    HDescObjectReality.qml \
    HColumnTreadmill.qml \
    HColumnTraining.qml \
    HColumnStatistic.qml \
    HColumnPatientList.qml \
    HColumnPatientFind.qml \
    HButtonPatient.qml \
    HButton.qml \
    HButtonRoutine.qml \
    HColumnPatientRoutine.qml

HEADERS += \
    htrainingdescitem.h \
    hsynchcoordinates.h \
    HQmlCVCapture.h \
    hqdeclarativeviewform.h \
    hogrewidget.h \
    hobjectrealitylattice.h \
    hobjectreality.h \
    hmat.h \
    hmanagementslider.h \
    hthreadmanagementthreadmill.h

SOURCES += \
    main.cpp \
    htrainingdescitem.cpp \
    hsynchcoordinates.cpp \
    HQmlCVCapture.cpp \
    hqdeclarativeviewform.cpp \
    hogrewidget.cpp \
    hobjectrealitylattice.cpp \
    hobjectreality.cpp \
    hmat.cpp \
    hmanagementslider.cpp \
    hthreadmanagementthreadmill.cpp
