
build/Main.cmo: build/Data.cmo build/Run.cmo build/Builtin.cmo
build/Run.cmo: build/Data.cmo
build/Builtin.cmo: build/Data.cmo build/Run.cmo
# no tab here

all: exec

build/%.cmo: %.ml
	cd build && ocamlfind ocamlc -package batteries -c ../$< -o ./$<

exec: build/Data.cmo build/Run.cmo build/Builtin.cmo build/Main.cmo
	ocamlfind ocamlc -thread -linkpkg -package batteries $^ -o $@

clean:
	rm -f *.cmo *.cmi
	rm -f build/*
	rm -f exec
	
# vim: noexpandtab

