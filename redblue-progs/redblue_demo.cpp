
/* fltk stuff */
#include <FL/Fl.H>

#include <FL/Fl_Double_Window.H>
#include <FL/Fl_Widget.H>
#include <FL/fl_draw.H>

#include <sys/types.h>

#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#include <libredblue/redblue.h>

using namespace std;

void draw(void);
void draw_message(void);
void draw_branch(
	int level,
	double x,
	double y,
	double z,
	double angle1,
	double angle2 );
void draw_tree_leaves(
	double x, double y, double z);
void draw_flower(
	double x,
	double y,
	double z);
void draw_leaf(
	double x, double y, double z);
void draw_leaves(void);

/* shorthand for random numbers */
inline int r(int a) {
	return (rand()>>8)%a;
}

inline double rb(double a) {
	return a * (
		r(1000) +
		r(1000) +
		r(1000) +
		r(1000) +
		r(1000)
	) / 5000.0;
}

#define MESSAGE_WIDTH 102
#define MESSAGE_HEIGHT  7

const char message[MESSAGE_HEIGHT][MESSAGE_WIDTH+1] = {
	"    XXXX    XXXXXXXXX  XXXXXXX  XXXXXX   XXXXXXX    XXXXX      XXXXX    XXXXXX       X      XXX    XXX",
	"   X    X       X      X        X     X  X         X     X    X     X   X     X     X X     X  X  X  X",
	"   X            X      X        X     X  X        X       X  X          X     X    X   X    X   XX   X",
	"    XXX         X      XXXXXX   X XXXX   XXXXXX   X       X  X    XXXX  X XXXX    X     X   X        X",
	"       X        X      X        X XX     X        X       X  X       X  X XX      XXXXXXX   X        X",
	"  X    X        X      X        X   XX   X         X     X    X     XX  X   XX   X       X  X        X",
	"   XXXX         X      XXXXXXX  X     X  XXXXXXX    XXXXX      XXXXX    X     X  X       X  X        X",
};

/* width and height of center rectangle */
const int W = 800, H = 600;

const double PI = 3.141592653589793238;

/* the buffer hold the image as a one-dimensional array.
   Each row in the image is represented by consecutive
   segments in the array. Each pixel has three bytes, RGB */
const int BUFFER_LENGTH = W*H * 3;
unsigned char buffer[W*H*3];

/* an Fl_Widget that can draw to the rectangle it
   is provided. Will draw the image to the screen */
class Pane : public Fl_Widget {

  public:

	Pane(int x, int y, int w, int h);

	virtual void draw();

};

/* constructor - nothing to construct */
Pane::Pane(int x, int y, int w, int h)
		 : Fl_Widget(x,y,w,h) { }

void Pane::draw() {

	/* draw image to screen */
	fl_draw_image(buffer, x(), y(), W, H);

}

redblue_canvas *canvas;

/*
 * Draw the pretty picture
 *
 */
void draw(void) {
	int i;
	
	const double eye1X = -0.047;
	const double eye1Y =  0.0;
	const double eye1Z = -1.378;
	const double eye2X =  0.047;
	const double eye2Y =  0.0;
	const double eye2Z = -1.378;
	
	redblue_canvas_init(&canvas, buffer, W, H);
	redblue_set_eye1(canvas, eye1X, eye1Y, eye1Z);
	redblue_set_eye2(canvas, eye2X, eye2Y, eye2Z);
	redblue_set_screen(canvas,
		2.0/W, 0, 0,
		0, -2.0/W, 0,
		-1, 1, 0);
	
	redblue_clear(canvas, REDBLUE_WHITE);
	
	draw_message();
	
	for (i=0; i<500; i++) {
		double x, y, z;
		
		x = 2 * r(100)/10.0 - 2 * r(100)/10.0;
		y = -1.5;
		z = 3.5 + 2 * r(100)/10.0 - r(100)/10.0;
		
		draw_flower(x, y, z);
	}
		
	draw_branch(7, 0, -1.5, 3.5, 0, PI/2);
	draw_branch(5, -5.0, -1.5, 13.0, 0, PI/2);
	draw_branch(4, 2.0, -1.5, 10.0, 0, PI/2);
	
	draw_leaves();
}

