
#ifndef _actions_hpp
#define _actions_hpp 1

struct PrintAction {
    void start();
    void block();
};

template<class A, class B>
struct ParallelAction {
    ParallelAction(A const& a, B const& b) : a(a), b(b) { }
    
    A a;
    B b;
    
    void start();
    void block();
};

template<class A, class B>
ParallelAction<A, B> operator|(A const& a, B const& b) {
    return ParallelAction<A,B>(a, b);
}

#endif

