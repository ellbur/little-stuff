
#include <iostream>
#include <vector>

using namespace std;

vector<bool*> square_table;

int main();
bool has_sqrt(int a, int n);
void do_square_table(int n);
bool isprime(int a);

int main()
{
	int N, k;
	
	N = 13;
	
	for (k=2; k<10000; k++) {
		if (has_sqrt(N, k) && isprime(k)) {
			cout << (k % N) << " " << isprime(k) << endl;
		}
	}
	
	cout << endl;
}

bool has_sqrt(int a, int n)
{
	do_square_table(n);
	
	return square_table[n][a % n];
}

void do_square_table(int n)
{
	int k, i;
	
	for (k=square_table.size(); k<=n; k++) {
		bool *list = new bool[k];
		
		for (i=0; i<k; i++) list[i] = false;
		for (i=0; i<k; i++) list[ (i*i) % k ] = true;
		
		square_table.push_back(list);
	}
}

bool isprime(int a)
{
	int i;
	
	for (i=2; i*i<a; i++) {
		if (a % i == 0) return false;
	}
	
	return true;
}
