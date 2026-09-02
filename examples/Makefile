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
#   citetag   citelabel=tag; its reference.map pins the plain cite.<key> anchor
#             of a document without biblatex.
#   citeanchor the anchor a citation node links to under biblatex, which is
#             cite.<refsection>@<key>: recorded from the entry for a cited key,
#             assumed to be in the first reference section for a key reached by
#             \usescite alone. Pinned in its reference.map.
#   predefined detection of theorem environments predefined before the package.
#   apxproof  capture of every proof apxproof typesets (bundled apxproof.sty):
#             deferred proofs via \apxproofhook, plain and titled proofs
#             replayed from a toappendix block, a plain proof and a
#             proofsketch left in the body.
#   nestedproof \cite capture in a proof nested inside another proof (the
#             capture once reinstalled over itself there and recursed forever,
#             which is why pdflatex runs under timeout below: a regression
#             fails fast instead of hanging the suite); and a claim stated
#             inside a proof, drawn as supporting the result being proved, with
#             its own proof attached to the claim and the enclosing proof
#             resuming its own attribution afterwards.
#   natbibcite the two-optional-argument \cite[pre][post]{key} form of natbib
#             and biblatex: the post-note is the recorded note (sharing a slot
#             with the equivalent one-argument \cite), the pre-note is ignored.
#   biblatex  citelabel=tag under biblatex, whose tags no \b@<key> in the .aux
#             records: numeric style, tag taken from the labelnumber field.
#   biblatexalpha same, alphabetic style, tag taken from labelalpha.
#   citecmds  citation commands beyond \cite: biblatex's \textcite, \parencite
#             and \autocite, a starred form, and one command registered by hand
#             with \proofgraphcitecommand.
#   zrefclever zref-clever's \zcref, the one captured cross-reference that is
#             not simply \cs{labels}: plain, starred, with an option, with a
#             comma-separated label list, and in an optional proof title.
#   proofenv  \proofgraphproofenv, in its two shapes: an environment of one's
#             own taking an optional title (whose default title is not
#             \proofname, so the wrapper must not assume one), and one declared
#             with \newtheorem, which is hooked at its beginning and kept out of
#             the graph as a result.
#   statements the statements option: \ref and \cite in the body of a result,
#             the optional title still contributing its own edge, and the
#             capture stopping at \end (text between results adds no edge).
#   manualcite \usescite and \proofgraphciteedge, which draw citation nodes
#             without the cite option, including for a result that has no proof.
#   citenote  the label of a citation node carrying a note: the note inside the
#             tag, the -- and --- ligatures as HTML character entities, and one
#             node per (key, note) pair.
#   bracedtitle an optional title that is a single brace group, for a result and
#             for a proof: the braces TeX strips off a delimited argument have
#             to be restored before the title is handed back to the heading.
#   detachedproof \proofof pinning a whole proof, including the references made
#             before it and a result labelled after it.
#   nestedproofof proofs nested in proofs, as a structured proof writes them:
#             an enclosing \proofof reaching the nested ones, an inner \proofof
#             overriding it for its own proof, and the proof of a claim stated
#             inside a proof still going to the claim. A nested proof used to
#             take the result preceding the proof around it, so the fixture
#             ends on a result that must stay edge-free.
#   headref   a \ref and a \cite in a sectional title, with a proof long enough
#             that a page is shipped while it is open: the running head runs
#             them again in the output routine, and they were recorded as
#             dependencies of the result being proved. The \ref in the proof
#             itself must still be captured.
#   pf2       Lamport's structured proofs, the package issue #4 came from: a
#             proof tree three levels deep, its nested proofs reached by one
#             \proofof, alongside an amsthm proof in the same document. Needs
#             pf2.sty, which is not bundled (see REQUIRE_pf2 below); skipped
#             when it is absent.
#   ignore    \proofgraphignore and \proofgraphignorecite: the argument order
#             (that of \proofgraphedge, the result first, the reverse of the
#             arrow drawn), a rule written the wrong way round leaving the graph
#             alone, per-(key, note) citation nodes, and a citation node
#             vanishing with its last edge.
#   autorun   the autorun option and \proofgraph, under LuaLaTeX, where the
#             rendering used to be dropped on the floor: Graphviz has to have
#             run, and the second pass has to embed the image it produced. The
#             fixture styles its theorem with an RGB colour and loads tikz and
#             hyperref, so the embedding pass reads the -Tplain layout, whose
#             node lines echo that colour: the # once came back as a parameter
#             character and stopped the pass (issue #9), hence the target also
#             fails on any error in the log of the second pass.
# The engine, format and hyperlinks options are exercised by the manual build
# (l3build doc), which is an autorun proofgraph document with clickable embedded
# graphs. The autorun option and \proofgraph have a fixture of their own, run
# apart from the others by the `autorun' target below, since what it has to
# check is not a .dot but a rendering that took place.
SHELL  := /bin/bash
REPO   := $(CURDIR)/..
TESTS  := apxproof features options citetag predefined nestedproof natbibcite \
          biblatex biblatexalpha zrefclever citecmds proofenv statements \
          manualcite citenote bracedtitle detachedproof citeanchor \
          nestedproofof headref ignore pf2

