
#ifndef _blocks_cpp
#define _blocks_cpp 1

#ifndef _blocks_hpp
#define _blocks_real 1
#endif

#include "blocks.hpp"

#include <list>
#include <boost/foreach.hpp>

#define foreach BOOST_FOREACH

// --------------------------------------------------------
// Group Tree

#if _blocks_real

GroupTree::GroupTree() :
	dyn(new Dyn())
{
}

void GroupTree::addChild(GroupTree child)
{
	dyn->children.push_back(child);
}

void GroupTree::addWord(std::string const &word)
{
	dyn->words.insert(word);
}

#endif /* real */

// --------------------------------------------------------
// Block Set

template<class M, class C>
BlockSet::BlockSet(
	GroupTree root,
	M &matcher,
	C &canonicalizer
) :
	dyn(new Dyn())
{
	std::list<Block> parents;
	doBlock(matcher, canonicalizer, 1.0, root, parents);
}

template<class M, class C>
void BlockSet::doBlock(
	M &matcher,
	C &canonicalizer,
	double weight,
	GroupTree root,
	std::list<Block> &parents
)
{
	double childWeight = weight / root.getChildren().size();
	
	Block ours(weight);
	parents.push_back(ours);
	
	foreach (std::string const &word, root.getWords()) {
		std::string canonWord(canonicalizer(word));
		if (! matcher(canonWord)) {
			continue;
		}
		
		if (dyn->topics.count(canonWord) == 0) {
			dyn->topics[canonWord] = Topic(canonWord);
		}
		
		Topic &topic(dyn->topics[canonWord]);
		
		foreach (Block block, parents) {
			topic.addBlock(block);
		}
	}
	
	foreach (GroupTree child, root.getChildren()) {
		doBlock(
			matcher,
			canonicalizer,
			childWeight, 
			child, 
			parents
		);
	}
	
	parents.pop_back();
}

// ---------------------------------------------------------------
// Block

#if _blocks_real

Block::Block(double weight) :
	weight(weight)
{
	id = idCounter++;
}

char* Block::idCounter;

bool operator==(Block const &block1, Block const &block2)
{
	return block1.getID() == block2.getID();
}

bool operator<(Block const &block1, Block const &block2)
{
	return block1.getID() < block2.getID();
}

// ---------------------------------------------------------------
// Topic

Topic::Topic(std::string const &text) :
	dyn(new Dyn())
{
	dyn->text = text;
}

Topic::Topic(Topic const &left, Topic const &right) :
	dyn(new Dyn())
{
	dyn->text = std::string();
	
	dyn->blocks.insert(
		left.getBlocks().begin(),
		left.getBlocks().end()
	);
	dyn->blocks.insert(
		right.getBlocks().begin(),
		right.getBlocks().end()
	);
}

Topic::Topic(Null null)
{
}

void Topic::addBlock(Block const& block)
{
	dyn->blocks.insert(block);
}

#endif /* real */

#endif /* _blocks_cpp */

