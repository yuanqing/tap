OFIND := ocamlfind
OC := $(OFIND) ocamlc
OOPT := $(OFIND) ocamlopt

INSTALL := META tap.mli tap.cmi tap.cmo tap.cma tap.cmx tap.cmxa tap.a

.PHONY: all
all: $(INSTALL)

.PHONY: install uninstall
install: $(INSTALL)
	$(OFIND) install tap $^
uninstall:
	$(OFIND) remove tap

.PHONY: test fail pass
test: fail pass
fail: fail.byte
	./$< | cmp test/expected/fail
pass: pass.byte
	./$< | cmp test/expected/pass
%.byte: tap.cma test/%.ml
	$(OC) unix.cma tap.cma $^ -o $@

.PHONY: clean
clean:
	rm -f *.a *.byte *.cm* *.o test/*.cm*

tap.cmi: tap.mli
	$(OC) -c $<
tap.cmo: tap.ml tap.cmi
	$(OC) -c $<
tap.cma: tap.cmo
	$(OC) -a -o $@ $<
tap.cmx: tap.ml tap.cmi
	$(OOPT) -c $<
tap.cmxa: tap.cmx
	$(OOPT) -a -o $@ $<
