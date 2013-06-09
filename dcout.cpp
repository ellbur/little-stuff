
#include <iostream>

bool debug_on = true;

class DebugCout {
};

DebugCout dcout;

template<class T>
DebugCout& operator<<(DebugCout &dcout, T arg) {
	if (debug_on) {
		std::cout << arg;
	}
	return dcout;
}

int main() {
	debug_on = true;
	dcout << "Hi!\n";
	
	debug_on = false;
	dcout << "Hi again!\n";
	
	return 0;
}

