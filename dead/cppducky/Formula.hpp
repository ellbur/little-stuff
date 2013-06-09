
#ifndef _formula_hpp
#define _formula_hpp 1

#include "Cell.hpp"
#include "List.hpp"

class Formula : public Cell {
public:
    Formula(Cell *car, List *args, Cell *closure);
    virtual ~Formula() { }
    
    virtual Cell* eval(Cell *closure);
 
    Cell *car;
    List *args;
};

class Expression : public Cell {
public:
    Expression(Cell *formula);
    virtual ~Expression();
    
    Cell* eval();
    
    Cell *formula;
    Cell *closure;
};

#endif

