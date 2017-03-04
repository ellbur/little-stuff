
#include <functional>
#include <iostream>
#include <string>

using std::function;
using std::cout;
using std::string;

struct Turn;
struct Move;

template<class Ret, class Arg>
function<void(Arg,void*)> manualRVO(function<Ret(Arg)> orig) {
    return [](Arg arg, void *sink){
        *sink = orig(arg);
    };
}

struct Action {
    template<class T>
    T match(function<T (Turn const&)> turn) { return manualRVO
        T tmp;
        matchImpl(manualRVO(turn), &tmp);
        return tmp;
    }
    
    virtual void matchImpl(function<void (Turn const&)>, void *sink) = 0;
};

struct Turn : public Action {
    virtual void matchImpl(function<void (Turn const&), void*> turn, void *sink) {
        turn(*this, sink);
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


