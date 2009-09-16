
#include <stdio.h>
#include <math.h>
#include <string.h>

int main() {
	int i;
	
	for (i=0; i<10000; i++) {
		putchar('0');
	}
	
	fflush(stdout);
	
	return 0;
}
