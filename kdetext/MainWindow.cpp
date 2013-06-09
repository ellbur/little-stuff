
#include "MainWindow.hpp"
;

MainWindow::MainWindow()
{
    textPane = new TextPane(this);
    
    setCentralWidget(textPane);
    setupGUI();
}

MainWindow::~MainWindow() {
    delete textPane;
}


