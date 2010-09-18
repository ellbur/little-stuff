
#include "masks.hpp"

int main(int argc, char **argv)
{
	ShapeMask mask("/tmp/mask.png");
	mask.resize(100, 100);
	mask.save("/tmp/mask-small.png");
	
	return 0;
}
