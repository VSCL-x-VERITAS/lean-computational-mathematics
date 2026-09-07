# Chapter 2 organization baseline

Chapter 2 uses the repository-wide organization counters owned by the
`book-formalization-migration` workflow. The counters below were refreshed on
2026-09-07 against the rebased `lean-computational-mathematics` main tree at
`5c8a52cb47b1cc9801a4284c001f3e09df4000ff`.

Current measured counters:

| Counter | Value | Evidence |
|---|---:|---|
| unclassified production modules | 0 | `tools/architecture/check_layout.py`: 5,877 Lean modules, no unclassified or mixed modules |
| duplicate wrappers | 0 | `tools/architecture/check_compatibility.py`: 3,334 forwarders, 2,537 unique canonical targets, no production imports of historical paths |
| placeholder findings | 0 | `tools/architecture/check_placeholders.py`: 14,794 Lean files, no prohibited placeholders or unreviewed axioms |
| canonical placement pending | 0 | `tools/architecture/check_layout.py`: no missing documentation, legacy naming exceptions, declaration-bearing umbrellas, or unsorted aggregate imports |

These values describe the current rebased repository, not only Chapter 2. The
generated organization preflight rejects future gate-counter divergence before
a formalization run starts or stops.
