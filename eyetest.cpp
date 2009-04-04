
#include <paintlib/planybmp.h>
#include <paintlib/plpngenc.h>

#include <libeye/libeye.hpp>

#include <iostream>
#include <string>

using namespace std;
using namespace libeye;

// -------------------------------------

int main(int argc, char **argv);
View make_view();
void draw_depth(View &view);
void write_depth(const View &view, const string &filename);

// -------------------------------------

int main(int argc, char **argv) {
	
	View view = make_view();
	
	draw_depth(view);
	write_depth(view, "/tmp/image.png" );
	
	return 0;
}

View make_view() {
	int width  = 800;
	int height = 600;
	
	double screen_width  = 14.0;
	double screen_height = screen_width * height / width;
	
	double scale = screen_width / width;
	
	double eye_back = 30.0;
	double eye_sep  =  7.0;
	
	Screen screen(
		point3(-screen_width/2, -screen_height/2, 0),
		point3(scale, 0, 0),
		point3(0, scale, 0) );
	
	point3 eye1(-eye_sep/2, 0, eye_back);
	point3 eye2(+eye_sep/2, 0, eye_back);
	
	return View(width, height, screen, eye1);
}

void draw_depth(View &view) {
	
	view.flatten(10);
	
	point3 o(-3, -3, 1);
	
	point3 e1(1, 0, 0);
	point3 e2(0, 1, 0);
	point3 e3(0, 0, 1);
	
	point3 l1 = o;
	point3 l2 = o  + 5*e1;
	point3 l3 = o  + 5*e3;
	point3 l4 = l2 + 5*e3;
	
	point3 u1 = l1 + 5*e2;
	point3 u2 = l2 + 5*e2;
	point3 u3 = l3 + 5*e2;
	point3 u4 = l4 + 5*e2;
	
	view.draw_triangle(l1, l2, u1);
	view.draw_triangle(u2, l2, u1);
}

void write_depth(const View &view, const string &filename) {
	PLAnyBmp bmp;
	PLPixel32 **lines;
	int x, y;
	
	PLPNGEncoder enc;
	
	double max_depth = -1.0/0.0;
	double min_depth =  1.0/0.0;
	
	bmp.Create(view.width, view.height, PLPixelFormat::A8R8G8B8);
	lines = bmp.GetLineArray32();
	
	for (x=0; x<view.width; x++)
	for (y=0; y<view.height; y++) {
		double depth;
		
		depth = view.get(x, y);
		
		if (depth < min_depth) min_depth = depth;
		if (depth > max_depth) max_depth = depth;
	}
	
	for (x=0; x<view.width; x++)
	for (y=0; y<view.height; y++) {
		int index;
		double depth;
		
		depth = view.get(x, y);
		
		index = 255 - (int) ( (depth - min_depth)
			/ (max_depth - min_depth) * 254 );
		index &= 0xFF;
		
		lines[view.height - y - 1][x] = PLPixel32(index, index, index);
	}
	
	enc.MakeFileFromBmp(filename.c_str(), &bmp);
}
