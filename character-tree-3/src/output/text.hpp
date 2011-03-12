
#ifndef _text_hpp
#define _text_hpp 1

#include <analysis/phylogeny.hpp>
#include <analysis/blocks.hpp>

template<typename S>
S& operator<<(S &stream, Topic topic);

template<typename E>
class TextTree
{
public:
	TextTree(PhyloNode<E> root);
	
	template<typename S>
	void printNode(S &stream);
	
private:
	PhyloNode<E> root;
	
	template<typename S>
	void printNode(S &stream, PhyloNode<E> node, int depth);
};

template<typename E>
inline TextTree<E> textTree(PhyloNode<E> root) {
	return TextTree<E>(root);
}

template<typename S,typename E>
S& operator<<(S &stream, TextTree<E> tree);

#include "text.cpp"

#endif

