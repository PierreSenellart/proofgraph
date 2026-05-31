all: proofgraph.pdf proofgraph.sty

clean:
	l3build clean
	-$(MAKE) -C examples clean
	-$(MAKE) -C examples/realworld clean

ctan:
	l3build ctan

test:
	$(MAKE) -s -C examples
	@echo All synthetic tests passed!

# Private real-world suite (only present in local checkouts).
realworld:
	@if [ -f examples/realworld/Makefile ]; then $(MAKE) -s -C examples/realworld; \
	else echo "No private real-world suite present (examples/realworld/ is local-only)."; fi

%.pdf: %.dtx
	l3build doc

%.sty: %.ins %.dtx
	l3build unpack
	cp build/unpacked/$@ .

.PHONY: all clean ctan test realworld
