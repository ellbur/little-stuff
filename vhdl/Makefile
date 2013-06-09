
foo.o: foo.vhd Makefile
	ghdl -a --ieee=synopsys foo.vhd
	
main: foo.o
	ghdl -e --ieee=synopsys Main
	
dump.vcd: main
	./main --vcd=dump.vcd


