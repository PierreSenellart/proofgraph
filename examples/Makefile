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
#   nestedproof \cite capture in a proof nested inside another proof (the
#             capture once reinstalled over itself there and recursed forever,
#             which is why pdflatex runs under timeout below: a regression
#             fails fast instead of hanging the suite).
#   natbibcite the two-optional-argument \cite[pre][post]{key} form of natbib
#             and biblatex: the post-note is the recorded note (sharing a slot
#             with the equivalent one-argument \cite), the pre-note is ignored.
#   biblatex  citelabel=tag under biblatex, whose tags no \b@<key> in the .aux
#             records: numeric style, tag taken from the labelnumber field.
#   biblatexalpha same, alphabetic style, tag taken from labelalpha.
#   zrefclever zref-clever's \zcref, the one captured cross-reference that is
#             not simply \cs{labels}: plain, starred, with an option, with a
#             comma-separated label list, and in an optional proof title.
# The autorun, engine, format, hyperlinks options and \proofgraph itself are
# exercised by the manual build (l3build doc), which is an autorun proofgraph
# document with clickable embedded graphs.
SHELL  := /bin/bash
REPO   := $(CURDIR)/..
TESTS  := apxproof features options citetag predefined nestedproof natbibcite \
          biblatex biblatexalpha zrefclever

.PHONY: all clean $(TESTS)
all: $(TESTS)

# A fixture that runs biblatex leaves a .bcf behind on its first pass; biber is
# then run in between, so that the second pass has the tags the first could not
# know. The .bbl is generated rather than committed: its format is tied to the
# biblatex version, and a stale committed one would break on a newer TeX Live.
$(TESTS):
	@cd $@ ; \
	  latexmk -C test >/dev/null 2>&1 ; rm -f test.dot mygraph.dot ; \
	  TEXINPUTS=".:$(REPO):" timeout 120 pdflatex -interaction=nonstopmode test >/dev/null 2>&1 ; \
	  if [ -f test.bcf ] ; then timeout 120 biber test >/dev/null 2>&1 ; fi ; \
	  TEXINPUTS=".:$(REPO):" timeout 120 pdflatex -interaction=nonstopmode test >/dev/null 2>&1 ; \
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
