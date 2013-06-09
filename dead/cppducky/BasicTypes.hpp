
#ifndef _basic_types_hpp
#define _basic_types_hpp 1

#include "Cell.hpp"
#include <string>

class Nil : public Cell {
public:
    Nil();
    virtual ~Nil() { }
    
    virtual int compareSameType(Cell *c);
};

class Int : public Cell {
public:
    Int(long long value);
    virtual ~Int() { }
    
    long long value;
    
    virtual int compareSameType(Cell *c);
};

class Float : public Cell {
public:
    Float(long double value);
    virtual ~Float() { }
    
    long double value;
 
    virtual int compareSameType(Cell *c);
};

class String : public Cell {
public:
    String(std::string value);
    virtual ~String() { }
    
    std::string value;
    
    virtual int compareSameType(Cell *c);
};

class Bool : public Cell {
public:
    Bool(bool value);
    virtual ~Bool() { }
    
    bool value;
    
    virtual int compareSameType(Cell *c);
};

class External : public Cell {
public:
    External();
    virtual ~External() { }
    
    virtual int compareSameType(Cell *c);
};

#endif

