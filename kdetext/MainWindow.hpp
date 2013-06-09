
;
#ifndef _main_window_hpp
#define _main_window_hpp 1
;

#include <QtGui/QWidget>
#include <kxmlguiwindow.h>
#include "TextPane.hpp"
;

class MainWindow : public KXmlGuiWindow
{
public:
    MainWindow();
    virtual ~MainWindow();
    
private:
    TextPane *textPane;
}

;
#endif
;

