
#include "little-set.hpp"

using namespace std;

little_set::little_set(int size) :
	size(size),
	next(size + 1),
	prev(size + 1),
	contained(size + 1)
{
	for (int i=0; i<size; i++) {
		next[i] = i+1;
		prev[i] = i-1;
		contained[i] = true;
	}
	next[size] = 0;
	prev[size] = size-1;
}

little_set::iterator little_set::begin() const
{
	return iterator(*this);
}

void little_set::erase(int elem)
{
	if (! contained[elem])
		return;
	
	contained[elem] = false;
	
	if (elem == 0) {
		next[size]    = next[0];
		prev[next[0]] = prev[0];
	}
	else {
		next[prev[elem]] = next[elem];
		prev[next[elem]] = prev[elem];
	}
	
	_size--;
}

little_set::iterator::iterator(const little_set &set) :
	set(set),
	position(set.size())
{
}

bool little_set::iterator::hasNext()
{
	return set.next[position] != set.size();
}

int little_set::iterator::next()
{
	do {
		position = set.next[position];
	} while (! set.contains[position]);
	
	return position;
}
