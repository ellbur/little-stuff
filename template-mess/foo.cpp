
#ifndef _foo_cpp
#define _foo_cpp 1

#ifndef _foo_hpp
#define _foo_real 1
#endif

#include "foo.hpp"

template<class A>
void B<A>::b() {
}

#if _foo_real

void C::c() {
	
}

#endif

#endif

