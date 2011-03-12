
#ifndef _blocks_hpp
#define _blocks_hpp 1

#include <vector>
#include <set>
#include <string>
#include <list>
#include <map>

#include <boost/shared_ptr.hpp>

#include "null.hpp"

class GroupTree;
class BlockSet;
class Topic;
class Block;

class GroupTree
{
public:
	GroupTree();
	
	void addChild(GroupTree child);
	std::vector<GroupTree> const& getChildren() const { return dyn->children; }
	
	void addWord(std::string const &word);
	std::set<std::string> const& getWords() const { return dyn->words; }
	
private:
	struct Dyn {
		std::vector<GroupTree> children;
		std::set<std::string> words;
	};
	typedef boost::shared_ptr<Dyn> Dyn_p;
	
	Dyn_p dyn;
};

class BlockSet
{
public:
	template<class M, class C>
	BlockSet(
		GroupTree root,
		M &matcher,
		C &canonicalizer
	);
	
	std::map<std::string,Topic> const& getTopics() { return dyn->topics; }
	
private:
	struct Dyn {
		std::map<std::string,Topic> topics;
	};
	typedef boost::shared_ptr<Dyn> Dyn_p;
	
	template<class M, class C>
	void doBlock(
		M &matcher,
		C &canonicalizer,
		double weight, 
		GroupTree root,
	   	std::list<Block> &parents
	);
	
	Dyn_p dyn;
};

class Block
{
public:
	Block(double weight);
	
	double getWeight() const { return weight; }
	void* getID() const { return id; }
	
private:
	double weight;
	void *id;
	
	static char *idCounter;
};

bool operator==(Block const &block1, Block const &block2);
bool operator<(Block const &block1, Block const &block2);

class Topic
{
public:
	Topic(std::string const &text);
	Topic(Topic const &left, Topic const &right);
	Topic(Null null=Null());
	
	std::string const& getText() const { return dyn->text; }
	std::set<Block> const& getBlocks() const { return dyn->blocks; }
	
	void addBlock(Block const& block);
	
private:
	struct Dyn {
		std::string text;
		std::set<Block> blocks;
	};
	typedef boost::shared_ptr<Dyn> Dyn_p;
	
	Dyn_p dyn;
};

// for template
#include "blocks.cpp"

#endif /* defined _blocks_hpp */

