
#include "Formula.hpp"

Formula::Formula(Cell *car, List *args, Cell *closure) :
    car(car),
    args(args),
    closure(closure)
{
}

