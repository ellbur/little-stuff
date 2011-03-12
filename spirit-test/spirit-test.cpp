 
#include <boost/spirit/include/qi.hpp>

#include <boost/foreach.hpp>

#include <iostream>
#include <string>
#include <vector>

#define foreach BOOST_FOREACH

namespace qi = boost::spirit::qi;

int main()
{
	using qi::parse;
	using qi::char_;
	using qi::omit;
	using qi::lit;
	
	using std::cout;
	using std::endl;
	
#define v std::vector
	
	std::string text =
		"....a b. c? d\n"
		"e f! g h.\n\n"
		"i j. k.\n\n";
	
	bool success = false;
	
	auto word   = +(char_("a-zA-Z"));
	auto space  = char_(" \t");
	auto nl     = lit("\r\n") | lit("\n");
	auto two_nl = nl >> (*space) >> nl;
	auto one_nl = nl - two_nl;
	auto gap    = space | one_nl;
	auto junk   = char_ - char_("a-zA-Z \t\r\n.?!");
	auto stop   = char_("?.!");
	
	auto sentence  = *(omit[*(gap|junk)] << word);
	auto paragraph = sentence % omit[stop];
	auto page      = paragraph % omit[two_nl];
	
	auto &grammar = page;
	
	v<v<v<v<char>>>> result;
	
	success = parse(
		text.begin(),
		text.end(),
		grammar,
		result
	);
	
	cout << success << endl;
	cout << endl;
	
	foreach (v<v<v<char>>> &p3, result) {
		foreach (v<v<char>> &p2, p3) {
			foreach (v<char> &p1, p2) {
				cout << std::string(p1.begin(), p1.end());
				cout << " ";
			}
			cout << endl;
		}
		cout << "- - - " << endl;
	}
}

