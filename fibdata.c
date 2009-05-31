
#include <stdio.h>

#define N_MAX 1000

void fib_data(int N, int *ephi, int *phi, int *tfib, int *fudge) {
	static int table[N_MAX];
	int i;
	int j;
	int a;
	int b;
	
	*ephi  = 0;
	*phi   = 0;
	*tfib  = 0;
	*fudge = 0;
	
	for (i=1; i<N; i++) {
		table[i] = 1;
	}
	table[0] = 0;
	
	for (i=2; i<N; i++) {
		if (! table[i]) continue;
		
		if (N % i == 0) {
			for (j=i; j<N; j += i) {
				table[j] = 0;
			}
		}
	}
	
	*ephi = 0;
	
	for (i=1; i<N; i++) {
		if (table[i]) (*ephi)++;
	}
	
	a = 0;
	b = 1;
	
	for (i=1; i<=N*N; i++) {
		b = a + b;
		a = b - a;
		
		b %= N;
		
		if (a==0 && b==1) {
			*tfib = i;
			break;
		}
	}
	
	for (i=0; i<N; i++) {
		if ((i*i - i - 1)%N == 0) {
			*phi = i;
			break;
		}
	}
	
	if (*ephi == N-1) {
		if (N%5 == 1 || N%5 == 4) {
			*fudge = (N-1) / *tfib;
		}
		else {
			*fudge = 2*(N+1) / *tfib;
		}
	}
}

int main(int argc, char **argv) {
	int n;
	int ephi;
	int phi;
	int tfib;
	int fudge;
	
	for (n=2; n<N_MAX; n++) {
		fib_data(n, &ephi, &phi, &tfib, &fudge);
		
		printf("%3d %4d %3d %3d %3d\n",
			n, tfib, phi, ephi, fudge);
	}
	
	return 0;
}
