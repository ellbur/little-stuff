
#include <libeye/libeye.hpp>

#include <Magick++.h>

#include <iostream>
#include <string>
#include <ctime>
#include <cstdlib>

#include "drawings.hpp"
#include "masks.hpp"

using namespace std;
using namespace libeye;
using namespace Magick;

// -------------------------------------

int main(int argc, char **argv);

BiView make_view();
void draw_depth(BiView &view);

PixelPacket rand_color();

void write_sird(
	const BiView &view,
	ShapeMask &shape,
	const string &filename);
void draw_dot(Image &image,
	StereoBlank &stereo,
	int x, int y,
	PixelPacket color, int rad);

// -------------------------------------

int main(int argc, char **argv) {
	
	srand(time(0));
	
	BiView view = make_view();
	draw_depth(view);
	
	ShapeMask shape("/tmp/mask.png");
	write_sird(view, shape, "/tmp/sird.png" );
	
	return 0;
}

BiView make_view() {
	return BiView(1200, 960, 30, 7, 40.0);
}

void draw_depth(BiView &view) {
	
	ShapeMask mask("/tmp/shape.png");
	
	view.flatten(20);
	draw_shape_mask(view, 18, mask);
}

// -------------------------------------

void write_sird(
	const BiView &view,
	ShapeMask &shape,
	const string &filename)
{
	int    num_shapes   =  60;
	double dot_density  =    0.01;
	int    max_dot_rad  =    8;
	
	ShapeMask *scaled_shape;
	int i, j;
	double scale;
	int shape_width, shape_height;
	int num_dots;
	int offset_x, offset_y;
	int dot_x, dot_y;
	PixelPacket color = { 0xffff, 0xffff, 0xffff, 0xffff };
	int rad;
	
	StereoBlank stereo(view);
	
	Image image(Geometry(view.width, view.height), "white");
	
	for (i=0; i<num_shapes; i++) {
		
		cout << "shape " << i << endl;
		
		scale = (double) rand() / RAND_MAX;
		
		shape_width  = (int) (shape.width  * scale) + 1;
		shape_height = (int) (shape.height * scale) + 1;
		
		offset_x = rand() % (view.width  + shape_width)  - shape_width;
		offset_y = rand() % (view.height + shape_height) - shape_height;
		
		color = rand_color();
		
		scaled_shape = new ShapeMask(shape);
		scaled_shape->resize(shape_width, shape_height);
		
		num_dots = (int) (shape_width * shape_height
			* dot_density);
		
		for (j=0; j<num_dots; j++) {
			
			dot_x = rand() % shape_width;
			dot_y = rand() % shape_height;
			
			if (! scaled_shape->in_shape(dot_x, dot_y))
				continue;
			
			rad = rand()%max_dot_rad + 1;
			
			draw_dot(image, stereo,
				dot_x + offset_x, dot_y + offset_y,
				color, rad
			);
		}
		
		delete scaled_shape;
	}
	
	image.write(filename);
}

void draw_dot(Image &image,
	StereoBlank &stereo,
	int x, int y,
	PixelPacket color, int rad)
{
	int x_init, y_init;
	
	x_init = x;
	y_init = y;
	
	image.fillColor(color);
	image.strokeColor(color);
	
	while (x >= 0 && x < stereo.width && y >=0 && y < stereo.height) {
		image.draw(DrawableArc(x-rad, y-rad, x+rad, y+rad, 0, 360));
		x = stereo.get_right(x, y);
	}
	
	x = stereo.get_left(x_init, y_init);
	y = y_init;
	
	while (x >= 0 && x < stereo.width && y >=0 && y < stereo.height) {
		image.draw(DrawableArc(x-rad, y-rad, x+rad, y+rad, 0, 360));
		x = stereo.get_left(x, y);
	}
}

// -------------------------------------

PixelPacket rand_color() {
	PixelPacket color;
	
	color.red   = rand() & 0xFFFF;
	color.green = rand() & 0xFFFF;
	color.blue  = rand() & 0xFFFF;
	
	return color;
}
