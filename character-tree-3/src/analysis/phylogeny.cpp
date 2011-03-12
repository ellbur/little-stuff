
#ifndef _phylogeny_cpp
#define _phylogeny_cpp 1

#ifndef _phylogeny_hpp
#define _phylogeny_real 1
#endif

#include "phylogeny.hpp"

#include <boost/foreach.hpp>
#include <iostream>
#include <algorithm>

#define foreach BOOST_FOREACH

template<typename E>
PhyloNode<E>::PhyloNode(const E &leaf) :
	dyn(new Dyn()),
	object(leaf)
{
	id = dyn.get();
}

template<typename E>
PhyloNode<E>::PhyloNode(
	PhyloNode<E> branch1,
	PhyloNode<E> branch2
) :
	dyn(new Dyn()),
	object(branch1.getObject(), branch2.getObject())
{
	id = dyn.get();
	
	dyn->children.push_back(branch1);
	dyn->children.push_back(branch2);
}

template<typename E>
PhyloNode<E>::PhyloNode(Null null)
{
}

template<typename E>
bool operator==(PhyloNode<E> const &n1, PhyloNode<E> const &n2)
{
	return n1.getID() == n2.getID();
}

// ----------------------------------------------------------------

template<typename E>
NodePair<E>::NodePair(
	PhyloNode<E> const &a,
	PhyloNode<E> const &b,
	double score
) :
	a(a),
	b(b),
	score(score)
{
}

template<typename E>
bool operator<(NodePair<E> const &p1, NodePair<E> const &p2)
{
	return p1.getScore() > p2.getScore();
}

// ----------------------------------------------------------------

template<typename E>
template<typename V,typename R>
Phylogeny<E>::Phylogeny(V &objects, R &relator) :
	root()
{
	buildTree(objects, relator);
}

template<typename E>
template<typename V,typename R>
void Phylogeny<E>::buildTree(V &objects, R &relator)
{
	std::list<PhyloNode<E> > points;
	std::vector<NodePair<E> > pairsVec;
	
	foreach (E const &object, objects) {
		PhyloNode<E> node(object);
		points.push_back(node);
	}
	
	typename std::list<PhyloNode<E> >::iterator i, j;
	
	for (i=points.begin(); i!=points.end(); ++i)
	for (j=i,++j; j!=points.end(); ++j) {
		NodePair<E> pair(*i, *j, relator(*i, *j));
		pairsVec.push_back(pair);
	}
	
	std::sort(pairsVec.begin(), pairsVec.end());
	
	std::list<NodePair<E> > pairsList(pairsVec.begin(), pairsVec.end());
	
	while (points.size() > 1) {
		step(points, pairsList, relator);
	}
	
	if (points.size() > 0) {
		root = points.front();
	}
}

template<typename E>
template<typename R>
void Phylogeny<E>::step(
	std::list<PhyloNode<E> > &points,
	std::list<NodePair<E> > &pairs,
	R &relator
)
{
	NodePair<E> best(*pairs.begin());
	
	auto pairIter = pairs.begin();
	while (pairIter != pairs.end()) {
		NodePair<E> const &target(*pairIter);
		
		if (
			best.getA()==target.getA() ||
			best.getA()==target.getB() ||
			best.getB()==target.getA() ||
			best.getB()==target.getB()
		)
			pairIter = pairs.erase(pairIter);
		else
			++pairIter;
	}
	
	auto pointIter = points.begin();
	while (pointIter!=points.end()) {
		if (
			best.getA()==(*pointIter) ||
			best.getB()==(*pointIter)
		)
			pointIter = points.erase(pointIter);
		else
			++pointIter;
	}
	
	PhyloNode<E> join(best.getA(), best.getB());
	
	for (pointIter=points.begin(); pointIter!=points.end(); ++pointIter) {
		PhyloNode<E> &peer(*pointIter);
		
		double score(relator(join, peer));
		NodePair<E> match(join, peer, score);
		
		auto insPoint = std::upper_bound(
			pairs.begin(),
			pairs.end(),
			match
		);
		pairs.insert(insPoint, match);
	}
	
	points.push_back(join);
}

#endif

