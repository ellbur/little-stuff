
# vim: ft=sh

redo-ifchange $1.ml
ocamlfind ocamlc -thread -package batteries -linkpkg $1.ml -o $3
$(realpath $3) 1>&2

