
#include <stdio.h>
#include <math.h>

int main() {
	int i;
	double c;
	
	for (i=0; i<4096; i++) {
		c = 10000 * exp(-(i-2000.0)*(i-2000.0)/2.0/200.0);
		
		printf("%f,\n", c);
	}
	
	return 0;
}
