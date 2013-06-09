
#include "actions.hpp"
#include <cstdio>

void PrintAction::start() {
    printf("Starting\n");
}

void PrintAction::block() {
    printf("Blocking\n");
}

template<class A, class B>
void ParallelAction<A, B>::start() {
    a.start();
    b.start();
}

template<class A, class B>
void ParallelAction<A, B>::block() {
    a.block();
    b.block();
}

int main() {
    
    auto par = PrintAction() | PrintAction() | PrintAction();
    par.start();
    
    return 0;
}

