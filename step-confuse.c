
#include <stdio.h>
#include <string.h>

int main(int argc, char **argv) {
	
	if (argc-1 != 3) {
		fprintf(stderr, "step-confuse <letter> <number> <count>\n");
		return 1;
	}
	
	if (strlen(argv[1]) <= 0) {
		fprintf(stderr, "letter must be at least on letter long\n");
		return 1;
	}
	
	char letter = argv[1][0];
	if ('A' <= letter && letter <= 'Z')
		letter = letter + 'a' - 'A';
	
	int number = atoi(argv[2]);
	int count  = atoi(argv[3]);
	
	count = count - (number-1) + ('z' - letter + 1);
	printf("%d\n", count);
	
	return 0;
}
