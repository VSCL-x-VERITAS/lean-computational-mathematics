# Shared vector-operator consolidation

This slice resolves the eight duplication cases selected during Bhatia Chapter I
organization work. The owner authorized the two-module consolidation on
2026-10-25. The definitions stay in their existing reusable modules and retain
all legacy declaration names and import paths.

| Legacy declaration | Canonical producer |
|---|---|
| `IsComplexVectorMapLinear` | `IsLinearMap ℂ` |
| `complexVectorMapComp` | `Function.comp` |
| `complexVectorMapAdd` | Pointwise function addition |
| `complexVectorMapSMul` | Pointwise function scalar action |
| `complexVectorMapNeg` | Pointwise function negation |
| `complexVectorMapSub` | Pointwise function subtraction |
| `IsComplexMatrixLeftInverse` | `Function.LeftInverse` on matrix-vector actions |
| `IsComplexMatrixRightInverse` | `Function.RightInverse` on matrix-vector actions |

Composition and the pointwise operations still accept every function between
finite complex-vector spaces; they require no linearity hypothesis. Both inverse
predicates retain the original matrix/inverse argument order. No dimension,
nonzero, continuity or invertibility assumption is introduced.

The linearity predicate is now an abbreviation. Compatibility definitions retain
its constructor, both field projections, dependent `rec`, `recOn` and `casesOn`,
and the old generated constructor spelling. The eliminators use the canonical
proof fields and retain computable elimination into `Sort`; they do not require
a new noncomputability annotation at callers. Reflection should unfold the
abbreviation to inspect Mathlib's inductive predicate. No wrapper removal is
scheduled. The lint driver exempts only the three proof-valued compatibility
abbreviations `mk`, `map_add`, and `map_smul` from `defLemma`; their reducibility
preserves constructor matching and the legacy projection interface. The reviewed
global lint baseline is unchanged.

The existing linearity theorems and linear-map bridge retain their statements.
Seven affected consumer modules (`OperatorNorms.Basic`,
`OperatorNorms.Attainment`, `MatrixNorms.SpectralRadius`,
`Conditioning.DistanceToSingularity`, `Conditioning.InversePerturbation`,
`LinearOperators.MatrixPowers.BaiDemmelGu.DistanceToInstability`, and the Higham
Chapter 7 `LinearSystemsConditioning.Theorem05.Part02` leaf) have proof-only
adaptations for the canonical field and operation forms. The new
`complexVectorMapSMul_apply` lemma exposes the legacy vector notation without
requiring clients to unfold the implementation. No consumer theorem is renamed
or weakened.

`NumStabilityTest.Import.SharedVectorOperators` checks the legacy constructor,
record syntax, projections, dependent elimination and computability, the bridge
to bundled linear maps, the full unbundled operation domains, and inverse order.
It is imported by the regular test target.

The separately recorded native validation includes the complete production/test
build and the current Bhatia SVD/polar target as an additional affected consumer.
It is compilation evidence for changed shared code, not a rerun of source
faithfulness audits or mathematical acceptance. Previously accepted results and
their original proof/audit receipts remain accepted. Unit and repository-wide
organization completion and protected-main publication remain separate states.

The complete native build, `lake test`, architecture/layout, links, provenance
and placeholder checks passed. Warning comparison retained all 227 reviewed
warnings (explicit Linux architecture comparison); lint retained exactly 3,903
reviewed findings. Neither global diagnostic baseline changed.
