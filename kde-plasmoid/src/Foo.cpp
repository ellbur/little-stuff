
#include "Foo.hpp"

#include <KIcon>
#include <KDebug>
#include <Plasma/ToolTipManager>
#include <KMimeTypeTrader>

Foo::Foo(QObject *parent, const QVariantList &args) :
	Plasma::PopupApplet(parent, args),
	
	m_icon(NULL),
	m_main(NULL)
{
}

Foo::~Foo()
{
	delete m_icon;
	delete m_main;
}

void Foo::init()
{
	const char *iconName = "folder-yellow";
	
	m_icon = new Plasma::IconWidget(KIcon(iconName, NULL), QString());
	setPopupIcon(m_icon->icon());
	
	Plasma::ToolTipManager::self()->registerWidget(this);
	update();
	
	registerAsDragHandle(m_icon);
	setAspectRatioMode(Plasma::ConstrainedSquare);
}

QWidget* Foo::widget()
{
	if (m_main == NULL)
	{
		makeMain();
	}
	
	return m_main;
}

void Foo::makeMain()
{
	if (m_main)
		return;
	
	// http://forum.kde.org/viewtopic.php?f=43&t=84303
	m_dolphinPart = KMimeTypeTrader::createPartInstanceFromQuery
		<KParts::ReadOnlyPart>
	(
		"inode/directory", // mime
		NULL, this, // parent widget ; parent object
		"exist Library and Library == 'dolphinpart'" // dunno
	);
	m_dolphinPart->openUrl(KUrl("file:///tmp"));
	
	m_main = m_dolphinPart->widget();
}

#include "Foo.moc"
