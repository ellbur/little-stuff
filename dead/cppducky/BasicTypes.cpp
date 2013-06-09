
#include "BasicTypes.hpp"
#include <cstring>
#include <cstdlib>

Nil::Nil() :
    Cell(NIL)
{
}

int Nil::compareSameType(Cell *c) {
    return 0;
}

Int::Int(long long value) :
    Cell(INT),
    value(value)
{
}

int Int::compareSameType(Cell *c) {
    Int *i = (Int*) c;
    if (value < i->value) return -1;
    if (value > i->value) return +1;
    return 0;
}

Float::Float(long double value) :
    Cell(FLOAT),
    value(value)
{
}

int Float::compareSameType(Cell *c) {
    Float *f = (Float*) c;
    if (value < f->value) return -1;
    if (value > f->value) return +1;
    return 0;
}

String::String(std::string value) :
    Cell(STRING),
    value(value)
{
}

int String::compareSameType(Cell *c) {
    String *s = (String*) c;
    return std::strcomp(value.c_str(), c->value.c_str());
}

Bool::Bool(bool value) :
    Cell(BOOL),
    value(value)
{
}

int Bool::compareSameType(Cell *c) {
    Bool *b = (Bool*) c;
    if (value < b->value) return -1;
    if (value > b->value) return +1;
    return 0;
}

External::External() :
    Cell(EXTERNAL)
{
}

int External::compareSameType(Cell *c) {
    return 0;
}

