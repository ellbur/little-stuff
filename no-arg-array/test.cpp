
#include <memory>
#include <ctime>

struct Foo {
    Foo(int x, int y) : x(x), y(y) { }
    
    int x;
    int y;
};

typedef std::allocator<Foo> Alloc;

int main() {
    int n = std::time(0) % 7;
    
    Alloc al;
    
    Alloc::pointer a = al.allocate(n);
    for (size_t i=0; i<n; i++) {
        al.construct(a + i, Foo(i, i));
    }
    
    // ...
    // Deallocate, etc.
}

