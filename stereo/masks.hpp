
#ifndef _masks_hpp
#define _masks_hpp 1

#include <string>

class ShapeMask {
	
	public:
	
	// heap, deallocked in destructor
	bool *shape;
	
	int width;
	int height;
	
	ShapeMask(int _width, int _height);
	ShapeMask(const ShapeMask &to_copy);
	ShapeMask(const std::string &filename);
	~ShapeMask();
	
	// same as get(x, y)
	bool in_shape(int x, int y);
	
	bool get(int x, int y);
	void set(int x, int y, bool in);
	
	// fraction of the space filled
	double density();
	
	// Not a great algorithm, but should work
	// ok for shrinking blobby shapes
	void resize(int new_width, int new_height);
	
	ShapeMask& copy();
	void save(const std::string &filename);
};

#endif /* defined _masks_hpp */
