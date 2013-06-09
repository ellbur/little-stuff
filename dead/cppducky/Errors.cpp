
#include "Errors.hpp"

NoFeatureError::NoFeatureError(Cell *object, std::string feature) :
    object(object),
    feature(feature)
{
}

NameNotFoundError::NameNotFoundError(Cell *name) :
    name(name)
{
}

