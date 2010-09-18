
#include <paintlib/planybmp.h>
#include <paintlib/plpngenc.h>

#include <libeye/libeye.hpp>

#include <iostream>
#include <string>
#include <ctime>
#include <cstdlib>

#include "drawings.hpp"

using namespace std;
using namespace libeye;

// -------------------------------------

int main(int argc, char **argv);
BiView make_view();
void draw_depth(BiView &view);
void write_sird(const BiView &view, const string &filename);
void write_depth(const BiView &view, const string &filename);

// -------------------------------------

int main(int argc, char **argv) {
	
	srand(time(0));
	
	BiView view = make_view();
	
	draw_depth(view);
	
	write_depth(view, "/tmp/depth.png");
	write_sird(view, "/tmp/sird.png" );
	
	return 0;
}

BiView make_view() {
	return BiView(800, 600, 30, 7);
}

void draw_depth(BiView &view) {
	
	view.flatten(20);
	
	tee(view, 18);
}

void write_sird(const BiView &view, const string &filename) {
	PLAnyBmp bmp;
	PLPixel32 **lines;
	int x, y;
	int row, col;
	
	PLPNGEncoder enc;
	
	bmp.Create(view.width, view.height, PLPixelFormat::A8R8G8B8);
	lines = bmp.GetLineArray32();
	
	StereoBlank stereo(view);
	
	for (y=0; y<view.height; y++)
	for (x=0; x<view.width; x++) {
		lines[y][x] = PLPixel32(255, 255, 255);
	}
	
	int rows;
	int cols;
	int *grid_cols;
	int vgap;
	
	stereo.isometric_grid(rows, cols, grid_cols, vgap, 2);
	
	for (row=0; row<rows; row++)
	for (col=0; col<cols; col++) {
		int x = grid_cols[col + row*cols];
		int y = row * vgap;
		
		if (x < 0 || x >= view.width) continue;
		
		lines[y][x] = PLPixel32(0, 0, 0);
	}
	
	delete[] grid_cols;
	
	enc.MakeFileFromBmp(filename.c_str(), &bmp);
}

void write_depth(const BiView &biview, const string &filename) {
	PLAnyBmp bmp;
	PLPixel32 **lines;
	int x, y;
	
	const View &view = biview.right;
	
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
		
		lines[y][x] = PLPixel32(index, index, index);
	}
	
	enc.MakeFileFromBmp(filename.c_str(), &bmp);
}
