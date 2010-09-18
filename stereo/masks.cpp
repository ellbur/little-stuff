
#include "masks.hpp"

#include <Magick++.h>
#include <cstdlib>
#include <cstring>

using namespace std;
using namespace Magick;

bool *shape;

int width;
int height;

ShapeMask::ShapeMask(int _width, int _height)
{
	this->width  = _width;
	this->height = _height;
	
	shape = new bool[ width * height ];
}

ShapeMask::ShapeMask(const ShapeMask &to_copy)
{
	this->width  = to_copy.width;
	this->height = to_copy.height;
	
	shape = new bool[ width * height ];
	
	memcpy(shape, to_copy.shape, width*height*sizeof(shape[0]));
}

ShapeMask::ShapeMask(const std::string &filename)
{
	Image image(filename);
	int x, y;
	const PixelPacket *pixels;
	int test;
	
	this->width  = image.columns();
	this->height = image.rows();
	this->shape  = new bool[width * height];
	
	pixels = image.getConstPixels(0, 0, width, height);
	
	for (x=0; x<width; x++)
	for (y=0; y<height; y++)
	{
		test = pixels[x + y*width].green;
		
		if (test > 100) shape[x + y*width] = true;
		else            shape[x + y*width] = false;
	}
}

ShapeMask::~ShapeMask()
{
	delete[] shape;
}

bool ShapeMask::in_shape(int x, int y)
{
	return get(x, y);
}

bool ShapeMask::get(int x, int y)
{
	if (x < 0 || x >= width)  return false;
	if (y < 0 || y >= height) return false;
	
	return shape[x + y*width];
}

void ShapeMask::set(int x, int y, bool in)
{
	if (x < 0 || x >= width)  return;
	if (y < 0 || y >= height) return;
	
	shape[x + y*width] = in;
}

double ShapeMask::density()
{
	int sum = 0;
	int i;
	
	for (i=0; i<width*height; i++) {
		if (shape[i]) sum++;
	}
	
	return (double) sum / width / height;
}

void ShapeMask::resize(int new_width, int new_height)
{
	int x, y;
	int scale_x, scale_y;
	
	bool *new_shape = new bool[new_width * new_height];
	
	for (x=0; x<new_width; x++)
	for (y=0; y<new_height; y++)
	{
		scale_x = x * width / new_width;
		scale_y = y * height / new_height;
		
		new_shape[x + y*new_width] = shape[
			scale_x + scale_y*width];
	}
	
	delete[] shape;
	
	shape  = new_shape;
	width  = new_width;
	height = new_height;
}

void ShapeMask::save(const std::string &filename)
{
	Image image(Geometry(width, height), "black");
	int x, y;
	PixelPacket *pixels;
	
	pixels = image.getPixels(0, 0, width, height);
	
	for (x=0; x<width; x++)
	for (y=0; y<height; y++)
	{
		if (in_shape(x, y)) {
			pixels[x + y*width] = Color("white");
		}
	}
	
	image.syncPixels();
	image.write(filename);
}
