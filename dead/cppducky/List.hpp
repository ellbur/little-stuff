
#ifndef _list_hpp
#define _list_hpp 1

#include <vector>
#include <string>
#include "Cell.hpp"

class List : public Cell {
public:
    List();
    virtual ~List();
 
    std::vector<Cell*> elements;
    std::vector<Cell*> names;
    CellMap<int> namedIndices;
};

#endif

