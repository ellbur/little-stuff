
#ifndef _text_pane_hpp
#define _text_pane_hpp 1
;

#include <QtGui/QWidget>
#include <QPainter>
#include <QTextLayout>
;

class TextPane : public QWidget
{
    Q_OBJECT;
        
public:
    TextPane(QWidget *parent);
    virtual ~TextPane();
    
private:
    
    virtual void paintEvent(QPaintEvent *ev);
};

;
#endif
;

