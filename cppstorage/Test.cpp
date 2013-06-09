
#include <iostream>

int foo(int const& a, int const& b)
{
	return a + b; 
}

int main()
{
	int x = 7;
	int y = 2; 
	
	std::cout << foo(x + y, 3);
	std::cout << "\n";
	
	return 0;
}

