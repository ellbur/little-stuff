
/* fltk stuff */
#include <FL/Fl.H>

#include <FL/Fl_Double_Window.H>
#include <FL/Fl_Widget.H>
#include <FL/fl_draw.H>

#include <sys/types.h>
#include <pthread.h>

#include <time.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <list>

#include <libredblue/redblue.h>

#undef abs

using namespace std;

inline int min(int a, int b) {
	return (a < b) ? a : b;
}
inline int max(int a, int b) {
	return (a < b) ? b : a;
}

inline double max(double a, double b) {
	return (a < b) ? b : a;
}

inline double abs(double x) {
	return (x < 0 ? -x : x);
}

/* shorthand for random numbers */
inline int r(int a) {
	return rand()%a;
}

inline double rd(double min, double max) {
	return (double)rand() * (max - min) / RAND_MAX + min;
}

/* width and height of center rectangle */
const int W = 800, H = 600;

#define NANOS_TO_MILLIS 1000000

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
	virtual int handle(int event);

};

/* constructor - nothing to construct */
Pane::Pane(int x, int y, int w, int h)
		 : Fl_Widget(x,y,w,h) { }

void Pane::draw() {

	/* draw image to screen */
	fl_draw_image(buffer, x(), y(), W, H);

}

int keyPressed(int key);
int keyReleased(int key);

int Pane::handle(int event) {
	switch (event) {
		case FL_FOCUS:
		case FL_UNFOCUS:
			return 1;
		case FL_KEYDOWN:
			return keyPressed(Fl::event_key());
		case FL_KEYUP:
			return keyReleased(Fl::event_key());
	}
	return 0;
}

// ---------------------------------------------------

const int BULLET_LIFESPAN       = 100;
const double BULLET_SPEED       = 17.0;
const double SHIP_TURN_SPEED    = 0.3;
const double SHIP_ACCELERATION  = 1.0;
const double SHIP_MAX_SPEED     = 12.4;

class Ship {

	public:
	
	double x, y;
	double dx, dy;
	double orientation;
	
	int turning; // sign of angular velocity
	bool isAccelerating;
	bool isShooting;
	bool shooterReleased;

	Ship();
	
	void move();
	void draw();
};

class Bullet {

	public:

	double x, y;
	double dx, dy;
	int age;
	bool isDead;
	
	double depth;
	
	Bullet(double x, double y, double dx, double dy);
	
	void move();
	void draw();
};

// ---------------------------------------------------

redblue_canvas *canvas;
Ship ship;
list<Bullet*> bullets;

// ---------------------------------------------------

Ship::Ship() {
	isShooting = false;
	shooterReleased = true;
	turning = 0;
	dx = 0;
	dy = 0;
}

void Ship::move() {
	if (isShooting) {
		isShooting = false;
		Bullet *bullet = new Bullet(x, y,
			dx + BULLET_SPEED * cos(orientation),
			dy + BULLET_SPEED * sin(orientation) );
		bullets.push_back(bullet);
	}
	orientation += SHIP_TURN_SPEED * turning;
	if (isAccelerating) {
		dx += SHIP_ACCELERATION * cos(orientation);
		dy += SHIP_ACCELERATION * sin(orientation);
		double speed = sqrt(dx*dx + dy*dy);
		if (speed > SHIP_MAX_SPEED) {
			dx *= SHIP_MAX_SPEED / speed;
			dy *= SHIP_MAX_SPEED / speed;
		}
	}
	x += dx;
	y += dy;
	
	if (x < 0)  x += W;
	if (x >= W) x -= W;
	if (y < 0)  y += H;
	if (y >= H) y -= H;
}

void Ship::draw() {
	double c = cos(orientation);
	double s = sin(orientation);
	
	redblue_draw_line(canvas, REDBLUE_BLACK,
		x + c*(70) - s*(0), y + s*(70) + c*(0), 0,
		x + c*(-24) - s*(-24), y + s*(-24) + c*(-24), 0);
	redblue_draw_line(canvas, REDBLUE_BLACK,
		x + c*(70) - s*(0), y + s*(70) + c*(0), 0,
		x + c*(-24) - s*(0), y + s*(-24) + c*(0), 24);
	redblue_draw_line(canvas, REDBLUE_BLACK,
		x + c*(70) - s*(0), y + s*(70) + c*(0), 0,
		x + c*(-24) - s*(0), y + s*(-24) + c*(0), -24);
	redblue_draw_line(canvas, REDBLUE_BLACK,
		x + c*(70) - s*(0), y + s*(70) + c*(0), 0,
		x + c*(-24) - s*(24), y + s*(-24) + c*(24), 0);
	redblue_draw_line(canvas, REDBLUE_BLACK,
		x + c*(-24) - s*(-24), y + s*(-24) + c*(-24), 0,
		x + c*(-24) - s*(0), y + s*(-24) + c*(0), 24);
	redblue_draw_line(canvas, REDBLUE_BLACK,
		x + c*(-24) - s*(-24), y + s*(-24) + c*(-24), 0,
		x + c*(-24) - s*(0), y + s*(-24) + c*(0), -24);
	redblue_draw_line(canvas, REDBLUE_BLACK,
		x + c*(-24) - s*(24), y + s*(-24) + c*(24), 0,
		x + c*(-24) - s*(0), y + s*(-24) + c*(0), 24);
	redblue_draw_line(canvas, REDBLUE_BLACK,
		x + c*(-24) - s*(24), y + s*(-24) + c*(24), 0,
		x + c*(-24) - s*(0), y + s*(-24) + c*(0), -24);

}

