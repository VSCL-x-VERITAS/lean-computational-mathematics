# Chapter 1 editorial clarifications: audited companion results

The project owner authorized precise companion statements for three ambiguous
sentences in Chapter 1 of Nocedal and Wright, *Numerical Optimization*, second
edition. These are project-owner interpretations, not quotations from the PDF
or author-issued errata. The original PDF rows, audit outcomes, and three gate
deferrals remain on record. The mathematical companions have separate source
projections, row IDs, statement audits, and Lean proof receipts.

| Companion | Precise statement | Source version | Audit decision | Proof wrapper |
| --- | --- | --- | --- | --- |
| C1, discrete | The real binary set `{0,1}` is nonconvex. | C1 v1 | `faithful-equivalent`, accepted | `discreteBinaryClarificationV1` |
| C2, convex local minimum | For every natural dimension, including zero, a total real-valued `f` convex on `D` has every local minimizer on convex `s ⊆ D` globally minimal on `s`. | C2 v2 | `faithful-equivalent`, accepted after adjudication | `localGlobalClarificationV2` |
| C3, volume discount | With `δ > 0`, zero route costs make the square-root objective zero on nonnegative shipment arrays; a nonzero route cost yields a midpoint failure on that orthant. | C3 v2 | `faithful-equivalent`, accepted after adjudication | `volumeDiscountClarificationV2` |

The first editorial wording of C2 left the function's total domain and the
zero-dimensional case unstated; its blind audit could not resolve those scope
choices. C2 v2 states both explicitly. The first wording of C3 said the
zero-cost identity held for every real shipment array, while the real
square-root formula was presented without a convention for negative arguments.
C3 v2 restricts that identity to nonnegative arrays. These revisions are
versioned; the original audit inputs were not silently replaced. The C2/C3 v1
audit attempts retain their judge outputs as superseded local history and were
not finalized. Only the C2/C3 v2 runs are final accepted audits.

Each final audit used the independent v2.1.8 source-contract, blind
translation, direct, round-trip, and definition/domain roles on GPT-6 Sol
High. C2 and C3 also received mandatory independent adjudication of residual
source wording questions. Each final run has zero candidate findings. The
statement audit completion receipts are in the checkout-local `audits/` tree;
the claim, target, and proof receipts are in the checkout-local `ledgers/`
tree. `claim_contract.py validate-row` passes for all three rows, and the
proof wrappers compile without `sorry`, `admit`, custom axioms, or `unsafe`.

The source projections are in the Nocedal package's
`source/projections/chapter-01-clarification-c1-v1.txt`,
`chapter-01-clarification-c2-v2.txt`, and
`chapter-01-clarification-c3-v2.txt`. The three proof wrappers are in
`ComputationalMathematics/Source/NocedalWright/Chapter01/ClarificationProofsV2.lean`.
The companion gate counts these three rows separately from the printed PDF
inventory. It does not change PDF-source completion or authorize publication.