void draw_message(void) {
	int row, col;
	
	double edge = 0.3;
	
	for (row=0; row<MESSAGE_HEIGHT; row++) {
	for (col=0; col<MESSAGE_WIDTH; col++) {
		double x, y, z;
		
		if (message[MESSAGE_HEIGHT-row-1][col] != 'X') continue;
		
		x = -15.0 + col * edge * 0.9;
		y = -1.5 + row * edge;
		z = 20.0;
		
		x += rb(0.1);
		z += rb(0.1);
		
		redblue_draw_line(
			canvas, REDBLUE_BLACK,
			x+edge/2, y-edge/2, z-edge/2, 
			x-edge/2, y-edge/2, z-edge/2);
		redblue_draw_line(
			canvas, REDBLUE_BLACK,
			x+edge/2, y+edge/2, z-edge/2, 
			x-edge/2, y+edge/2, z-edge/2);
		redblue_draw_line(
			canvas, REDBLUE_BLACK,
			x-edge/2, y+edge/2, z-edge/2, 
			x-edge/2, y-edge/2, z-edge/2);
		redblue_draw_line(
			canvas, REDBLUE_BLACK,
			x+edge/2, y+edge/2, z-edge/2, 
			x+edge/2, y-edge/2, z-edge/2);
		redblue_draw_line(
			canvas, REDBLUE_BLACK,
			x+edge/2, y-edge/2, z+edge/2, 
			x-edge/2, y-edge/2, z+edge/2);
		redblue_draw_line(
			canvas, REDBLUE_BLACK,
			x+edge/2, y+edge/2, z+edge/2, 
			x-edge/2, y+edge/2, z+edge/2);
		redblue_draw_line(
			canvas, REDBLUE_BLACK,
			x-edge/2, y+edge/2, z+edge/2, 
			x-edge/2, y-edge/2, z+edge/2);
		redblue_draw_line(
			canvas, REDBLUE_BLACK,
			x+edge/2, y+edge/2, z+edge/2, 
			x+edge/2, y-edge/2, z+edge/2);
		redblue_draw_line(
			canvas, REDBLUE_BLACK,
			x+edge/2, y+edge/2, z+edge/2, 
			x+edge/2, y+edge/2, z-edge/2);
		redblue_draw_line(
			canvas, REDBLUE_BLACK,
			x+edge/2, y-edge/2, z+edge/2, 
			x+edge/2, y-edge/2, z-edge/2);
		redblue_draw_line(
			canvas, REDBLUE_BLACK,
			x-edge/2, y+edge/2, z+edge/2, 
			x-edge/2, y+edge/2, z-edge/2);
		redblue_draw_line(
			canvas, REDBLUE_BLACK,
			x-edge/2, y-edge/2, z+edge/2, 
			x-edge/2, y-edge/2, z-edge/2);
	}
	}
}

void draw_branch(
	int level,
	double x,
	double y,
	double z,
	double angle1,
	double angle2 )
{
	if (level <= 0) {
		return;
	}
	
	double x2, y2, z2;
	double length;
	
	int i;
	
	length = .30 * level;
	
	z2 = z + length * sin(angle1);
	x2 = x + length * cos(angle1) * cos(angle2);
	y2 = y + length * cos(angle1) * sin(angle2);
	
	for (i=0; i<20 * level * level; i++) {
		double t;
		double x3, y3, z3;
		
		t = r(1000) / 1000.0;
		
		x3 = x*t + x2*(1-t) + r(10)/1000.0 - r(10)/1000.0;
		y3 = y*t + y2*(1-t) + r(10)/1000.0 - r(10)/1000.0;
		z3 = z*t + z2*(1-t) + r(10)/1000.0 - r(10)/1000.0;
		
		redblue_draw_point(
			canvas, REDBLUE_BLACK,
			x3, y3, z3 );
	}
	
	draw_branch(
		level-1,
		x2, y2, z2,
		angle1 - 0.6,
		angle2 + 0.4);
	
	draw_branch(
		level-1,
		x2, y2, z2,
		angle1 - 0.6,
		angle2 - 0.3);
	
	draw_branch(
		level-2,
		x2, y2, z2,
		angle1 + 0.6,
		angle2 + 0.5 );
	
	draw_branch(
		level-1,
		x2, y2, z2,
		angle1 + 0.7,
		angle2 - 0.6 );
}

