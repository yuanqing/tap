OFIND := ocamlfind
OC := $(OFIND) ocamlc
OOPT := $(OFIND) ocamlopt

INSTALL := META tap.mli tap.cmi tap.cmo tap.cma tap.cmx tap.cmxa tap.a

all: $(INSTALL)

tap.cmi: tap.mli
	$(OC) -c $<

# byte
tap.cmo: tap.ml tap.cmi
	$(OC) -c $<
tap.cma: tap.cmo
	$(OC) -a -o $@ $<

# native
tap.cmx: tap.ml tap.cmi
	$(OOPT) -c $<
tap.cmxa: tap.cmx
	$(OOPT) -a -o $@ $<

clean:
	rm -f *.a *.cm* *.o

install: $(INSTALL)
	$(OFIND) install tap $^
uninstall:
	$(OFIND) remove tap

.PHONY: all clean install uninstall
