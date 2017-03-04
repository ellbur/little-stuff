
#include <functional>
#include <iostream>
#include <string>
#include <utility>

using std::function;
using std::cout;
using std::string;
using std::declval;

struct Turn;
struct Move;

template<class F, class Arg>
function<void(Arg,void*)> manualRVO(F orig) {
    return [&](Arg arg, void *sink){
        *sink = orig(arg);
    };
}

struct Action {
    template<class F, class G>
    auto match(F turn, G move) -> decltype(turn(declval<Turn>())) {
        decltype(turn(declval<Turn>())) tmp;
        matchImpl(manualRVO(turn), manualRVO(move), &tmp);
        return tmp;
    }
    
    virtual void matchImpl(
        function<void (Turn const&, void*)>,
        function<void (Move const&, void*)>,
        void *sink
    ) = 0;
};

struct Turn : public Action {
    double angle;
    
    virtual void matchImpl(
        function<void (Turn const&, void*)> f,
        function<void (Move const&, void*)>,
        void *sink
    )
    {
        f(*this, sink);
    }
};

struct Move : public Action {
    double x;
    double y;
    
    virtual void matchImpl(
        function<void (Turn const&, void*)>,
        function<void (Move const&, void*)> g,
        void *sink
    )
    {
        g(*this, sink);
    }
};

int main() {
    Turn turn;
    
    string result = turn.match(
        [](Turn const& t) {
            return "Turn";
        },
        [](Move const& m) {
            return "Move";
        }
    );
    
    cout << result << "\n";
}

