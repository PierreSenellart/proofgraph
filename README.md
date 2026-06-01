# `proofgraph`: Dependency Graphs of Results

## About

The `proofgraph` package automatically produces a graph of the dependencies
between the results (theorems, lemmas, propositions…) of a mathematical
article. Unlike other approaches, it requires **no manual annotation**: it
infers an edge from one result to another whenever the proof of the former
refers to the latter through an ordinary cross-reference (`\ref`, `\cref`,
`\autoref`…). A manual `\uses` command is also available for dependencies
that are not expressed through a visible reference.

The package writes a [Graphviz](https://graphviz.org/) `.dot` file describing
the graph, which can be rendered with `dot` (or, with shell-escape enabled,
rendered and embedded into the document automatically). It can:

- infer dependencies from cross-references inside proofs, with no annotation;
- capture `\ref`, cleveref/hyperref variants (`\cref`, `\autoref`, `\eqref`…),
  manual `\uses`, and optionally `\cite` to external work;
- remove self-loops, suppress specific (e.g. unwanted forward) citations, and
  exclude chosen nodes;
- style nodes differently according to the type of result;
- optionally run Graphviz and include the rendered graph automatically.

The documentation of this package is provided in the `proofgraph.pdf` file,
produced from the documented source `proofgraph.dtx`.

## Prerequisites

In addition to a working installation of LaTeX2e, `proofgraph` relies on a few
other packages, which should be provided by all reasonable LaTeX distributions:

- `amsthm`
- `etoolbox`
- `xstring`
- `kvoptions`
- `graphicx` (only to embed the rendered graph in the document with
  `\proofgraph`; not needed if you only emit and render the `.dot` file)
- `tikz` and `hyperref` (optional, only to make the embedded graph's nodes
  clickable hyperlinks to their results; without them the graph is still
  embedded, just without links)

Rendering the `.dot` file into an image requires the external
[Graphviz](https://graphviz.org/) tool `dot`. Automatic rendering additionally
requires the document to be compiled with shell-escape enabled.

## Manual installation

Simply copy the file `proofgraph.sty` in your LaTeX working directory, or in any
other directory where LaTeX searches for packages.

## License

Copyright © 2026 by Pierre Senellart.

This work may be distributed and/or modified under the conditions of the LaTeX
Project Public License, either version 1.3 of this license or (at your option)
any later version. The latest version of this license is in
<http://www.latex-project.org/lppl.txt> and version 1.3 or later is part of all
distributions of LaTeX version 2005/12/01 or later.

## Contact

<https://github.com/PierreSenellart/proofgraph>

Pierre Senellart <pierre@senellart.com>

Bug reports and feature requests should preferably be submitted through the
*Issues* feature of GitHub.
