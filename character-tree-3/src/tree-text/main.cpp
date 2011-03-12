
#include <analysis/story_setup.hpp>
#include <analysis/blocks.hpp>
#include <analysis/relatedness.hpp>
#include <analysis/phylogeny.hpp>

#include <output/text.hpp>

#include <list>
#include <vector>
#include <string>
#include <iostream>
#include <fstream>
#include <sstream>
#include <map>

#include <boost/foreach.hpp>

#define foreach BOOST_FOREACH

int main(int argc, char **argv)
{
	std::list<std::string> texts;

	if (argc <= 1) {
		std::cerr << argv[0] << " file ..." << std::endl;
		return 1;
	}

	for (int i=1; i<argc; i++) {
		std::string path(argv[i]);

		std::ifstream input(path);
		std::stringstream text;

		text << input.rdbuf();
		input.close();

		texts.push_back(text.str());
	}

	StorySetup setup(texts);
	BlockSet blocks(
			setup.getRoot(),
			setup.getMatcher(),
			setup.getCanonicalizer()
			);

	std::map<std::string,Topic> const &topicMap(blocks.getTopics());
	std::vector<Topic> topics;

	std::pair<std::string,Topic> tpair;
	foreach (tpair, topicMap) {
		topics.push_back(tpair.second);
	}

	Phylogeny<Topic> phylo(topics, relatedness);

	std::cout << textTree(phylo.getRoot());
}

