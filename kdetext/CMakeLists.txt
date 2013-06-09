
project (kdetext)
 
find_package(KDE4 REQUIRED)
find_package(Qt4 REQUIRED)
include_directories(${KDE4_INCLUDES})
 
set(kdetext_SRCS
    TextPane.cpp
    MainWindow.cpp
    Main.cpp
)
 
kde4_add_executable(kdetext ${kdetext_SRCS})
target_link_libraries(kdetext ${KDE4_KDEUI_LIBS})

