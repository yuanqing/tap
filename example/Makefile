OFIND := ocamlfind
OC := $(OFIND) ocamlc
OOPT := $(OFIND) ocamlopt

all: test.byte test.out

# byte
%.cmo: %.ml
	$(OC) -package tap -c $<
test.byte: foo.cmo bar.cmo index.ml
	$(OC) -package tap -linkpkg $^ -o $@

# native
%.cmx: %.ml
	$(OOPT) -package tap -c $<
test.out: foo.cmx bar.cmx index.ml
	$(OOPT) -package tap -linkpkg $^ -o $@

clean:
	rm -f *.byte *.cm* *.o *.out

.PHONY: all clean
