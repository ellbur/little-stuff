
#include <stdio.h>

void big_stack(void)
{
	char foo[1024 * 1024];
	
	printf("ab");
	big_stack();
}

int main(int argc, char **argv)
{
	big_stack();
}
