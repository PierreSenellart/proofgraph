-- Build configuration file for proofgraph

module = "proofgraph"

typesetexe = "pdflatex"
typesetopts = " --interaction=nonstopmode --shell-escape"
textfiles = {"README.md", "LICENSE"}

-- Metadata for `l3build upload`. Update `version` at each release; set
-- `announcement` for feature releases, keep it empty for bugfix releases
-- (an empty announcement means the CTAN update is not announced).
uploadconfig = {
  pkg          = "proofgraph",
  version      = "1.1.1",
  author       = "Pierre Senellart",
  uploader     = "Pierre Senellart",
  email        = "pierre@senellart.com",
  -- "1.3 or later" is what the package headers grant, and what the CTAN
  -- catalogue records; the LICENSE file holds the 1.3c text because that is
  -- the latest version of the licence, not because 1.3c is the version granted.
  license      = "lppl1.3",
  summary      = "Dependency graph of the results of a mathematical article",
  -- The long description and the topics as the CTAN catalogue holds them, so
  -- that an upload restates rather than silently drops them. The catalogue
  -- records no home, support or development channel for the package, and
  -- `note` is a message to the CTAN team, not a stored field: all four are
  -- left unset, which is what the `??` of the upload summary means.
  description  = [[
<p>
      The proofgraph package automatically produces a graph
      of the dependencies between the results (theorems, lemmas,
      propositions, and so on) of a mathematical article.
      It requires no manual annotation: an edge from one result
      to another is inferred whenever the proof of the former refers
      to the latter through an ordinary cross-reference
      (<tt>\ref</tt>, <tt>\cref</tt>, <tt>\autoref</tt>,
      <tt>\eqref</tt>, and similar), with a manual <tt>\uses</tt>
      command also available for dependencies not expressed
      through a visible reference.
      Citations of external work can optionally be captured as well.
      The package writes a Graphviz <tt>.dot</tt> file describing
      the graph; with shell-escape enabled it can additionally run
      Graphviz and embed the rendered graph into the document.
      Nodes can be styled according to the type of result,
      self-loops removed, specific citations suppressed,
      and chosen nodes excluded.
    </p>]],
  topic        = {"label-ref", "diagram-maths", "proof", "maths-theorem"},
  ctanPath     = "/macros/latex/contrib/proofgraph",
  repository   = "https://github.com/PierreSenellart/proofgraph",
  bugtracker   = "https://github.com/PierreSenellart/proofgraph/issues",
  update       = true,
  announcement = "",
}

-- The pre-rendered real-world example graph (Section "A real-world example" of
-- the manual) is committed as an image and embedded with \includegraphics: the
-- paper it comes from is private, so the graph cannot be regenerated at
-- doc-build time. Make the image available to the typesetting run.
typesetsuppfiles = {"example-realworld.pdf"}

function typeset(file, dir)
  local errorlevel = tex(file, dir)
  if errorlevel ~= 0 then
    return errorlevel
  else
    local name = jobname(file)
    local function cycle(name, dir)
      return(
        makeindex(name, dir, ".glo", ".gls", ".glg", glossarystyle) +
        makeindex(name, dir, ".idx", ".ind", ".ilg", indexstyle)    +
        tex(file, dir)
      )
    end
    for i = 1, typesetruns do
      errorlevel = cycle(name, dir)
      if errorlevel ~= 0 then break end
    end
    return errorlevel
  end
end