// ---------

Bullet::Bullet(double x, double y, double dx, double dy)
{
	this->x = x;
	this->y = y;
	this->dx = dx;
	this->dy = dy;
	depth = rd(-16.0, 16.0);
	age = 0;
	isDead = false;
}

void Bullet::move() {
	x += dx;
	y += dy;
	if (x < 0)  x += W;
	if (x >= W) x -= W;
	if (y < 0)  y += H;
	if (y >= H) y -= H;
	age++;
	if (age >= BULLET_LIFESPAN) {
		isDead = true;
	}
}

void Bullet::draw() {
	redblue_draw_line(canvas, REDBLUE_BLACK,
		x, y, depth,
		x+8, y+8, depth+8);
	redblue_draw_line(canvas, REDBLUE_BLACK,
		x, y, depth,
		x+8, y+8, depth-8);
	redblue_draw_line(canvas, REDBLUE_BLACK,
		x, y, depth,
		x+8, y-8, depth+8);
	redblue_draw_line(canvas, REDBLUE_BLACK,
		x, y, depth,
		x+8, y-8, depth-8);
	redblue_draw_line(canvas, REDBLUE_BLACK,
		x, y, depth,
		x-8, y+8, depth+8);
	redblue_draw_line(canvas, REDBLUE_BLACK,
		x, y, depth,
		x-8, y+8, depth-8);
	redblue_draw_line(canvas, REDBLUE_BLACK,
		x, y, depth,
		x-8, y-8, depth+8);
	redblue_draw_line(canvas, REDBLUE_BLACK,
		x, y, depth,
		x-8, y-8, depth-8);
}

// ---------------------------------------------------

/* called on a separate thread to begin the
   animation. never returns */
void *begin(void *arg) {
	int i;

	/* this is the component that will draw the
	   image */
	Fl_Widget *widget = (Fl_Widget*)arg;

	/* c timespec of form {seconds, nanoseconds}
	   length of pause between frames */
	timespec pause = {
    	0, 20*NANOS_TO_MILLIS
	};
	
	ship.x = W/2;
	ship.y = H/2;
	ship.dx = 0;
	ship.dy = 0;
	ship.orientation = 3.141592/2;
	
	const double eye1X =  W/2.0 - 100;
	const double eye1Y =  H/2.0;
	const double eye1Z =  -1400.0;
	const double eye2X =  W/2.0 + 100;
	const double eye2Y =  H/2.0;
	const double eye2Z =  -1400.0;
	
	redblue_canvas_init(&canvas, buffer, W, H);
	redblue_set_eye1(canvas, eye1X, eye1Y, eye1Z);
	redblue_set_eye2(canvas, eye2X, eye2Y, eye2Z);
	redblue_set_screen(canvas,
		1,  0, 0,  // x-axis
		0,  1, 0,  // y-axis
		0,  0, 30); // origin
	
    for (;;) {

		/* pause */
    	nanosleep(&pause, NULL);
		
		/*
			drawing code
		*/
		
		redblue_clear(canvas, REDBLUE_WHITE);
	
		list<Bullet*>::iterator bulletsIter = bullets.begin();
		list<Bullet*>::iterator bulletsEnd  = bullets.end();
		for (; bulletsIter != bulletsEnd; ) {
			Bullet *bullet = *bulletsIter;
			bullet->move();
			
			if (bullet->isDead) {
				delete bullet;
				bullets.erase(bulletsIter++);
				continue;
			}
			else {
				++bulletsIter;
			}
			
			bullet->draw();
		}
		
		ship.move();
		ship.draw();

		/* lock the necessary mutexes and redraw.
		   locking precents a collision from disrupting
		   the program */

		Fl::lock();
		  widget->redraw();
		Fl::unlock();

		/* unlock and continue */
		Fl::awake(widget);
	}
	
	redblue_canvas_destroy(canvas);
	
	/* will never happen */
	return NULL;

}

int keyPressed(int key) {
	switch (key) {
		case 'a':
			ship.turning = -1;
			return -1;
		case 'd':
			ship.turning = 1;
			return 1;
		case 'v':
			if (ship.shooterReleased)
				ship.isShooting = true;
			ship.shooterReleased = false;
			return 1;
		case 'g':
			ship.isAccelerating = true;
			return 1;
	}
	return 0;
}

int keyReleased(int key) {
	switch (key) {
		case 'a':
			ship.turning = 0;
			return 1;
		case 'd':
			ship.turning = 0;
			return 1;
		case 'v':
			ship.shooterReleased = true;
			return 1;
		case 'g':
			ship.isAccelerating = false;
			return 1;
	}
	return 0;
}

int main(int argc, char **argv) {

	srand(time(0));

	/* for most animations this would be
	   double buffered, but that is unecessary here */
	Fl_Window window(W+30, H+30, "Animation");

	  /* create the display rectangle */
	  Pane pane(10, 10, W, H);
	  pane.show();

	/* done adding components to the window */
	window.end();

	window.show();

	/* lock while threads are created */
	//////////
    Fl::lock();
	//////////

	// Set up timer thread

	pthread_attr_t attr;
	pthread_t th;

	pthread_attr_init(&attr);

	/* pointer to the widget that must be redrawn */
    Pane *pane_p = &pane;

	pthread_create(&th, &attr,
    	begin,
			&pane);

	// and begin !!

	/* returns control to the event loop */
	return Fl::run();

}
