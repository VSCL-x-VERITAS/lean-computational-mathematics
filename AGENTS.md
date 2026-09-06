## Project naming and stability terminology

The project is called Lean Computational Mathematics. The selected repository
slug is `lean-computational-mathematics`. Numerical stability remains a
mathematical subject within the library.

Classify names by what they denote. Update project branding when needed,
but preserve stability-related mathematical terminology, source titles,
and source identifiers. Do not globally replace `stability` or `stable`.

Package names, library targets, module roots, namespaces and other public
interfaces require an explicit migration map and compatibility decision.
A public repository rename alone does not authorize changing them.

The approved migration uses `ComputationalMathematics` for canonical modules,
retains old `NumStability` imports as forwarders, and keeps the `numStability`
package, `NumStabilityTest` root and authored `NumStability` declaration names.
Use the exact checked-in module map; do not rename mathematical suffixes or
invent canonical counterparts for older compatibility-only paths.

Use the verified cutover state and interface decisions in the
[identity migration report](docs/migrations/lean-computational-mathematics/README.md)
for operational URLs and public import guidance. Preserve the repository's
current checks and the pinned Lean/Mathlib versions during identity changes.
