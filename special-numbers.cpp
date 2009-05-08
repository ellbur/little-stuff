
#include <iostream>
#include <vector>

using namespace std;

vector<bool*> square_table;

int main();
bool has_sqrt(int a, int n);
void do_square_table(int n);

int main()
{
	int N, k;
	bool good;
	
	for (N=2; N<10000; N++) {
		good = true;
		
		for (k=1; k<N; k++) {
			if (has_sqrt(N, k) && !has_sqrt(k, N)) {
				good = false;
				break;
			}
		}
		
		if (good) {
			cout << N << " ";
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
