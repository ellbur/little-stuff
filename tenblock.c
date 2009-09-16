
#include <stdio.h>
#include <time.h>
#include <stdlib.h>

int main() {
	int i, j;
	
	srand(time(0));
	
	for (i=0; i<10; i++) {
		for (j=0; j<10; j++) {
			printf("%d", rand()%10);
		}
		
		printf("\n");
	}
}