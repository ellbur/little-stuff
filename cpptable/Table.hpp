
#ifndef _table_hpp
#define _table_hpp 1

#include <vector>
#include <string>
#include "Tuple.hpp"

template<class T>
struct CSV {
	CSV(
		T columns,
		std::vector<std::string> names
	);
	
	T columns;
	std::vector<std::string> names;
};

template<class S>
S& operator<<(S &stream, CSV<Nil> csv);

template<class S,class Car,class Cdr>
S& operator<<(S &stream, CSV<Pair<Car,Cdr>> csv);

#endif

