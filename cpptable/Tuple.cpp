
#ifndef _tuple_cpp
#define _tuple_cpp 1

#ifndef _tuple_hpp
#define _tuple_real 1
#endif

#include "Tuple.hpp"

template<class Car,class Cdr>
Pair<Car,Cdr> c(Car car, Cdr cdr)
{
	return Pair<Car,Cdr>(car, cdr);
}

template<class Car,class Cdr>
Pair<Car,Cdr>::Pair(
	Car car,
	Cdr cdr
) :
	car(car),
	cdr(cdr)
{
}

template<class S>
S& operator<<(S &stream, Nil nil)
{
	return stream;
}

template<class S,class Car,class Cdr>
S& operator<<(S &stream, Pair<Car,Cdr> pair)
{
	return stream << pair.car << "," << pair.cdr;
}

template<class Func>
Nil apply(Nil nil, Func func)
{
	return nil;
}

template<class Car,class Cdr,class Func>
void apply(Pair<Car,Cdr> tuple, Func func)
{
	func(tuple.car);
   	apply(tuple.cdr, func);
}

#endif
 
