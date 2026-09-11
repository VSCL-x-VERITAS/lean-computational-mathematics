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

## Product code, not campaign working state

Commit reviewed Lean source, tests, reusable tooling, and curated documentation.
Keep all formalization campaign state local to the checkout, including `gates/`,
`ledgers/`, `audits/`, `.faithfulness-audit/`, `.faithfulness-audit-v2/`, and
`.formalization/`. This includes gate bindings, audit tasks, decisions,
manifests, reports, inputs, agent outputs, claim/target packets, reconciliation
requests, raw command output, transcripts, rerun histories, and rendered source
pages. Local backups may preserve this state outside Git. Never force-add it to
`main` or a work lane; `tools/architecture/check_layout.py` rejects it.
