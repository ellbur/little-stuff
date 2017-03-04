
LIB_SOURCES  = vcd.cpp
MAIN_SOURCES = test.cpp vcd.cpp
CPP_HEADERS  = vcd.hpp
PY_SOURCES   = vcd.cpp vcd-pyext.cpp

PY_INCLUDE   = -I/usr/include/python2.7

all: Makefile test
	./test

test: Makefile $(CPP_SOURCES) $(CPP_HEADERS)
	g++ -Wall -Wno-parentheses -Wno-sign-compare -g --std=c++0x -o test $(MAIN_SOURCES)

vcd.so: Makefile $(PY_SOURCES) $(CPP_HEADERS)
	g++ -Wall -Wno-parentheses -Wno-sign-compare -O3 -fPIC -shared $(PY_INCLUDE) --std=c++0x -o vcd.so $(PY_SOURCES)

