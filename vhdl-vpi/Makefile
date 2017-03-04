
.PHONY: all
all: main loaded.vpi
	./main --vpi=./loaded.vpi

foo.o: foo.vhd Makefile
	ghdl -a --ieee=synopsys foo.vhd
	
main: foo.o
	ghdl -e --ieee=synopsys Main
    
loaded.vpi: loaded.c
	gcc --std=c99 -I. -fPIC -shared -o loaded.vpi loaded.c
	
