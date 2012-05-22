
#ifndef _vcd_hpp
#define _vcd_hpp 1

#include <fstream>
#include <string>
#include <vector>
#include <map>
#include <set>
#include <boost/shared_ptr.hpp>

using std::string;
using std::map;
using std::set;
using std::vector;
using std::ifstream;
using boost::shared_ptr;

enum Bit {
    B0,
    B1,
    BU
};
typedef vector<Bit> Value;
Value parseValue(string bitstr);

template<class S> S& operator<<(S &s, Bit b) {
    s << (
        b == B0 ? '0' :
        b == B1 ? '1' : 'U');
    return s;
}
        
template<class S> S& operator<<(S &s, Value v) {
    for (Bit b : v) s << b;
    return s;
}

struct Change {
    long long time;
    Value value;
    
    Change(long long time, Value value) :
        time(time), value(value) { }
};

struct DynSignal {
    shared_ptr<ifstream> file;
    vector<Change> changes;
    bool valid;
    
    DynSignal(shared_ptr<ifstream> file);
};
struct Signal {
    string name;
    string symbol;
    int width;
    vector<Change> const& changes();
    
    Signal(string name, string symbol, int width, shared_ptr<ifstream> file);
    Signal();
    
    private:
        shared_ptr<DynSignal> dyn;
};

struct VCD;
struct Module {
    VCD& vcd;
    string prefix;
    
    Module(VCD &vcd, string prefix) :
        vcd(vcd), prefix(prefix) { }
    
    Module operator&(string rest);
    bool existsAsSignal();
    bool existsAsModule();
    bool existsAsScope() { return existsAsModule(); }
    Signal asSignal();
};

struct VCD {
    set<string> scopes;
    map<string,Signal> signals;
    
    VCD(string path);
    Module operator&(string rest);
    
    private:
        void buildSignals();
        shared_ptr<ifstream> file;
};

#endif

