/********************************************************************************
** Form generated from reading UI file 'mainwindow.ui'
**
** Created: Sun Jun 24 15:13:41 2012
**      by: Qt User Interface Compiler version 4.8.0
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_MAINWINDOW_H
#define UI_MAINWINDOW_H

#include <QtCore/QVariant>
#include <QtGui/QAction>
#include <QtGui/QApplication>
#include <QtGui/QButtonGroup>
#include <QtGui/QComboBox>
#include <QtGui/QFrame>
#include <QtGui/QGroupBox>
#include <QtGui/QHeaderView>
#include <QtGui/QLabel>
#include <QtGui/QLineEdit>
#include <QtGui/QMainWindow>
#include <QtGui/QMenuBar>
#include <QtGui/QPushButton>
#include <QtGui/QRadioButton>
#include <QtGui/QSpinBox>
#include <QtGui/QStatusBar>
#include <QtGui/QTextEdit>
#include <QtGui/QToolBar>
#include <QtGui/QWidget>

QT_BEGIN_NAMESPACE

class Ui_MainWindow
{
public:
    QWidget *centralWidget;
    QGroupBox *groupBoxAbsolutePath;
    QRadioButton *radioButtonSelectDir;
    QRadioButton *radioButtonSelectFile;
    QPushButton *pushButtonAbsolutePath;
    QLineEdit *lineEditAbsolutePath;
    QSpinBox *spinBoxIteratorFiles;
    QPushButton *pushButtonFindFile;
    QPushButton *pushButtonAddPrefixFile;
    QLabel *label;
    QComboBox *comboBoxPrefix1;
    QLabel *labelFile;
    QRadioButton *radioButtoUSB;
    QLabel *labelNumberUSB;
    QSpinBox *spinBoxIteratorNumberDevice;
    QLabel *labelNumberDeviceDesc;
    QLabel *labelVendorIDDesc;
    QLabel *labelProductIDDesc;
    QSpinBox *spinBoxIteratorNumberInterface;
    QLabel *labelNumberInterfaceDesc;
    QLabel *labelNumberEPDesc;
    QSpinBox *spinBoxIteratorNumberEP;
    QLabel *labelAdresEPDesc;
    QLabel *labelTypeEPDesc;
    QLabel *labelProductID;
    QLabel *labelVendorID;
    QLabel *labelClassDevice;
    QLabel *labelTypeEP;
    QLabel *labelAdresEP;
    QLabel *labelNumberSetinngsDesc;
    QSpinBox *spinBoxIteratorNumberSetinngs;
    QLabel *labelNumberBus;
    QLabel *labelNumberBusDesc;
    QGroupBox *groupBoxCommand;
    QSpinBox *spinBoxCommandParametr;
    QComboBox *comboBoxTypeManagement;
    QComboBox *comboBoxCommand;
    QPushButton *pushButtonRun;
    QTextEdit *textEditCommands;
    QPushButton *pushButtonExit;
    QLineEdit *lineEditCommand;
    QFrame *line;
    QMenuBar *menuBar;
    QToolBar *mainToolBar;
    QStatusBar *statusBar;

    void setupUi(QMainWindow *MainWindow)
    {
        if (MainWindow->objectName().isEmpty())
            MainWindow->setObjectName(QString::fromUtf8("MainWindow"));
        MainWindow->resize(400, 572);
        centralWidget = new QWidget(MainWindow);
        centralWidget->setObjectName(QString::fromUtf8("centralWidget"));
        groupBoxAbsolutePath = new QGroupBox(centralWidget);
        groupBoxAbsolutePath->setObjectName(QString::fromUtf8("groupBoxAbsolutePath"));
        groupBoxAbsolutePath->setGeometry(QRect(5, 0, 381, 331));
        groupBoxAbsolutePath->setFlat(true);
        groupBoxAbsolutePath->setCheckable(false);
        radioButtonSelectDir = new QRadioButton(groupBoxAbsolutePath);
        radioButtonSelectDir->setObjectName(QString::fromUtf8("radioButtonSelectDir"));
        radioButtonSelectDir->setGeometry(QRect(0, 20, 280, 22));
        radioButtonSelectDir->setChecked(false);
        radioButtonSelectFile = new QRadioButton(groupBoxAbsolutePath);
        radioButtonSelectFile->setObjectName(QString::fromUtf8("radioButtonSelectFile"));
        radioButtonSelectFile->setGeometry(QRect(0, 100, 280, 22));
        radioButtonSelectFile->setChecked(false);
        pushButtonAbsolutePath = new QPushButton(groupBoxAbsolutePath);
        pushButtonAbsolutePath->setObjectName(QString::fromUtf8("pushButtonAbsolutePath"));
        pushButtonAbsolutePath->setGeometry(QRect(300, 120, 80, 28));
        lineEditAbsolutePath = new QLineEdit(groupBoxAbsolutePath);
        lineEditAbsolutePath->setObjectName(QString::fromUtf8("lineEditAbsolutePath"));
        lineEditAbsolutePath->setGeometry(QRect(0, 120, 290, 28));
        spinBoxIteratorFiles = new QSpinBox(groupBoxAbsolutePath);
        spinBoxIteratorFiles->setObjectName(QString::fromUtf8("spinBoxIteratorFiles"));
        spinBoxIteratorFiles->setGeometry(QRect(130, 70, 45, 28));
        spinBoxIteratorFiles->setMaximum(66);
        spinBoxIteratorFiles->setSingleStep(1);
        pushButtonFindFile = new QPushButton(groupBoxAbsolutePath);
        pushButtonFindFile->setObjectName(QString::fromUtf8("pushButtonFindFile"));
        pushButtonFindFile->setGeometry(QRect(300, 70, 80, 28));
        pushButtonAddPrefixFile = new QPushButton(groupBoxAbsolutePath);
        pushButtonAddPrefixFile->setObjectName(QString::fromUtf8("pushButtonAddPrefixFile"));
        pushButtonAddPrefixFile->setGeometry(QRect(70, 70, 50, 28));
        label = new QLabel(groupBoxAbsolutePath);
        label->setObjectName(QString::fromUtf8("label"));
        label->setGeometry(QRect(0, 40, 380, 28));
        comboBoxPrefix1 = new QComboBox(groupBoxAbsolutePath);
        comboBoxPrefix1->setObjectName(QString::fromUtf8("comboBoxPrefix1"));
        comboBoxPrefix1->setGeometry(QRect(0, 70, 60, 28));
        labelFile = new QLabel(groupBoxAbsolutePath);
        labelFile->setObjectName(QString::fromUtf8("labelFile"));
        labelFile->setGeometry(QRect(0, 150, 380, 28));
        QFont font;
        font.setBold(true);
        font.setWeight(75);
        labelFile->setFont(font);
        radioButtoUSB = new QRadioButton(groupBoxAbsolutePath);
        radioButtoUSB->setObjectName(QString::fromUtf8("radioButtoUSB"));
        radioButtoUSB->setGeometry(QRect(0, 180, 280, 22));
        radioButtoUSB->setChecked(true);
        labelNumberUSB = new QLabel(groupBoxAbsolutePath);
        labelNumberUSB->setObjectName(QString::fromUtf8("labelNumberUSB"));
        labelNumberUSB->setGeometry(QRect(0, 210, 141, 22));
        spinBoxIteratorNumberDevice = new QSpinBox(groupBoxAbsolutePath);
        spinBoxIteratorNumberDevice->setObjectName(QString::fromUtf8("spinBoxIteratorNumberDevice"));
        spinBoxIteratorNumberDevice->setGeometry(QRect(140, 210, 40, 22));
        spinBoxIteratorNumberDevice->setMaximum(66);
        spinBoxIteratorNumberDevice->setSingleStep(1);
        labelNumberDeviceDesc = new QLabel(groupBoxAbsolutePath);
        labelNumberDeviceDesc->setObjectName(QString::fromUtf8("labelNumberDeviceDesc"));
        labelNumberDeviceDesc->setGeometry(QRect(0, 260, 130, 22));
        labelVendorIDDesc = new QLabel(groupBoxAbsolutePath);
        labelVendorIDDesc->setObjectName(QString::fromUtf8("labelVendorIDDesc"));
        labelVendorIDDesc->setGeometry(QRect(0, 285, 130, 22));
        labelProductIDDesc = new QLabel(groupBoxAbsolutePath);
        labelProductIDDesc->setObjectName(QString::fromUtf8("labelProductIDDesc"));
        labelProductIDDesc->setGeometry(QRect(0, 310, 130, 22));
        spinBoxIteratorNumberInterface = new QSpinBox(groupBoxAbsolutePath);
        spinBoxIteratorNumberInterface->setObjectName(QString::fromUtf8("spinBoxIteratorNumberInterface"));
        spinBoxIteratorNumberInterface->setGeometry(QRect(340, 210, 40, 22));
        spinBoxIteratorNumberInterface->setMaximum(66);
        spinBoxIteratorNumberInterface->setSingleStep(1);
        labelNumberInterfaceDesc = new QLabel(groupBoxAbsolutePath);
        labelNumberInterfaceDesc->setObjectName(QString::fromUtf8("labelNumberInterfaceDesc"));
        labelNumberInterfaceDesc->setGeometry(QRect(190, 210, 141, 22));
        labelNumberEPDesc = new QLabel(groupBoxAbsolutePath);
        labelNumberEPDesc->setObjectName(QString::fromUtf8("labelNumberEPDesc"));
        labelNumberEPDesc->setGeometry(QRect(190, 260, 141, 22));
        spinBoxIteratorNumberEP = new QSpinBox(groupBoxAbsolutePath);
        spinBoxIteratorNumberEP->setObjectName(QString::fromUtf8("spinBoxIteratorNumberEP"));
        spinBoxIteratorNumberEP->setGeometry(QRect(340, 260, 40, 22));
        spinBoxIteratorNumberEP->setMaximum(66);
        spinBoxIteratorNumberEP->setSingleStep(1);
        labelAdresEPDesc = new QLabel(groupBoxAbsolutePath);
        labelAdresEPDesc->setObjectName(QString::fromUtf8("labelAdresEPDesc"));
        labelAdresEPDesc->setGeometry(QRect(190, 310, 130, 22));
        labelTypeEPDesc = new QLabel(groupBoxAbsolutePath);
        labelTypeEPDesc->setObjectName(QString::fromUtf8("labelTypeEPDesc"));
        labelTypeEPDesc->setGeometry(QRect(190, 285, 130, 22));
        labelProductID = new QLabel(groupBoxAbsolutePath);
        labelProductID->setObjectName(QString::fromUtf8("labelProductID"));
        labelProductID->setGeometry(QRect(140, 310, 40, 22));
        labelVendorID = new QLabel(groupBoxAbsolutePath);
        labelVendorID->setObjectName(QString::fromUtf8("labelVendorID"));
        labelVendorID->setGeometry(QRect(140, 285, 40, 22));
        labelClassDevice = new QLabel(groupBoxAbsolutePath);
        labelClassDevice->setObjectName(QString::fromUtf8("labelClassDevice"));
        labelClassDevice->setGeometry(QRect(140, 260, 40, 22));
        labelTypeEP = new QLabel(groupBoxAbsolutePath);
        labelTypeEP->setObjectName(QString::fromUtf8("labelTypeEP"));
        labelTypeEP->setGeometry(QRect(340, 285, 40, 22));
        labelAdresEP = new QLabel(groupBoxAbsolutePath);
        labelAdresEP->setObjectName(QString::fromUtf8("labelAdresEP"));
        labelAdresEP->setGeometry(QRect(340, 310, 40, 22));
        labelNumberSetinngsDesc = new QLabel(groupBoxAbsolutePath);
        labelNumberSetinngsDesc->setObjectName(QString::fromUtf8("labelNumberSetinngsDesc"));
        labelNumberSetinngsDesc->setGeometry(QRect(190, 235, 141, 22));
        spinBoxIteratorNumberSetinngs = new QSpinBox(groupBoxAbsolutePath);
        spinBoxIteratorNumberSetinngs->setObjectName(QString::fromUtf8("spinBoxIteratorNumberSetinngs"));
        spinBoxIteratorNumberSetinngs->setGeometry(QRect(340, 235, 40, 22));
        spinBoxIteratorNumberSetinngs->setMaximum(66);
        spinBoxIteratorNumberSetinngs->setSingleStep(1);
        labelNumberBus = new QLabel(groupBoxAbsolutePath);
        labelNumberBus->setObjectName(QString::fromUtf8("labelNumberBus"));
        labelNumberBus->setGeometry(QRect(140, 235, 40, 22));
        labelNumberBusDesc = new QLabel(groupBoxAbsolutePath);
        labelNumberBusDesc->setObjectName(QString::fromUtf8("labelNumberBusDesc"));
        labelNumberBusDesc->setGeometry(QRect(0, 235, 130, 22));
        groupBoxCommand = new QGroupBox(centralWidget);
        groupBoxCommand->setObjectName(QString::fromUtf8("groupBoxCommand"));
        groupBoxCommand->setGeometry(QRect(5, 360, 391, 171));
        spinBoxCommandParametr = new QSpinBox(groupBoxCommand);
        spinBoxCommandParametr->setObjectName(QString::fromUtf8("spinBoxCommandParametr"));
        spinBoxCommandParametr->setGeometry(QRect(320, 30, 70, 28));
        spinBoxCommandParametr->setMaximum(66);
        spinBoxCommandParametr->setSingleStep(0);
        comboBoxTypeManagement = new QComboBox(groupBoxCommand);
        comboBoxTypeManagement->setObjectName(QString::fromUtf8("comboBoxTypeManagement"));
        comboBoxTypeManagement->setGeometry(QRect(0, 30, 150, 28));
        comboBoxCommand = new QComboBox(groupBoxCommand);
        comboBoxCommand->setObjectName(QString::fromUtf8("comboBoxCommand"));
        comboBoxCommand->setGeometry(QRect(160, 30, 150, 28));
        pushButtonRun = new QPushButton(groupBoxCommand);
        pushButtonRun->setObjectName(QString::fromUtf8("pushButtonRun"));
        pushButtonRun->setGeometry(QRect(290, 70, 100, 28));
        pushButtonRun->setFocusPolicy(Qt::WheelFocus);
        textEditCommands = new QTextEdit(groupBoxCommand);
        textEditCommands->setObjectName(QString::fromUtf8("textEditCommands"));
        textEditCommands->setGeometry(QRect(0, 70, 280, 60));
        textEditCommands->setReadOnly(true);
        pushButtonExit = new QPushButton(groupBoxCommand);
        pushButtonExit->setObjectName(QString::fromUtf8("pushButtonExit"));
        pushButtonExit->setGeometry(QRect(290, 140, 100, 28));
        pushButtonExit->setFocusPolicy(Qt::WheelFocus);
        lineEditCommand = new QLineEdit(groupBoxCommand);
        lineEditCommand->setObjectName(QString::fromUtf8("lineEditCommand"));
        lineEditCommand->setGeometry(QRect(0, 140, 280, 28));
        line = new QFrame(centralWidget);
        line->setObjectName(QString::fromUtf8("line"));
        line->setGeometry(QRect(5, 340, 390, 20));
        line->setFrameShape(QFrame::HLine);
        line->setFrameShadow(QFrame::Sunken);
        MainWindow->setCentralWidget(centralWidget);
        menuBar = new QMenuBar(MainWindow);
        menuBar->setObjectName(QString::fromUtf8("menuBar"));
        menuBar->setGeometry(QRect(0, 0, 400, 25));
        MainWindow->setMenuBar(menuBar);
        mainToolBar = new QToolBar(MainWindow);
        mainToolBar->setObjectName(QString::fromUtf8("mainToolBar"));
        MainWindow->addToolBar(Qt::TopToolBarArea, mainToolBar);
        statusBar = new QStatusBar(MainWindow);
        statusBar->setObjectName(QString::fromUtf8("statusBar"));
        MainWindow->setStatusBar(statusBar);

        retranslateUi(MainWindow);

        QMetaObject::connectSlotsByName(MainWindow);
    } // setupUi

    void retranslateUi(QMainWindow *MainWindow)
    {
        MainWindow->setWindowTitle(QApplication::translate("MainWindow", "\320\243\320\277\321\200\320\260\320\262\320\273\320\265\320\275\320\270\320\265 \321\202\321\200\320\265\320\275\320\260\320\266\321\221\321\200\320\276\320\274", 0, QApplication::UnicodeUTF8));
        groupBoxAbsolutePath->setTitle(QApplication::translate("MainWindow", "\320\244\320\260\320\271\320\273 \320\264\320\273\321\217 \321\203\321\201\321\202\321\200\320\276\320\271\321\201\321\202\320\262\320\260 \321\203\320\277\321\200\320\260\320\262\320\273\320\265\320\275\320\270\321\217", 0, QApplication::UnicodeUTF8));
        radioButtonSelectDir->setText(QApplication::translate("MainWindow", "\320\243\320\272\320\260\320\267\320\260\321\202\321\214 \320\264\320\270\321\200\320\265\320\272\321\202\320\276\321\200\320\270\321\216 \321\201 \321\204\320\260\320\271\320\273\320\260\320\274\320\270", 0, QApplication::UnicodeUTF8));
        radioButtonSelectFile->setText(QApplication::translate("MainWindow", "\320\243\320\272\320\260\320\267\320\260\321\202\321\214 \321\204\320\260\320\271\320\273", 0, QApplication::UnicodeUTF8));
        pushButtonAbsolutePath->setText(QApplication::translate("MainWindow", "\320\237\321\203\321\202\321\214...", 0, QApplication::UnicodeUTF8));
        pushButtonFindFile->setText(QApplication::translate("MainWindow", "\320\235\320\260\320\271\321\202\320\270...", 0, QApplication::UnicodeUTF8));
        pushButtonAddPrefixFile->setText(QApplication::translate("MainWindow", "\320\225\321\211\321\221...", 0, QApplication::UnicodeUTF8));
        label->setText(QApplication::translate("MainWindow", "\320\237\321\200\320\265\321\204\320\270\320\272\321\201(\321\213) \320\264\320\273\321\217 \321\204\320\276\321\200\320\274\320\270\321\200\320\276\320\262\320\260\320\275\320\270\321\217 \320\270\320\274\320\265\320\275\320\270 \321\204\320\260\320\271\320\273\320\260", 0, QApplication::UnicodeUTF8));
        labelFile->setText(QApplication::translate("MainWindow", "\320\244\320\260\320\271\320\273 \320\275\320\265 \320\264\320\276\321\201\321\202\321\203\320\277\320\265\320\275 \320\264\320\273\321\217 \320\267\320\260\320\277\320\270\321\201\320\270...", 0, QApplication::UnicodeUTF8));
        radioButtoUSB->setText(QApplication::translate("MainWindow", "\320\243\320\272\320\260\320\267\320\260\321\202\321\214 \321\203\321\201\321\202\321\200\320\276\320\271\321\201\321\202\320\262\320\276 USB", 0, QApplication::UnicodeUTF8));
        labelNumberUSB->setText(QApplication::translate("MainWindow", "\320\235\320\276\320\274\320\265\321\200 \321\203\321\201\321\202\321\200\320\276\320\271\321\201\321\202\320\262\320\260:", 0, QApplication::UnicodeUTF8));
        labelNumberDeviceDesc->setText(QApplication::translate("MainWindow", "\320\232\320\273\320\260\321\201\321\201 \321\203\321\201\321\202\321\200\320\276\320\271\321\201\321\202\320\262\320\260:", 0, QApplication::UnicodeUTF8));
        labelVendorIDDesc->setText(QApplication::translate("MainWindow", "VendorID:", 0, QApplication::UnicodeUTF8));
        labelProductIDDesc->setText(QApplication::translate("MainWindow", "ProductID:", 0, QApplication::UnicodeUTF8));
        labelNumberInterfaceDesc->setText(QApplication::translate("MainWindow", "\320\235\320\276\320\274\320\265\321\200 \320\270\320\275\321\202\320\265\321\200\321\204\320\265\320\271\321\201\320\260:", 0, QApplication::UnicodeUTF8));
        labelNumberEPDesc->setText(QApplication::translate("MainWindow", "\320\235\320\276\320\274\320\265\321\200 EP:", 0, QApplication::UnicodeUTF8));
        labelAdresEPDesc->setText(QApplication::translate("MainWindow", "\320\220\320\264\321\200\320\265\321\201 EP:", 0, QApplication::UnicodeUTF8));
        labelTypeEPDesc->setText(QApplication::translate("MainWindow", "\320\242\320\270\320\277 EP:", 0, QApplication::UnicodeUTF8));
        labelProductID->setText(QString());
        labelVendorID->setText(QString());
        labelClassDevice->setText(QString());
        labelTypeEP->setText(QString());
        labelAdresEP->setText(QString());
        labelNumberSetinngsDesc->setText(QApplication::translate("MainWindow", "\320\235\320\276\320\274\320\265\321\200 \320\275\320\260\321\201\321\202\321\200\320\276\320\265\320\272:", 0, QApplication::UnicodeUTF8));
        labelNumberBus->setText(QString());
        labelNumberBusDesc->setText(QApplication::translate("MainWindow", "\320\235\320\276\320\274\320\265\321\200 \321\210\320\270\320\275\321\213:", 0, QApplication::UnicodeUTF8));
        groupBoxCommand->setTitle(QApplication::translate("MainWindow", "\320\222\321\213\320\277\320\276\320\273\320\265\320\275\320\270\320\265 \320\272\320\276\320\274\320\260\320\275\320\264\321\213", 0, QApplication::UnicodeUTF8));
        pushButtonRun->setText(QApplication::translate("MainWindow", "\320\222\321\213\320\277\320\276\320\273\320\275\320\270\321\202\321\214", 0, QApplication::UnicodeUTF8));
        pushButtonExit->setText(QApplication::translate("MainWindow", "\320\222\321\213\321\205\320\276\320\264", 0, QApplication::UnicodeUTF8));
    } // retranslateUi

};

namespace Ui {
    class MainWindow: public Ui_MainWindow {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_MAINWINDOW_H
