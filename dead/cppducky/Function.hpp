
#ifndef _function_hpp
#define _function_hpp 1

#include "Cell.hpp"
#include "List.hpp"
#include "Formula.hpp"

class Function : public Cell {
public:
    Function();
    virtual ~Function() { }
    
    virtual Cell* call(List *args);
    
    CellMap<Param> *allParams;
    CellMap<int> *namedParams;
    int varargsParam;
    
    Cell *body;
    Cell *closure;
};

#endif

