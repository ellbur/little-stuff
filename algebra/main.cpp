
#include <iostream>
#include "groups.hpp"
#include <cstdlib>
#include <ctime>

using namespace std;

const int n = 40;

int main(int argc, char **argv)
{
	srand(time(0));
	
	for (int times=0; times<1000; times++) {
		imat table = makeMat(n, n);
		
		for (int i=0; i<n; i++)
		for (int j=0; j<n; j++) {
			table[i][j] = rand() % n;
		}
		
		collapseGroup(table);
	}
}
