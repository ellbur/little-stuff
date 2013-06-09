
#include "Environment.hpp"

Environment::Environment(Cell *parent) :
    parent(parent)
{
}

Cell* Environment::get(Cell *name) {
    if (entries.count(name) > 0) {
        EnvEntry entry = entries[name];
        if (entry.value != NULL) {
            return entry.value;
        }
        
        EnvEntry evaled(
            entry.formula,
            entry.formula->eval()
        );
        entries[name] = evaled;
        
        return evaled.value;
    }
    else if (parent != NULL) {
        return parent->get(name);
    }
    else {
        throw NameNotFoundError(name);
    }
}

void Environment::set(Cell *name, Expression *formula) {
    entries[name] = EnvEntry(formula, NULL);
}

