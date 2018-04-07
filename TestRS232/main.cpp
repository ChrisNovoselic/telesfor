#include <QtGui/QApplication>
#include "mainwindow.h"

int main (int argc, char *argv []) {
    QApplication a (argc, argv);

    MainWindow w;

    int idCmd = -1;
    FILE *fPort = 0x0;

    idCmd = readCommandLine (argc, argv);
    if (idCmd > 0) {
        if (idCmd == ARGV_GUI) {
//            QLineEdit *ptrLineEditAbsolutePath = (QLineEdit *) w.getChild ("groupBoxAbsolutePath", "lineEditAbsolutePath");
//            ptrLineEditAbsolutePath->setText (QDir::currentPath ());

            w.fill_control_usb_value ();

            w.show();
        }
        else {
//            fPort = fNotEmpty ("tty", "S");
//            fPort = fNotEmpty ("usb", "mon");
//            fPort = fNotEmpty ("tty", "");

            switch (idCmd) {
                case ARGV_CMD_START:
                    break;
                case ARGV_CMD_STOP:
                    break;
                default:
                    ;
            }
        }
    }
    else {
        //Ничего НЕ дЕЛатЬ
    }

    int fd;
    //"/sys/bus/usb/devices/"
    char fname [] = "/dev/ttyS31";

    unsigned short lbuffer = 19;
    size_t lread = -1;
    char buffer [lbuffer];

    if (w.isHidden ())
        a.exit ();
    else
        a.exec();
}
