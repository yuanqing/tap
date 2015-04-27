TAP := tap.ml
OO := ocamlfind ocamlopt -g

all: example.out
	@./$<

%.out: %.ml $(TAP)
	@$(OO) -annot $(TAP) $< -o $*.out

clean:
	@rm -rf *.annot *.cm* *.mli *.o *.out

.PHONY: all clean
