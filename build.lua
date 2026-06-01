-- Build configuration file for proofgraph

module = "proofgraph"

typesetexe = "pdflatex"
typesetopts = " --interaction=nonstopmode --shell-escape"

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
