
#include <stdio.h>

/*
 * Finds b such that
 * 5ab + b + 5 is a perfect square
 */
int five_search(int a) {
	int i;
	int n;
	
	n = 5*a + 1;
	
	for (i=0; i<n; i++) {
		if ((i*i) % n == 5) {
			return (i*i - 5) / n;
		}
	}
	
	return 0;
}

int main(int argc, char **argv) {
	int a;
	
	for (a=0; a<14; a++) {
		printf("%d %d\n", a, five_search(a));
	}
	
	return 0;
}
