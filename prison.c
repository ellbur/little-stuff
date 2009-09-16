
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int A[100] = {
	9,2,6,0,9,6,5,8,1,0,
	1,4,2,9,8,5,5,5,3,2,
	0,1,6,1,3,2,2,0,5,4,
	8,6,7,4,6,6,1,4,5,4,
	6,8,8,0,7,8,7,5,5,2,
	7,5,4,3,8,9,8,3,1,3,
	7,0,9,4,6,8,3,9,4,0,
	4,0,8,4,1,8,5,0,3,2,
	3,0,8,7,5,8,8,3,1,0,
	6,9,0,8,5,8,8,8,8,2
};

int B[100] = {
	1,9,5,5,1,2,5,3,1,5,
	6,9,3,8,1,2,5,4,2,5,
	5,1,2,2,8,7,6,5,0,9,
	5,1,0,0,9,1,5,4,6,6,
	1,4,7,7,2,1,1,8,5,5,
	5,3,8,8,5,6,5,3,3,7,
	2,1,9,2,3,0,5,8,6,1,
	7,7,6,4,6,0,5,9,8,3,
	4,6,8,3,4,5,1,1,8,7,
	8,2,8,9,4,1,1,1,0,7
};

int passphrase[20] = {
	3,1, 4,5, 9,2, 6,3, 8,7, 2,3, 2,5, 5,7, 8,1, 3,9
};

int main(int argc, char **argv)
{
	int i;
	
	if (argc <= 1) {
		fprintf(stderr, "usage: prison <salt>\n");
		return 1;
	}
	
	char *saltstr = argv[1];
	int salt[20];
	
	if (strlen(saltstr) != 20) {
		fprintf(stderr, "salt must be 20 digits\n");
		return 1;
	}
	
	for (i=0; i<20; i++) {
		salt[i] = saltstr[i] - '0';
	}
	
	int aptr = 0;
	int bptr = 0;
	int pptr = 0;
	int sptr = 0;
	
	while (! (feof(stdin) || ferror(stdin))) {
		char inchar = getchar();
		
		if (inchar < '0' || inchar > '9') {
			putchar(inchar);
			continue;
		}
		
		int digit = inchar - '0';
		
		sptr += A[aptr % 100];
		pptr += salt[sptr % 20];
		aptr += 10*passphrase[pptr%20] + passphrase[(pptr+1)%20];
		bptr += 10*A[aptr%100] + A[(aptr+1)%100];
		
		digit += B[bptr % 100];
		digit %= 10;
		
		putchar(digit + '0');
	}
}
