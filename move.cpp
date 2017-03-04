
#include <iostream>

using std::cout;

struct A {
    int x;
};

A inc(A yo) {
    yo.x += 1;
    return yo;
}

int main() {
    A a = { 1 };
    A &&b = std::move(a);
    a.x += 1;
    b.x += 1;
    cout << (&b) << "\n";
}

