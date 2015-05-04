OO := ocamlfind ocamlopt -g

all: example.out
	./$<

tap.cmi: tap.mli
	$(OO) -c $<

tap.cmx: tap.ml tap.cmi
	$(OO) -annot -c $<

example/%.cmx: example/%.ml tap.cmx
	$(OO) -annot -c unix.cmxa $<

example.out: tap.cmx example/foo.cmx example/bar.cmx example/index.ml
	$(OO) -I example unix.cmxa $^ -o $@

clean:
	rm -f *.annot *.cm* *.o *.out
	rm -f example/*.annot example/*.cm* example/*.mli example/*.o

.PHONY: all clean
