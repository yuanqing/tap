TAP := tap.ml
EXAMPLE := example/*.ml
OO := ocamlfind ocamlopt -g

all: example.out
	@./$<

example.out: $(TAP) $(EXAMPLE)
	@$(OO) -annot $^ -o $@

clean:
	@rm -f *.annot *.cm* *.mli *.o *.out
	@rm -f */*.annot */*.cm* */*.mli */*.o */*.out

.PHONY: all clean
