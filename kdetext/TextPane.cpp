
#include "TextPane.hpp"
;

TextPane::TextPane(QWidget *parent) :
    QWidget(parent)
{
}

TextPane::~TextPane() {
}

void TextPane::paintEvent(QPaintEvent *ev) {
    QPainter paint(this);
    
    paint.setBrush(QBrush(QColor(255, 255, 255)));
    paint.drawRect(0, 0, width(), height());
    
    paint.setFont(QFont("Monospace", 14));
    paint.setPen(QColor(0, 0, 0));
    
    //QTextLayout layout("Hello");
    //layout.draw(&paint, QPoint(10, 100));
    paint.drawText(QPoint(10, 100), "The Quick Brown Fox Jumps Over the lazy dog.");
}

