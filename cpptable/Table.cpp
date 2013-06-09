
#ifndef _table_cpp
#define _table_cpp 1

#ifndef _table_hpp
#define _table_real 1
#endif

#include "Table.hpp"

template<class T>
CSV<T>::CSV(
	T columns,
	std::vector<std::string> names
) :
	columns(columns),
	names(names)
{
}

template<class S>
S& operator<<(S &stream, CSV<Nil> csv)
{
	return stream;
}

template<class S,class Car,class Cdr>
S& operator<<(S &stream, CSV<Pair<Car,Cdr>> csv)
{
	for (auto i=csv.names.begin(); i!=csv.names.end();) {
		stream << *i;
		++i;
		if (i != csv.names.end()) {
		    stream << ",";
		}	
	}
	stream << "\n";
	
	auto i = csv.columns.car.begin();
	auto js = startIterators(csv.columns);
	
	for (; i!=csv.columns.car.end(); ++i) {
		printRow(js);
		stream << "\n";
			
		advance(js);
	}
}

#endif

