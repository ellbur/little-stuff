
#ifndef _groups_hpp
#define _groups_hpp 1

#include <boost/multi_array.hpp>

#include <vector>
#include "little-set.hpp"

typedef boost::multi_array<int, 2> imat;
inline imat makeMat(int rows, int cols) {
	return imat(boost::extents[rows][cols]);
}

typedef std::vector<int> ivec;

template<class S> S& operator<<(S &stream, imat &table);

void collapseGroup(imat &table);

class Collapse {
public:
	
	Collapse(imat &table);
	~Collapse();
	
private:
	
	int n;
	imat &table;
	ivec links;
	little_set elements;
	
	void doCollapse();
	bool doIdentity();
	bool doDivision();
	bool doDivision(int a);
	bool doAssoc();
	bool doAssoc(int a);
	bool doAssoc(int a, int b);
	
	int mul(int a, int b);
	void makeLink(int a, int b);
};

#include "groups-template.cpp"

#endif
