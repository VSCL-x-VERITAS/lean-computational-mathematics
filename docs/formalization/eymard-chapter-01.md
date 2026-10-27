# Eymard, Gallouët and Herbin: Chapter 1 handoff

This checkpoint preserves work on Chapter 1 (Introduction) of *Finite Volume
Methods*, January 2019 manuscript. The chapter occupies PDF pages 5–12 in the
[author's manuscript](https://raphaeleh.github.io/PUBLI/bookevol.pdf).

The frozen inventory contains 46 formalization obligations. **Three are
accepted and 43 remain; none is skipped or deferred.** This checkpoint does not
claim chapter completion.

| Accepted obligation | Lean declaration |
| --- | --- |
| Introductory local conservativity | `NumStability.Eymard.Chapter01.localConservativity` |
| Section 2.2 cell unknowns | `NumStability.Eymard.Chapter01.cellUnknowns` |
| Section 2.2 conservative exchange | `NumStability.Eymard.Chapter01.conservativeExchange` |

Their original independent statement audits and canonical proof receipts retain
authority. The proofs have exact frozen-target matches, successful native Lean
compilation, and no custom axioms, `sorry` or unsafe proofs. Those accepted
stages are preserved when continuing on another computer.

The remaining modules supply transparent mathematical definitions and candidate
statements. A declaration named `...Target` defines a proposition; it is not a
proof of that proposition or a claim that its source-faithfulness audit passed.
Source interpretation, complete material-definition captures, first statement
audits and proofs remain unfinished for the corresponding rows. In particular,
the Lax–Wendroff target is a statement of the requested convergence conclusion,
not a proved convergence theorem.

Import the checkpoint through:

```lean
import ComputationalMathematics.Source.Eymard.Chapter01
```

The integration smoke test imports the same entry point and checks all three
accepted proof wrappers against their target propositions.

All 69 original Eymard modules passed the native Lean build before this
checkpoint. Publication adds module documentation, entry-point imports and tier
metadata. The mathematical declarations are unchanged; the archive retains the
original authoring bytes and receipts. The layout checker distinguishes the
mathematical terms “closure” and “supporting line” in the two exact geometry
module names from workflow-oriented names; negative naming tests remain active.
Four scoped lint annotations retain intentionally unused time coordinates of
constant-in-time lifts and the common decidable-face interfaces. No lint or
warning baseline is relaxed.

## Continue on another computer

Clone this repository's `main` branch to obtain the passed product sources. The
separate [handoff release](https://github.com/VSCL-x-VERITAS/lean-computational-mathematics/releases/tag/eymard-chapter01-handoff-20261026)
contains the continuation archive, its checksum and restoration instructions.
Campaign gates, ledgers, audit outputs and proof receipts are intentionally
outside product Git history. A fresh clone alone does not contain that state.

The archive preserves the original authoring revision and source files, book
module, accepted evidence, partial work, sealed inventory and durable Claude
consultations. Follow its README to restore the original authoring lane; keep
the downloaded `main` product checkout available separately. The source campaign
retains its frozen base and is not rebased to the publication integration tree.

Use released workflow `formalization-workflow-v7.5.4` from
[formalization-collaboration](https://github.com/VSCL-x-VERITAS/formalization-collaboration).
The selected prospective full-family audit consumer is 2.2.1, with unchanged
producer contract and native expression format 2.2.0. New run-local identifiers
can exceed 999. Existing partial audits retain their original protocols and
completed roles.

Lean is pinned to `v4.29.0-rc3`; Mathlib is pinned to
`e8ea1afc32790ce1d4e1a4e45cc412ba9388716b`. Claude source-only consultation
remains enabled at Opus 5.5/max; reuse completed opinions and the original
recorded helper. External Comparator is optional; Linux is not required.

The old computer's coordinator is checkpointed for the transfer. Continue only
from one computer at a time. No outstanding preparation or successful target
elaboration adds to the three accepted source obligations above.
