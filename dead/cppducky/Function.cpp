
#include "Function.hpp"

Function::Function() {
}

Cell* Function::call(List *args) {
    Environment *local = new Environment(closure);
    
    CellMap<bool> hit;
    int paramIndex = 0;
    
    auto &els = args->elements;
    for (int i=0; i<els.size(); i++) {
        Cell *name  = args->names[i];
        Cell *value = els[i];
        
        if (name != NULL) {
            if (namedParams.count[
        }
    }
    
    return body->eval(local);
}

