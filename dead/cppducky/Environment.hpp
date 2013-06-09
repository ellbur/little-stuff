
#ifndef _environment_hpp
#define _environment_hpp 1

#include <map>
#include <string>

class Environment : public Cell {
public:
    Environment(Cell *parent);
    virtual ~Environment() { }
    
    virtual Cell* get(Cell* name);
    virtual void set(Cell*name, Expression *formula);
    
    Cell *parent;
    CellMap<EnvEntry> namedIndices;
};

class EnvEntry {
public:
    EnvEntry(Expression *formula, Cell *value);
    
    Expression *formula;
    Cell *value;
};

#endif

