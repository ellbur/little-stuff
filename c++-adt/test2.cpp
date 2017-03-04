
#include <functional>
#include <iostream>

using std::function;
using std::cout;

template<class T>
void take(function<T(int)> f) {
    f(3);
}

int main() {
    take(function<int(int)>([](int x) { return x + 5; }));
}

