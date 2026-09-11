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

The approved migration uses `ComputationalMathematics` for canonical modules and
keeps the `numStability` package, `NumStabilityTest` root and authored
`NumStability` declaration names. The old `NumStability` import paths were
forwarders and were removed in release 0.2.0; the namespace and the declaration
names are unchanged and must stay unchanged.
Use the exact checked-in module map; do not rename mathematical suffixes or
invent canonical counterparts for older compatibility-only paths.

Use the verified cutover state and interface decisions in the
[identity migration report](docs/migrations/lean-computational-mathematics/README.md)
for operational URLs and public import guidance. Preserve the repository's
current checks and the pinned Lean/Mathlib versions during identity changes.

## Product code, not campaign state

Commit only reviewed product files. Formalization gates, ledgers, audits,
faithfulness workspaces and coordinator state are checkout-local runtime data;
preserve them through a separate outside-Git backup when recovery is needed.
In particular, never stage, commit or push anything below `gates/`, `ledgers/`,
`audits/`, `.faithfulness-audit/`, `.faithfulness-audit-v2/` or
`.formalization/`. Before formalization work, product commits and
reconciliation, install and check the checkout-local exclusions required by
the active book-formalization workflow. A tracked ignore rule or layout check
is only defense in depth and does not make campaign-state files part of the
Lean product.
