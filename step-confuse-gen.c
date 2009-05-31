
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

int main(int argc, char **argv) {
	
	int i;
	
	if (argc-1 != 1) {
		fprintf(stderr, "step-confuse-gen <how-many>\n");
		return 1;
	}
	
	srand(time(0));
	int howmany = atoi(argv[1]);
	
	for (i=0; i<howmany; i++) {
		int start = 10 + rand()%50;
		char letter = 'a' + rand()%26;
		
		printf("%c %d\n", letter, start);
	}
	
	return 0;
}
