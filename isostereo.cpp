
#include <libeye/libeye.hpp>

#include <Magick++.h>

#include <iostream>
#include <string>
#include <ctime>
#include <cstdlib>

#include "drawings.hpp"

using namespace std;
using namespace libeye;
using namespace Magick;

// -------------------------------------

int main(int argc, char **argv);
BiView make_view();
void draw_depth(BiView &view);
void write_sird(const BiView &view, const string &filename);

// -------------------------------------

int main(int argc, char **argv) {
	
	srand(time(0));
	
	BiView view = make_view();
	
	draw_depth(view);
	
	write_sird(view, "/tmp/sird.png" );
	
	return 0;
}

BiView make_view() {
	return BiView(600, 600, 30, 7, 40.0);
}

void draw_depth(BiView &view) {
	
	view.flatten(20);
	
	tee(view, 18);
}

void write_sird(const BiView &view, const string &filename) {
	int x, y;
	int row, col;
	
	StereoBlank stereo(view);
	
	Image image(Geometry(view.width, view.height), "white");
	
	int rows;
	int cols;
	int *grid_cols;
	int vgap;
	
	stereo.isometric_grid(rows, cols, grid_cols, vgap, 2);
	
	image.fillColor("black");
	image.strokeColor("green");
	
	for (row=0; row<rows; row++)
	for (col=0; col<cols; col++) {
		x = grid_cols[col + row*cols];
		y = row * vgap;
		
		image.draw(DrawableArc(x-3, y-3, x+3, y+3, 0, 360));
	}
	
	for (row=0; row<rows-1; row++){
		int shift = (row%2==0 ? -1 : 1);
		int maxcol = (shift < 0 ? cols : cols-shift);
		int startcol = (shift > 0 ? 0 : -shift);
		
		for (col=startcol; col<maxcol; col++) {
			x = grid_cols[col + row*cols];
			y = row * vgap;
			
			int x2 = grid_cols[col + (row+1)*cols];
			int x3 = grid_cols[col + shift + (row+1)*cols];
			int y2 = (row+1)*vgap;
			
			image.draw(DrawableLine(x, y, x2, y2));
			image.draw(DrawableLine(x, y, x3, y2));
		}
	}
	
	for (row=0; row<rows-2; row++)
	for (col=0; col<cols; col++) {
		x = grid_cols[col + row*cols];
		y = row * vgap;
		
		int x2 = grid_cols[col + (row+2)*cols];
		int y2 = (row+2)*vgap;
		
		image.draw(DrawableLine(x, y, x2, y2));
	}
	
	delete[] grid_cols;
	
	image.write(filename);
}

