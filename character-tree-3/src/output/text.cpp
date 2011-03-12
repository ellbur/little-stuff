
#ifndef _text_cpp
#define _text_cpp 1

#ifndef _text_hpp
#define _text_real 1
#endif

#include "text.hpp"

#include <analysis/phylogeny.hpp>

#include <boost/foreach.hpp>

#define foreach BOOST_FOREACH

template<typename S>
S& operator<<(S &stream, Topic topic)
{
	return stream << topic.getText();
}

template<typename E>
TextTree<E>::TextTree(PhyloNode<E> root) :
	root(root)
{
}

template<typename E>
template<typename S>
void TextTree<E>::printNode(S &stream)
{
	printNode(stream, root, 0);
}

template<typename E>
template<typename S>
void TextTree<E>::printNode(S &stream, PhyloNode<E> node, int depth)
{
	for (int i=0; i<depth; i++) {
		stream << "  ";
	}
	
	if (node.getChildren().size() == 0) {
		stream << "- " << node.getObject() << "\n";
	}
	else {
		stream << "+" << "\n";
		
		foreach (PhyloNode<E> const &child, node.getChildren()) {
			printNode(stream, child, depth+1);
		}
	}
}

template<typename S,typename E>
S& operator<<(S &stream, TextTree<E> tree)
{
	tree.printNode(stream);
	
	return stream;
}

#endif

