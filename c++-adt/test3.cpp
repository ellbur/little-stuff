
#include <functional>
#include <iostream>
#include <string>

using std::function;
using std::cout;
using std::string;

struct Turn;
struct Move;

struct Action {
    template<class T>
    T match(function<T (Turn const&)> turn) {
        T tmp;
        matchImpl([&](Turn const& t) { tmp = turn(t); });
        return tmp;
    }
    
    virtual void matchImpl(function<void (Turn const&)>) = 0;
};

struct Turn : public Action {
    virtual void matchImpl(function<void (Turn const&)> turn) {
        turn(*this);
    }
};

int main() {
    Turn turn = { };
    
    string result = turn.match(
        function<string(Turn const& t)>([](Turn const& t) {
            return "Turn";
        })
    );
    
    cout << result << "\n";
}

