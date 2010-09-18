
#include <stdio.h>

int main(int argc, char **argv) {
	
	struct {
		int a, b, c;
		struct { } bar;
		int d, e, f;
		struct { } baz;
	} foo;
	
	foo.a = argc;
	foo.b = foo.a;
	foo.c = foo.b;
	foo.d = foo.c;
	foo.e = foo.d;
	foo.f = foo.e;
	
	printf("%d\n", foo.f);
	
	return 0;
}

