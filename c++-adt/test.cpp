
#include <functional>
#include <iostream>
#include <string>

using std::function;
using std::cout;
using std::string;

struct Turn;
struct Move;

typedef void* voidp;

struct Action {
    template<class T>
    T match(function<T (Turn const&)> turn, function<T (Move const&)> move) {
        return *((T*) matchImpl(
            [&](Turn const& t) { return (void*)(&turn(t)); },
            [&](Move const& m) { return (void*)(&move(m)); }
        ));
    }
    
    virtual void* matchImpl(function<voidp (Turn const&)> turn, function<voidp (Move const&)> move) = 0;
};

struct Turn : public Action {
    virtual void* matchImpl(function<voidp (Turn const&)> turn, function<voidp (Move const&)> move) {
        return turn(*this);
    }
};

struct Move : public Action {
    virtual void* matchImpl(function<voidp (Turn const&)> turn, function<voidp (Move const&)> move) {
        return move(*this);
    }
};

int main() {
    Turn turn = { };
    
    string result =
        turn.match(
            function<string(Turn const&)>([](Turn const& t) { return "Turn"; }),
            function<string(Move const&)>([](Move const& m) { return "Move"; })
        );
    
    cout << result << "\n";
}

