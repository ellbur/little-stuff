
#ifndef _drawings_hpp
#define _drawings_hpp 1

#include <libeye/libeye.hpp>
#include "masks.hpp"

void center_square(libeye::BiView &view, double depth, double edge);
void tile(libeye::BiView &view, double depth, const char **tiles,
	int rows, int cols);
void draw_shape_mask(libeye::BiView &view, double depth, ShapeMask &mask);
void tee(libeye::BiView &view, double depth);

#endif /* defined _drawings_hpp */
