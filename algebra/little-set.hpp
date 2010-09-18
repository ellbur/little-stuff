
#ifndef _little_set_hpp
#define _little_set_hpp 1

#include <vector>

class little_set {
public:
	
	class iterator;
	
	little_set(int size);
	
	iterator iter() const;
	
	void erase(int elem);
	int size() const { return _size; }
	
	class iterator {
	public:
		
		iterator() { }
		iterator(const little_set &set);
		
		bool hasNext();
		int next();
		
		iterator& operator=(const iterator &iter);
		
	private:
		
		const little_set &set;
		int position;
	};
	
private:
	
	std::vector<int> next;
	std::vector<int> prev;
	std::vector<bool> contained;
	int _size;
	
	friend class iterator;
};

#endif
