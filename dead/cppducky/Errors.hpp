
#ifndef _errors_hpp
#define _errors_hpp 1

#include <string>

class NoFeatureError {
public:
    NoFeatureError(Cell *object, std::string feature);
    virtual ~NoFeatureError() { }
    
    Cell *object;
    std::string feature;
};

class NameNotFoundError {
public:
    NameNotFoundError(Cell *name);
    virtual ~NameNotFoundError() { }
    
    Cell *name;
};

#endif

