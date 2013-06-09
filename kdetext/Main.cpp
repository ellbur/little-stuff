
#include <KApplication>
#include <KAboutData>
#include <KCmdLineArgs>
#include <KLocale>

#include "MainWindow.hpp"
;

int main(int argc, char **argv)
{   
    KAboutData aboutData(
        "kdetext", 0,
        ki18n("KDE Text"), "0.0",
        ki18n("Not much"),
        KAboutData::License_GPL,
        ki18n("eh")
    );
    KCmdLineArgs::init(argc, argv, &aboutData);
    KApplication app;

    MainWindow* window = new MainWindow();
    window->show();

    return app.exec();
}