# A fixture may need a package that cannot be assumed installed. REQUIRE_<test>
# names the style file it wants; the fixture is skipped, with a message, when
# neither its own directory nor the TeX tree provides it.
#
# pf2 is such a case: Lamport distributes it from his own site
# (https://lamport.azurewebsites.net/latex/), it is not on CTAN, and the file
# carries no licence statement, so it is not bundled here. Drop pf2.sty into
# examples/pf2/, or install it in your TEXMF tree, and the fixture runs.
REQUIRE_pf2 := pf2

.PHONY: all clean autorun $(TESTS)
all: $(TESTS) autorun

# A fixture that runs biblatex leaves a .bcf behind on its first pass; biber is
# then run in between, so that the second pass has the tags the first could not
# know. The .bbl is generated rather than committed: its format is tied to the
# biblatex version, and a stale committed one would break on a newer TeX Live.
#
# The .dot is the graph; the -proofgraph.map beside it says what each node links
# to when the graph is embedded, which the .dot does not record. A fixture that
# has something to say about the map (the citation anchors) commits a
# reference.map as well, and it is compared whenever it is there.
$(TESTS):
	@need="$(REQUIRE_$@)" ; \
	  if [ -n "$$need" ] && [ ! -f "$@/$$need.sty" ] && \
	     ! kpsewhich "$$need.sty" >/dev/null 2>&1 ; then \
	    echo "skip $@ ($$need.sty not found, see the note in examples/Makefile)" ; \
	    exit 0 ; \
	  fi ; \
	  cd $@ ; \
	  latexmk -C test >/dev/null 2>&1 ; rm -f test.dot mygraph.dot ; \
	  TEXINPUTS=".:$(REPO):" timeout 120 pdflatex -interaction=nonstopmode test >/dev/null 2>&1 ; \
	  if [ -f test.bcf ] ; then timeout 120 biber test >/dev/null 2>&1 ; fi ; \
	  TEXINPUTS=".:$(REPO):" timeout 120 pdflatex -interaction=nonstopmode test >/dev/null 2>&1 ; \
	  d=$$(ls *.dot 2>/dev/null | grep -v '^reference\.dot$$' | head -1) ; \
	  m=$$(ls *-proofgraph.map 2>/dev/null | head -1) ; \
	  ok=1 ; \
	  if [ -z "$$d" ] || ! diff -q "$$d" reference.dot >/dev/null 2>&1 ; then ok=0 ; fi ; \
	  if [ -f reference.map ] && \
	     { [ -z "$$m" ] || ! diff -q "$$m" reference.map >/dev/null 2>&1 ; } ; then ok=0 ; fi ; \
	  if [ $$ok -eq 1 ] ; then \
	    echo "ok   $@ ($$d)" ; \
	  else \
	    echo "FAIL $@" ; [ -n "$$d" ] && diff "$$d" reference.dot ; \
	    if [ -f reference.map ] ; then \
	      if [ -n "$$m" ] ; then diff "$$m" reference.map ; \
	      else echo "  no map emitted, reference.map expected" ; fi ; \
	    fi ; exit 1 ; \
	  fi

# The autorun fixture stands apart: it is compiled with LuaLaTeX, which is where
# the rendering was silently dropped (\write18 is an ordinary output stream
# there, so the Graphviz command was written out rather than run), and what it
# checks is not only the .dot but that the run left a rendered image and a
# -Tplain layout behind, and that the second pass embedded them instead of
# warning that they were not there, without an error: reading the layout back
# once broke on the # of an RGB colour. It needs Graphviz and shell-escape, so
# it is skipped, like a fixture whose package is missing, when dot is not
# installed.
autorun:
	@if ! command -v dot >/dev/null 2>&1 ; then \
	   echo "skip autorun (Graphviz not installed)" ; exit 0 ; \
	 fi ; \
	 if ! command -v lualatex >/dev/null 2>&1 ; then \
	   echo "skip autorun (lualatex not installed)" ; exit 0 ; \
	 fi ; \
	 cd autorun ; \
	 latexmk -C test >/dev/null 2>&1 ; rm -f test.dot test-proofgraph.* ; \
	 for pass in 1 2 ; do \
	   TEXINPUTS=".:$(REPO):" timeout 120 lualatex -shell-escape \
	     -interaction=nonstopmode test >/dev/null 2>&1 ; \
	 done ; \
	 ok=1 ; \
	 if ! diff -q test.dot reference.dot >/dev/null 2>&1 ; then \
	   echo "FAIL autorun" ; diff test.dot reference.dot ; ok=0 ; \
	 fi ; \
	 for f in test-proofgraph.pdf test-proofgraph.plain ; do \
	   if [ ! -f $$f ] ; then \
	     echo "FAIL autorun ($$f not rendered)" ; ok=0 ; \
	   fi ; \
	 done ; \
	 if grep -q "proofgraph Warning" test.log ; then \
	   echo "FAIL autorun (warned on the second pass)" ; \
	   grep -A2 "proofgraph Warning" test.log ; ok=0 ; \
	 fi ; \
	 if grep -q "^!" test.log ; then \
	   echo "FAIL autorun (error on the second pass)" ; \
	   grep -A2 "^!" test.log ; ok=0 ; \
	 fi ; \
	 if [ $$ok -eq 1 ] ; then echo "ok   autorun (test.dot, test-proofgraph.pdf)" ; \
	 else exit 1 ; fi

clean:
	@for d in $(TESTS) autorun; do \
	  ( cd $$d && latexmk -C test >/dev/null 2>&1; rm -f test.dot mygraph.dot \
	    test.axp *-proofgraph.* *-proofgraph.map ) ; \
	done ; echo "cleaned."
