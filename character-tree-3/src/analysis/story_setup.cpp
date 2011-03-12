
#ifndef _story_setup_cpp
#define _story_setup_cpp 1

#ifndef _story_setup_hpp
#define _story_setup_real 1
#endif

#include "story_setup.hpp"

#include <boost/spirit/include/qi.hpp>

#include <string>
#include <vector>
#include <algorithm>
#include <cctype>

#include <iostream>
#include <iomanip>

#include <boost/foreach.hpp>
#define foreach BOOST_FOREACH

template<typename V>
StorySetup::StorySetup(const V &texts) :
	matcher(),
	canonicalizer(),
	root(),
	capThresh(2)
{
	processTexts(texts);
	filterWords();
}

#if _story_setup_real

void StorySetup::filterWords()
{
	for (auto i=capCount.begin(); i!=capCount.end(); ++i) {
		std::string const &word = (*i).first;
		int count = (*i).second;
		
		if (count >= capThresh) {
			words.insert(word);
		}
	}
	
	matcher.setWords(words);
}

#endif /* real */

template<typename V>
void StorySetup::processTexts(const V &texts)
{
	foreach (const std::string &text, texts) {
		processText(text);
	}
}

#if _story_setup_real
void StorySetup::processText(const std::string &text)
{
	using boost::spirit::qi::parse;
	using boost::spirit::qi::char_;
	using boost::spirit::qi::omit;
	using boost::spirit::qi::lit;
	
	using std::vector;
	
	bool success = false;
	vector<
		vector<
			vector<
				vector<char>
			>
		>
	> result;
	
	// I just don't want to deal with all these
	// declarations in the local namespace.
	{
		auto word   = +(char_("a-zA-Z"));
		auto space  = char_(" \t");
		auto nl     = lit("\r\n") | lit("\n");
		auto two_nl = nl >> (*space) >> nl;
		auto one_nl = nl - two_nl;
		auto gap    = space | one_nl;
		auto junk   = char_ - char_("a-zA-Z \t\r\n.?!");
		auto stop   = char_("?.!");
		
		auto sentence  = *(omit[*(gap|junk)] >> word);
		auto paragraph = sentence % omit[stop];
		auto page      = paragraph % omit[two_nl];
		
		auto &grammar = page;
		
		success = parse(
			text.begin(),
			text.end(),
			grammar,
			result
		);
	}
	
	GroupTree pageGroup;
	root.addChild(pageGroup);
	
	doPage(pageGroup, result);
}

void StorySetup::doPage(
	GroupTree pageGroup,
	const std::vector<std::vector<std::vector<std::vector<char>>>> &page
)
{
	using std::vector;
	
	foreach (const vector<vector<vector<char>>> &par, page) {
		GroupTree parGroup;
		pageGroup.addChild(parGroup);
		
		doParagraph(parGroup, par);
	}
}

void StorySetup::doParagraph(
	GroupTree parGroup,
	const std::vector<std::vector<std::vector<char>>> &par
)
{
	using std::vector;
	
	foreach (const vector<vector<char>> &sent, par) {
		GroupTree sentGroup;
		parGroup.addChild(sentGroup);
		
		doSentence(sentGroup, sent);
	}
}

void StorySetup::doSentence(
	GroupTree sentGroup,
	const std::vector<std::vector<char>> &sent
)
{
	using std::vector;
	using std::string;
	
	bool first = true;
	
	foreach (const vector<char> &wordChars, sent) {
		string word(wordChars.begin(), wordChars.end());
		
		if (!first) {
			considerWord(word);
		}
		
		sentGroup.addWord(word);
		first = false;
	}
}

void StorySetup::considerWord(std::string const &word)
{
	std::string key(canonicalizer(word));
	
	if (word.size() <= 0) {
		return;
	}
	
	if (capCount.count(key) == 0) {
		capCount[key] = 0;
	}
	if (std::isupper(word[0])) {
		capCount[key]++;
	}
	else if (std::islower(word[0])) {
		capCount[key]--;
	}
}

#endif /* real */

// ---------------------------------------------------------------

#if _story_setup_real

StorySetup::Matcher::Matcher()
{
}

bool StorySetup::Matcher::operator()(const std::string &word) const
{
	return words.count(word) > 0;
}

#endif /* real */

template<typename S>
void StorySetup::Matcher::setWords(S const &newWords) {
	words.clear();
	words.insert(newWords.begin(), newWords.end());
}

#if _story_setup_real

StorySetup::Canonicalizer::Canonicalizer()
{
}

std::string StorySetup::Canonicalizer::operator()(const std::string &word) const
{
	// copy it
	std::string wordP(word);
	
	std::transform(wordP.begin(), wordP.end(), wordP.begin(), ::tolower);
	return wordP;
}

#endif /* real */

#endif /* _story_setup_cpp */

