
#ifndef _tuple_hpp
#define _tuple_hpp 1

struct Tuple {
};

struct Nil : public Tuple {
};
const Nil nil = Nil();

template<class Car,class Cdr>
struct Pair : public Tuple {
	Car car;
	Cdr cdr;
	
	Pair(Car car, Cdr cdr);
};

template<class Car,class Cdr>
Pair<Car,Cdr> c(Car car, Cdr cdr);

template<class S>
S& operator<<(S &stream, Nil nil);

template<class S,class Car,class Cdr>
S& operator<<(S &stream, Pair<Car,Cdr> pair);

template<class Func>
Nil apply(Nil nil, Func func);

template<class Car,class Cdr,class Func>
void apply(Pair<Car,Cdr> tuple, Func func);

#include "Tuple.cpp"

#endif

