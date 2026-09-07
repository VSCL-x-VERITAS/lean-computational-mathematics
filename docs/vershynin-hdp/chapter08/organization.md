# Chapter 8 organization baseline

## Preparation scope

This baseline prepares Vershynin HDP Chapter 8 only. It introduces no Lean
declaration, module, import, umbrella change, compatibility wrapper, or
architecture-tier entry. Chapters 3–7 are not campaign predecessors and no
file for those chapters is touched.

The preparation began from canonical Lean commit
`9e2225705fed906b1120d55105d607baabef57c9`, on
`work/formalization/vershynin-hdp/8/codex`. A repository search found no
existing `hdp_08_*` declaration, so no Chapter 8 source wrapper is being
mistaken for completed work.

## Canonical placement for future proof work

New semantic producers and source-facing Chapter 8 modules must use the
canonical `ComputationalMathematics` project root. `NumStability` remains a
compatibility import surface and must not receive new Chapter 8 declarations.
Preparation does not pre-choose module splits: each proof increment must first
identify the reusable producer, the source-facing contract, dependencies, and
downstream consumers.

## Measured gate counters

The Chapter 8 gate records the same current-tree organization counters as the
Chapter 1 and Chapter 2 gates:

| Counter | Value | Preparation evidence |
|---|---:|---|
| unclassified modules | 0 | No Chapter 8 Lean module or declaration exists in this increment. |
| duplicate wrappers | 0 | A search for `hdp_08_*` returns no existing wrapper. |
| placeholder findings | 0 | The Chapter 8 increment contains only the completed gate and derived documentation. |
| canonical placement pending | 0 | There is no Lean-bearing Chapter 8 row yet; every future closed row must classify placement in its proof increment. |

The candidate workflow's organization preflight compares these counters across
all available gates and passes for `ch01.json`, `ch02.json`, and `ch08.json`.
These zeros describe present Chapter 8 organization debt. They do not claim
that the 149 actionable source rows have been formalized.

## Campaign topology

The local reviewed topology names campaign `vershynin-hdp-main-2026q3` and
contains only units 1, 2, and 8. Unit 8 has an empty predecessor list, so
ignoring Chapters 3–7 is encoded structurally rather than left to convention.
After this preparation commit, the local runtime topology must bind the Chapter
8 lane to the new exact branch head before proof dispatch; integration and
`main` remain unchanged.
