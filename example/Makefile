.PHONY: all
all: example.byte example.out

example.byte: example.ml
	ocamlfind ocamlc -package tap -linkpkg $^ -o $@

example.out: example.ml
	ocamlfind ocamlopt -package tap -linkpkg $^ -o $@

.PHONY: clean
clean:
	rm -f *.byte *.cm* *.o *.out
