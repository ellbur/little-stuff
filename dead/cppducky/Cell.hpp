
#ifndef _cell_hpp
#define _cell_hpp 1

#include <vector>
#include <string>
#include <map>
#include "Errors.hpp"

class Cell {
public:
    Cell(Type type);
    virtual ~Cell() { }
    
    virtual Cell* eval(Cell *closure);
    
    Cell* getAttribute(std::string key);
    void setAttribute(std::string key, Cell *value);
    
    int compare(Cell *c);
    virtual int compareSameType(Cell *c) = 0;
    
    // Features
    
    // We intentionall limit the possible types of cells.
    // Try not to add more. Build out of these.
    enum Type {
        NIL,
        INT,
        FLOAT,
        STRING,
        BOOL,
        LIST,
        ENVIRONMENT,
        FORMULA,
        EXPRESSION,
        FUNCTION,
        BUILTIN,
        EXTERNAL
    };
    
    Type type;
    std::vector<std::string,Cell*> attributes;
};

class CellComp {
public:
    CellComp(Cell *cell) : cell(cell) { }
    Cell *cell;
};

bool operator<(CellComp a, CellComp b) {
    return a.cell->lessThan(b);
}

template<class T>
class CellMap : public std::map<CellComp,T> {
};

#endif

