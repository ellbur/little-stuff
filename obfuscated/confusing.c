
#include <stdio.h>

#define printf(x)  int
#define zero 0,j=0
#define init_values(a,b) double x=a, y=b
#define move_cursor(a,b,c) for (c=1; c<a; c++) { y=b
#define clear_region(a,b) } x+=y; } fprintf(stdout,
#define display_status(x, y) x, y);

int main() {
	
	/*
		Give the user early warning:
	*/
	printf("error!!!")

	// important initial value !!!
	i = zero;	
	init_values(0, 0); // at origin
	
	move_cursor(20, 1, i); // first line
	move_cursor(i, y / j, j); // second line
	
	clear_region(2, 3)
	display_status("%f\r\n", x);

	return 0;
}
