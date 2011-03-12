
#ifndef _story_setup_hpp
#define _story_setup_hpp 1

#include <string>
#include <map>
#include <set>

#include "blocks.hpp"

class StorySetup
{
public:
	
	template<typename V>
	StorySetup(const V &texts);
	
	class Matcher : public std::set<std::string>
	{
	public:
		Matcher();
		bool operator()(const std::string &word) const;
		
		template<typename S>
		void setWords(S const &newWords);
	private:
		std::set<std::string> words;
	};
	
	class Canonicalizer
	{
	public:
		Canonicalizer();
		std::string operator()(const std::string &word) const;
	};
	
	GroupTree getRoot() { return root; }
	Matcher& getMatcher() { return matcher; }
	Canonicalizer& getCanonicalizer() { return canonicalizer; }
	
	const std::set<std::string>& getWords() const { return words; }
	
private:
	
	void filterWords();
	
	template<typename V>
	void processTexts(V const &texts);
	void processText(std::string const &text);
	
	void doPage(
		GroupTree pageGroup,
		std::vector<std::vector<std::vector<std::vector<char> > > > const &page
	);
	void doParagraph(
		GroupTree parGroup,
		std::vector<std::vector<std::vector<char> > > const &par
	);
	void doSentence(
		GroupTree sentGroup,
		std::vector<std::vector<char> > const &sent
	);
	
	void considerWord(std::string const &word);
	
	Matcher matcher;
	Canonicalizer canonicalizer;
	
	GroupTree root;
	
	std::set<std::string> words;
	std::map<std::string,int> capCount;
	int capThresh;
};

// For templates
#include "story_setup.cpp"

#endif

