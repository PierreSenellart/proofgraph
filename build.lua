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
  version      = "1.1.0",
  author       = "Pierre Senellart",
  uploader     = "Pierre Senellart",
  email        = "pierre@senellart.com",
  license      = "lppl1.3c",
  summary      = "Dependency graph of the results of a mathematical article",
  ctanPath     = "/macros/latex/contrib/proofgraph",
  repository   = "https://github.com/PierreSenellart/proofgraph",
  bugtracker   = "https://github.com/PierreSenellart/proofgraph/issues",
  update       = true,
  announcement = [[
Version 1.1.0 of proofgraph widens what the dependency graph of an article
records.

Citations: every citation command of natbib and biblatex is now captured, and
\proofgraphcitecommand declares further ones; \zcref of zref-clever is
captured like the other cross-referencing commands.

Statements: cross-references and citations made in the statement of a result,
and not only in its proof, are now recorded as dependencies; the new
"statements" option turns this off.

Proofs: \proofgraphproofenv declares further environments to be treated as
proofs; a result stated inside a proof is drawn as supporting the result that
proof establishes; and a \proofof anywhere in a proof pins the proof as a
whole, nested proofs included.

Editing the graph: \usescite and \proofgraphciteedge record a dependency on a
cited work by hand, and \proofgraphignorecite drops one; a rule that drops
nothing is now reported.

This release also fixes a number of bugs, among them citation nodes drawn
without style or hyperlink, dependencies wrongly recorded from a running head,
and every name but the first being ignored in a \proofgraphtrack list. The
manual lists them all.
]],
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
