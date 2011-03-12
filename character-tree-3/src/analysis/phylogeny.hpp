
#ifndef _phylogeny_hpp
#define _phylogeny_hpp 1

#include <vector>
#include <list>
#include <map>
#include <utility>

#include <boost/shared_ptr.hpp>

#include "null.hpp"

template<typename E>
class PhyloNode
{
public:
	PhyloNode(const E &leaf);
	PhyloNode(
		PhyloNode<E> branch1,
		PhyloNode<E> branch2
	);
	PhyloNode(Null null=Null());
	
	std::vector<PhyloNode<E> > const& getChildren() const { return dyn->children; }
	E const& getObject() const { return object; }
	operator E const& () const { return object; }
	
	void* getID() const { return id; }
	
private:
	struct Dyn {
		std::vector<PhyloNode<E> > children;
	};
	typedef boost::shared_ptr<Dyn> Dyn_p;
	
	Dyn_p dyn;
	
	E object;
	void *id;
};

template<typename E>
bool operator==(PhyloNode<E> const &n1, PhyloNode<E> const &n2);

// ---------------------------------------------------------------------

template<typename E>
class NodePair
{
public:
	NodePair(
		PhyloNode<E> const &a,
		PhyloNode<E> const &b,
		double score
	);
	
	double getScore() const { return score; }
	
	PhyloNode<E> const& getA() const { return a; }
	PhyloNode<E> const& getB() const { return b; }
	
private:
	PhyloNode<E> a;
	PhyloNode<E> b;
	
	double score;
};

// ------------------------------------------------------------

template<typename E>
class Phylogeny
{
public:
	template<typename V,typename R>
	Phylogeny(V &objects, R &relator);
	
	PhyloNode<E> getRoot() { return root; }
	
private:
	template<typename V,typename R>
	void buildTree(V &objects, R &relator);
	
	template<typename R>
	void step(
		std::list<PhyloNode<E> > &points,
		std::list<NodePair<E> > &pairs,
		R &relator
	);
	
	PhyloNode<E> root;
};

#include "phylogeny.cpp"

#endif

