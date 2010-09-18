
#include "groups.hpp"
#include <boost/foreach.hpp>
#include <iostream>

using namespace std;

#define foreach BOOST_FOREACH

void collapseGroup(imat &table)
{
	Collapse coll(table);
}

Collapse::Collapse(imat &table) :
	n(table.shape()[0]),
	table(table),
	links(table.shape()[0]),
	elements(table.shape()[0])
{
	doCollapse();
}

Collapse::~Collapse()
{
}

void Collapse::doCollapse()
{
	for (int i=0; i<n; i++) {
		links[i] = i;
	}
	
	for (;;) {
		if (doDivision()) continue;
		if (doIdentity()) continue;
		if (doAssoc())    continue;
		
		break;
	}
	
	ivec elemLinks(n);
	int elemInd = 0;
	int a, b;
	
	little_set::iterator ia, ib;
	
	ia = elements.iter();
	while (ia.hasNext()) {
		a = ia.next();
		
		elemLinks[a] = elemInd++;
	}
	
	ia = elements.iter();
	while (ia.hasNext()) {
		a = elements.next();
		
		ib = elements.iter();
		
		while (ib.hasNext()) {
			b = ib.next();
			
			table[elemLinks[a]][elemLinks[b]] = elemLinks[links[table[a][b]]];
		}
	}
	
	table.resize(boost::extents[elements.size()][elements.size()]);
}

bool Collapse::doIdentity()
{
	int b, c;
	little_set::iterator ii;
	
	ii = elements.iter();
	
	while (ii.hasNext()) {
		b = ii.next();
		
		c = mul(0, b);
		
		if (c != b) {
			makeLink(b, c);
			return true;
		}
		
		c = mul(b, 0);
		
		if (c != b) {
			makeLink(b, c);
			return true;
		}
	}
	
	return false;
}

bool Collapse::doDivision()
{
	int a;
	little_set::iterator ii;
	
	ii = elements.iter();
	while (ii.hasNext()) {
		a = ii.next();
		
		if (doDivision(a)) {
			return true;
		}
	}
	
	return false;
}

bool Collapse::doDivision(int a)
{
	int b, c;
	vector<int> taken(n);
	little_set::iterator ii;
	
	foreach (int &t, taken) t = -1;
	
	ii = elements.iter();
	while (ii.hasNext()) {
		b = ii.next();
		
		if (taken[b] != -1 && taken[b] != b) {
			makeLink(b, taken[b]);
			return true;
		}
	}
	
	return false;
}

bool Collapse::doAssoc()
{
	int a;
	little_set::iterator ii;
	
	ii = elements.iter();
	while (ii.hasNext()) {
		a = ii.next();
		
		if (doAssoc(a)) {
			return true;
		}
	}
}

bool Collapse::doAssoc(int a)
{
	int b;
	little_set::iterator ii;
	
	ii = elements.iter();
	while (ii.hasNext()) {
		b = ii.next();
		
		if (doAssoc(a, b)) {
			return true;
		}
	}
	
	return false;
}

bool Collapse::doAssoc(int a, int b)
{
	int c, p1, p2;
	little_set::iterator ii;
	
	ii = elements.iter();
	while (ii.hasNext()) {
		c = ii.next();
		
		p1 = mul(mul(a, b), c);
		p2 = mul(a, mul(b, c));
		
		if (p1 != p2) {
			makeLink(p1, p2);
			return true;
		}
	}
	
	return false;
}

int Collapse::mul(int a, int b)
{
	return links[table[links[a]][links[b]]];
}

void Collapse::makeLink(int a, int b)
{
	int c;
	
	if (a == b) return;
	
	if (a > b) {
		int t = a;
		a = b;
		b = t;
	}
	
	for (int i=0; i<n; i++)
	for (int j=0; j<n; j++)
		if (table[i][j] == b) table[i][j] = a;
	
	// Recursively join elements
	
	little_set::iterator ii;
	
	ii = elements.iter();
	while (ii.hasNext()) {
		c = ii.next();
		
		makeLink(table[a][c], table[b][c]);
		makeLink(table[c][a], table[c][b]);
	}
	
	for (int i=0; i<n; i++) {
		if (links[i] == b) links[i] = a;
	}
	
	elements.erase(b);
}


