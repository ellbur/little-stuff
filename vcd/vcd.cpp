
#include "vcd.hpp"
#include <sstream>
#include <iostream>

using std::ostringstream;
using std::istringstream;
using std::ios;
using std::pair;
using std::cout;

Value parseValue(string bitstr) {
    Value value;
    for (int i=0; i<bitstr.size(); i++) {
        char c = bitstr[i];
        switch (c) {
            case 'b': break;
            case '0': value.push_back(B0); break;
            case '1': value.push_back(B1); break;
            default:  value.push_back(BU);
        }
    }
    return value;
}

Signal::Signal(string name, string symbol, int width, vector<Change> const& changes) :
    name(name),
    symbol(symbol),
    width(width),
    changes(changes)
{
}

Signal::Signal() { }
    
VCD::VCD(string path) :
    scopes(),
    signals(),
    signalsBySymbol()
{
    buildSignals(path);
}

void VCD::buildSignals(string path) {
    ifstream file(path);
    
    vector<string> scopeStack;
    auto qualifiedName = [&](string end) -> string {
        ostringstream full;
        for (string part : scopeStack)
            full << part << ".";
        full << end;
        return full.str();
    };
    auto currentScope = [&]() -> string {
        ostringstream full;
        for (int i=0; i<scopeStack.size(); i++) {
            full << scopeStack[i];
            if (i < scopeStack.size()-1) full << ".";
        }
        return full.str();
    };
    
    while (file.good()) {
        string line;
        getline(file, line);
        if (line.find("enddefinitions") != string::npos)
            break;
        
        if (line.find("$scope") != string::npos) {
            istringstream parts(line);
            string _, scope;
            
            parts >> _ >> _ >> scope;
            scopeStack.push_back(scope);
            scopes.insert(currentScope());
        }
        else if (line.find("$upscope") != string::npos) {
            scopeStack.pop_back();
        }
        else if (line.find("$var") != string::npos) {
            istringstream parts(line);
            string _, nameStr, symbol;
            int width;
            
            parts >> _ >> _ >> width >> symbol >> nameStr;
            string endName;
            int bIndex = nameStr.find("[");
            if (bIndex != string::npos)
                endName = nameStr.substr(0, bIndex);
            else
                endName = nameStr;
            
            string sigName = qualifiedName(endName);
            
            shared_ptr<Signal> sig = shared_ptr<Signal>(
                    new Signal(sigName, symbol, width, vector<Change>()));
            signals[sigName] = sig;
            signalsBySymbol[symbol] = sig;
        }
    }
    
    int currentTime = 0;
    while (file.good()) {
        string line;
        getline(file, line);
        
        if (line.size() <= 0) {
            continue;
        }
        else if (line.size()>0 && line[0]=='#') {
            istringstream t(line.substr(1, line.size()-1));
            t >> currentTime;
        }
        else {
            string bitStr, symStr;
            int spaceI = line.find(" ");
            if (spaceI == string::npos) {
                bitStr = line.substr(0, 1);
                istringstream t(line.substr(1, line.size()-1));
                t >> symStr;
            }
            else {
                istringstream t(line);
                t >> bitStr;
                t >> symStr;
            }
            if (signalsBySymbol.count(symStr) > 0) {
                Value value = parseValue(bitStr);
                Change change(currentTime, value);
                signalsBySymbol[symStr]->changes.push_back(change);
            }
        }
    }
}
    
Module VCD::operator&(string rest) {
    return Module(*this, rest);
}

Module Module::operator&(string rest) {
    return Module(vcd, prefix + "." + rest);
}

bool Module::existsAsSignal() {
    return vcd.signals.count(prefix) > 0;
}

bool Module::existsAsModule() {
    return vcd.scopes.count(prefix) > 0;
}

shared_ptr<Signal> Module::asSignal() {
    return vcd.signals[prefix];
}

