# Top-level Makefile for proofgraph.
# NOTE: package build targets (proofgraph.sty / proofgraph.pdf via l3build) are
# added when the .dtx/.ins are in place. For now this wires the test targets.

.PHONY: all test realworld clean

all:
	@echo "Package sources (proofgraph.dtx/.ins) not yet present; nothing to build."

# Synthetic, public example suite (added during package build).
test:
	@if [ -d examples ] && [ -f examples/Makefile ]; then $(MAKE) -s -C examples; \
	else echo "No public example suite yet."; fi

# Private real-world suite: only present in local checkouts (gitignored).
realworld:
	@if [ -f examples/realworld/Makefile ]; then $(MAKE) -s -C examples/realworld; \
	else echo "No private real-world suite present (examples/realworld/ is local-only)."; fi

clean:
	@if [ -f examples/realworld/Makefile ]; then $(MAKE) -s -C examples/realworld clean; fi
