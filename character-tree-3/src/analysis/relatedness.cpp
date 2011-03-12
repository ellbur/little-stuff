
#ifndef _relatedness_cpp
#define _relatedness_cpp 1

#ifndef _relatedness_hpp
#define _relatedness_real 1
#endif

#include "relatedness.hpp"

#include <iostream>
#include <algorithm>

#include <boost/foreach.hpp>
#include <boost/assign/std/vector.hpp>

#define foreach BOOST_FOREACH

#if _relatedness_real

double relatedness(Topic const &topic1, Topic const &topic2)
{
	std::vector<double> table(tabulate(topic1, topic2));
	
	double caB = table[1];
	double cAb = table[2];
	double cAB = table[3];
	
	return cAB / (caB + cAb + cAB);
}

std::vector<double> tabulate(Topic const &topic1, Topic const &topic2)
{
	std::vector<double> table(4);
	
	foreach (Block const &block, topic1.getBlocks()) {
		if (topic2.getBlocks().count(block) > 0) {
			table[3]++;
		}
		else {
			table[2]++;
		}
	}
	foreach (Block const &block, topic2.getBlocks()) {
		if (topic1.getBlocks().count(block) > 0) {
			// Redundant
		}
		else {
			table[1]++;
		}
	}
	
	return table;
}

#endif /* real */

#endif /* _relatedness_cpp */

