
#include "Table.hpp"
#include <iostream>

int main()
{
	auto p = c(1, c(3, nil));
	
	apply(p, [](int x){
		std::cout << x << "\n";
	});
		
	std::cout << p;
	
	return 0;
}

