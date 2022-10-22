#include "mainwindow.h"
#include <QApplication>
#include "mainwindow.h"
#include <QApplication>
#include <QTextStream>
#include <QFile>
int main(int argc, char* argv[])
{
  
    QApplication a(argc, argv);
    QFile f("://qdarkstyle/style.qss");
   
    if (!f.exists())
    {
        printf("Unable to set stylesheet, file not found\n");
    }
    else
    {
        f.open(QFile::ReadOnly | QFile::Text);
        QTextStream ts(&f);
        qApp->setStyleSheet(ts.readAll());
    }    
    MainWindow w;
    w.setFixedWidth(640);
    w.show();
    return a.exec();
}
