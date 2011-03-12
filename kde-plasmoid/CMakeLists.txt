
project(foo-plasmoid)

find_package(KDE4 REQUIRED)

include(KDE4Defaults)

add_definitions(
	${QT_DEFINITIONS}
	${KDE4_DEFINITIONS}
)

include_directories(
	${CMAKE_SOURCE_DIR}
	${CMAKE_BINARY_DIR}
	${KDE4_INCLUDES}
)

set(foo_SRCS src/Foo.cpp)

kde4_add_plugin(plasma_applet_foo ${foo_SRCS})
target_link_libraries(plasma_applet_foo
	${KDE4_PLASMA_LIBS}
	${KDE4_KIO_LIBS}
	${KDE4_KPARTS_LIBS}
	${KDE4_KDECORE_LIBS}
	${KDE4_KDEUI_LIBS}
)

install(TARGETS      plasma_applet_foo
        DESTINATION  ${PLUGIN_INSTALL_DIR})

install(FILES        plasma-applet-foo.desktop
        DESTINATION  ${SERVICES_INSTALL_DIR})
