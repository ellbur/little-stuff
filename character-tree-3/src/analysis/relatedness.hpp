
#ifndef _relatedness_hpp
#define _relatedness_hpp 1

#include <vector>
#include "blocks.hpp"

double relatedness(Topic const &topic1, Topic const &topic2);

std::vector<double> tabulate(Topic const &topic1, Topic const &topic2);

// For template
#include "relatedness.cpp"

#endif

