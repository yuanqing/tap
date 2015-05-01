OO := ocamlfind ocamlopt -g

all: example.out
	@./$<

tap.cmi: tap.mli
	@$(OO) -c $<

tap.cmx: tap.ml tap.cmi
	@$(OO) -c $<

example.out: tap.cmx example/*.ml
	@$(OO) -annot $^ -o $@

clean:
	@rm -f *.annot *.cm* *.o *.out
	@rm -f example/*.annot example/*.cm* example/*.mli example/*.o

.PHONY: all clean
