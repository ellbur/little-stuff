
#include "Cell.hpp"

Cell::Cell(Type type) :
    type(type)
{
}

Cell* Cell::eval(Cell *closure) {
    return this;
}

Cell* Cell::getAttribute(std::string key) {
    if (attributes.count(key) > 0) {
        return attributes[key];
    }
    else {
        return new Nil();
    }
}

Cell* Cell::setAttribute(std::string key, Cell *value) {
    attributes[key] = value;
}

int Cell::compare(Cell *c) {
    if (type < c.type) return -1;
    if (type > c.type) return +1;
    
    return compareSameType(c);
}

