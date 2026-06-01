# Synthetic regression tests for proofgraph. Each subdirectory below holds a
# self-contained test.tex and a committed reference.dot; this Makefile compiles
# the fixture (twice, so \label/\cite and citelabel=tag resolve) and checks the
# emitted .dot against the reference. The private realworld/ submodule is driven
# by its own Makefile (target `realworld` at the repo root), not here.
#
# Coverage of documented features/options:
#   features  core \ref capture, \cref/\autoref, optional-title capture,
#             \uses, \proofgraphedge, \proofof, \proofgraphtrack (overriding a
#             default exclusion), \proofgraphuntrack (excluding a tracked kind),
#             \proofgraphignore, \proofgraphexclude,
#             \proofgraphstyle, \proofgraphstylecite, cite, citelabel=key with
#             per-(key,note) node splitting, selfloops=remove (default),
#             unnumbered exclusion, and "/\ label escaping.
#   options   direction=uses, selfloops=keep, rankdir, file.
#   citetag   citelabel=tag.
#   predefined detection of theorem environments predefined before the package.
#   apxproof  deferred-proof capture via \apxproofhook (bundled apxproof.sty).
# The autorun, engine, format, hyperlinks options and \proofgraph itself are
# exercised by the manual build (l3build doc), which is an autorun proofgraph
# document with clickable embedded graphs.
SHELL  := /bin/bash
REPO   := $(CURDIR)/..
TESTS  := apxproof features options citetag predefined

.PHONY: all clean $(TESTS)
all: $(TESTS)

$(TESTS):
	@cd $@ ; \
	  latexmk -C test >/dev/null 2>&1 ; rm -f test.dot mygraph.dot ; \
	  TEXINPUTS=".:$(REPO):" pdflatex -interaction=nonstopmode test >/dev/null 2>&1 ; \
	  TEXINPUTS=".:$(REPO):" pdflatex -interaction=nonstopmode test >/dev/null 2>&1 ; \
	  d=$$(ls *.dot 2>/dev/null | grep -v '^reference\.dot$$' | head -1) ; \
	  if [ -n "$$d" ] && diff -q "$$d" reference.dot >/dev/null 2>&1 ; then \
	    echo "ok   $@ ($$d)" ; \
	  else \
	    echo "FAIL $@" ; [ -n "$$d" ] && diff "$$d" reference.dot ; exit 1 ; \
	  fi

clean:
	@for d in $(TESTS); do \
	  ( cd $$d && latexmk -C test >/dev/null 2>&1; rm -f test.dot mygraph.dot \
	    test.axp *-proofgraph.* *-proofgraph.map ) ; \
	done ; echo "cleaned."
