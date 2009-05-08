
#include <drawings.hpp>

#include <cstdlib>
#include <cstring>

using namespace libeye;

void center_square(BiView &view, double depth, double edge)
{
	point3 o(0, 0, depth);
	
	point3 e1(edge/2, 0, 0);
	point3 e2(0, edge/2, 0);
	
	point3 a = o - e1 - e2;
	point3 b = o + e1 - e2;
	point3 c = o + e1 + e2;
	point3 d = o - e1 + e2;
	
	view.draw_triangle(a, b, c);
	view.draw_triangle(a, d, c);
}

void tile(BiView &view, double depth, const char **tiles,
	int rows, int cols)
{
	int i, j;
	
	double width  = 2 * view.half_width(depth);
	double height = 2 * view.half_height(depth);
	
	double tile_width  = width  / cols;
	double tile_height = height / rows;
	
	point3 corner(-width/2, height/2, depth);
	point3 e1(tile_width, 0, 0);
	point3 e2(0, -tile_height, 0);
	
	for (i=0; i<rows; i++)
	for (j=0; j<cols; j++) {
		if (tiles[i][j] == ' ') continue;
		
		view.draw_pgram(corner + i*e2 + j*e1, e1, e2);
	}
}

void tee(BiView &view, double depth)
{
	const char *tiles[10] = {
		"               ",
		" xxxxxxxxxxxxx ",
		" xxxxxxxxxxxxx ",
		"      xx       ",
		"      xx       ",
		"      xx       ",
		"      xx       ",
		"      xx       ",
		"      xx       ",
		"               ",
	};
	
	tile(view, depth, tiles, 10, strlen(tiles[0]));
}