void draw_flower(
	double x,
	double y,
	double z)
{
	double x2, y2, z2;
	double angle1, angle2;
	double length;
	int i, j;
	
	if (z < 0) return;
	
	angle1 = r(10)/100.0 - r(10)/100.0;
	angle2 = PI/2.0 + r(10)/100.0 - r(10)/100.0;
	
	length = 0.3 + r(10)/50.0 - r(10)/100.0;
	
	x2 = x + 0.3 * cos(angle1) * cos(angle2);
	y2 = y + 0.3 * cos(angle1) * sin(angle2);
	z2 = z + 0.3 * sin(angle1);
	
	for (i=0; i<40; i++) {
		double t;
		double x3, y3, z3;
		
		t = r(1000) / 1000.0;
		
		x3 = x*t + x2*(1-t);
		y3 = y*t + y2*(1-t);
		z3 = z*t + z2*(1-t);
		
		redblue_draw_point(
			canvas, REDBLUE_BLACK,
			x3, y3, z3 );
	}
	
	for (i=0; i<6; i++) {
		double angle;
		double x3, y3, z3;
		
		double phase1, phase2;
		
		phase1 = r(10)/100.0 - r(10)/100.0;
		phase2 = r(10)/100.0 - r(10)/100.0;
		
		angle = i * 2 * PI / 6;
		
		x3 = x2 + 0.1 * cos(angle + phase1) * cos(phase2);
		y3 = y2 + 0.1 * cos(angle + phase1) * sin(phase2);
		z3 = z2 + 0.1 * sin(angle + phase1);
		
		for (j=0; j<20; j++) {
			double t;
			double x4, y4, z4;
		
			t = r(1000) / 1000.0;
		
			x4 = x2*t + x3*(1-t);
			y4 = y2*t + y3*(1-t);
			z4 = z2*t + z3*(1-t);
		
			redblue_draw_point(
				canvas, REDBLUE_BLACK,
				x4, y4, z4 );
		}
	}
}

void draw_leaf(
	double x, double y, double z)
{
	int i;

	for (i=0; i<20; i++) {
		double angle;
		double radius;
		
		double x2, y2, z2;
		
		angle = 2*PI*r(1000)/1000.0;
		radius = 0.02 + rb(0.03);
		
		x2 = x + radius * cos(angle);
		y2 = y;
		z2 = z + radius * sin(angle);
		
		redblue_draw_point(
			canvas, REDBLUE_BLACK,
			x2, y2, z2);
	}
}

void draw_leaves(void) {
	int i;
	
	for (i=0; i<300; i++) {
		double angle;
		double radius;
		
		double x, y, z;
		
		angle = 2*PI*r(1000)/1000.0;
		radius = 0.7 + rb(3.0);
		
		x = radius * cos(angle);
		y = -1.5;
		z = 3.5 + radius * sin(angle);
		
		draw_leaf(x, y, z);
	}
}

int main(int argc, char **argv) {

	srand(time(0));

	Fl_Window window(W+30, H+30);

	  /* create the display rectangle */
	  Pane pane(10, 10, W, H);
	  pane.show();

	/* done adding components to the window */
	window.end();

	window.show();

	/* pointer to the widget that must be redrawn */
    Pane *pane_p = &pane;
	
	draw();
	
	pane.redraw();
	
	// and begin !!

	/* returns control to the event loop */
	return Fl::run();

}
