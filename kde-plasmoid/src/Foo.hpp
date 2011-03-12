
#ifndef _Foo_hpp
#define _Foo_hpp 1

#include <Plasma/Applet>
#include <Plasma/PopupApplet>
#include <Plasma/IconWidget>
#include <KParts/Part>

#include <QObject>
#include <QLabel>

class Foo : public Plasma::PopupApplet
{
	Q_OBJECT
	
	public:
	
	Foo(QObject *parent, const QVariantList &args);
	~Foo();
	
	void init();
	QWidget* widget();
	
	private:
	
	Plasma::IconWidget *m_icon;
	QWidget *m_main;
	KParts::ReadOnlyPart *m_dolphinPart;
	
	void makeMain();
};

K_EXPORT_PLASMA_APPLET( foo, Foo )

#endif
