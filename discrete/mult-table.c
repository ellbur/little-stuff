
#include <stdio.h>

int main(int argc, int **argv) {
	
	int n, i, j;
	
	for (n=1; n<=20; n++) {
		
		printf("   ");
		for (j=0; j<n; j++) {
			printf("%2d ", j);
		}
		printf("\n");
		
		printf("   ");
		for (j=0; j<n; j++) {
			printf("---");
		}
		printf("\n");
		
		for (i=0; i<n; i++) {
			printf("%2d|", i);
			
			for (j=0; j<n; j++) {
				printf("%2d ", (i*j)%n);
			}
			printf("\n");
		}
		
		printf("\n");
	}
	
}
