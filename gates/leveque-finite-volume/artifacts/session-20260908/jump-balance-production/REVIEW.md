# Generic jump and rectangle-balance placement

Six new canonical leaves contain 24 public declarations, copied from the two exact reviewed drafts. No existing canonical owner, source wrapper, aggregate, tier, gate, ledger, audit, or Git state was edited by this placement. Source interpretations remain pending; this is not a faithfulness result.

| Leaf | Public declarations | Dependency boundary |
| --- | ---: | --- |
| `ComputationalMathematics.Topology.Order.Jump` | 4 | Mathlib topology only; no PDE imports |
| `ComputationalMathematics.Analysis.PartialDifferentialEquations.FiniteVolume.RiemannDataJump` | 1 | Existing Riemann traces plus generic jump |
| `ComputationalMathematics.Analysis.PartialDifferentialEquations.InitialValue.Examples.LocalMaterialInterface` | 5 | Varying medium and product counterexamples |
| `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RectangleBalance` | 7 | Existing rectangle conservation only |
| `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.RectangleBalanceTemporalDerivative` | 1 | Rectangle balance plus existing finite-vector interval-integral differentiation |
| `ComputationalMathematics.Analysis.PartialDifferentialEquations.ConservationLaws.Examples.LinearProduction` | 6 | Production examples, existing balance residual and Riemann integrability/regularity |

The public namespace remains `NumStability`. Interface examples use its `LocalMaterialInterface` namespace. `comparison-inputs.json` is the exact old/new declaration map. No compatibility aliases are needed for the scratch-only namespaces: the frozen drafts remain untouched as evidence, and no existing public declaration is moved or renamed.

The topology predicate and its two basic lemmas are unchanged after namespace relocation. The former material/state predicate is omitted: its two-jump conjunction is explicit in the product-trace equivalence and examples. Both component inequalities remain required. The Riemann bridge is named `IsRiemannData.hasJumpAt`; it reuses the existing one-sided limits. The omitted discontinuity and pair wrappers are reconstructed from these producers in the comparison file. The pending local-medium source-shaped bundle is likewise checked only in comparison evidence, not placed as a source certificate.

Rectangle balance retains every original quantifier, oriented bounded-rectangle identity, spatial source-integrability premise, and time-integrability premise. The zero-source equivalence is named `isRectangleBalanceLawSolution_zero_iff`. The a.e. derivative still applies to finite real vectors with an exceptional set that may depend on the fixed spatial interval.

The production examples use `linearAmplitude_isRectangleBalanceLawSolution`, `linearAmplitude_hasDerivAt_mass`, and `linearAmplitude_isBalanceLawSolutionAt`. The last name identifies the existing conservative residual precisely; it does not add a spatial state derivative. The stationary-step alias and its integrability alias are eliminated in favor of `riemannData 0 0 1` and `riemannData_intervalIntegrable`. The signed source integral and nonsmooth nonvacuity statements remain unchanged after unfolding.

Reuse searches are recorded with real stdout/stderr and exit codes. The existing trace, Riemann-integrability, rectangle, balance-residual, and finite-vector differentiation producers are reused. Mathlib supplies filter congruence, product limits, uniqueness of limits, interval-integral linearity and scalar Lebesgue differentiation. The scoped Mathlib jump-predicate search returned no matches (exit 1); this is not an assertion of exhaustive semantic absence.

Validation:

- Focused native six-target Lake build: exit 0, empty output, 58.5 seconds.
- Canonical-only imports: 24 exact declaration/axiom checks, exit 0.
- Frozen draft comparison: 24 identities by `rfl`, plus 6 explicit omitted-alias reconstructions, exit 0.
- Every reported axiom is among `propext`, `Classical.choice`, and `Quot.sound`; no Lean warnings or errors.
- The 24 identities establish definitional equality of definitions and theorem types; proof equality uses Lean proof irrelevance. They do not assert identical proof-expression syntax or full normalization fingerprints.
- All six leaves are LF-only with sorted direct imports. Existing selected owners and both frozen draft bytes were rehashed unchanged.

The first metadata freeze mistakenly scanned prose for the Lean token `admit`, matching the sentence “profiles admit linear growth.” Its actual failed output, helper snapshot, and exit are retained as `freeze01-*`. The metadata checker was corrected to scan code outside block comments. `freeze02-*` records the successful freeze. No Lean source edit or native rerun was needed for this capture correction; all three native runs passed on their first attempts.

`placement-manifest.json` binds canonical source and compiled files, direct source/compiled dependencies, native receipts, comparisons, reuse searches, frozen drafts, and unchanged old owners. Root owns aggregate exposure, tier classification, organization, source interpretation, fresh source audits, gate rebinding and Git commits. None is implied by this generic placement.
