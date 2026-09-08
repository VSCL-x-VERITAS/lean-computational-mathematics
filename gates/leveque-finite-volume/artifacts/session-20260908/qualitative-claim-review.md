# Remaining qualitative Chapter 1 claims

The root coordinator reread the extracted text alongside the previously inspected
rendered pages. The source remains the pinned PDF, SHA-256
`b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`.
These are inventory judgments for independent coverage review, not completed
theorem audits. No row is closed by this document.

| Row | Source context and proposed treatment |
| --- | --- |
| NONCONSERVATION-SOURCE-TERMS | Printed 4/raw 26 discusses reactions and points to Section 2.5 and Chapter 17. The local passage does not supply a source-rate field, balance equation, or a formal criterion for mass creation distinct from boundary flow. Record as an underspecified modeling remark unless a source-specific contract can be independently recovered. Do not equate total mass change with creation: boundary flux already changes interval mass in (1.10). |
| SHOCKS-AND-NONLINEARITY | Printed 7/raw 29 contrasts smooth small-amplitude waves with shock formation. The statement concerns appearance from nonlinear phenomena, not a ban on prescribed discontinuous initial data in a linear equation. A universal smoothness theorem would require coefficient regularity, initial-data regularity, a solution class, and a time domain; those are not fixed here. Proposed underspecified remark; preserve that interpretive limitation. |
| TYPICAL-SECOND-ORDER-ACCURACY | Printed 7/raw 29 expressly says “typically” and discusses suitability and cost over many wavelengths. No method class, error norm, mesh limit, or bound is specified. Proposed underspecified qualitative comparison; a universal order barrier would add a claim. |
| VARIABLE-COEFFICIENT-NONCONSERVATION | Printed 8/raw 30 says equations may not **be in** conservation form, not that no conservation formulation can exist after transformation. Correct that inventory paraphrase. A possible mathematical witness is the spatial product-rule residual separating a variable-coefficient transport expression from the divergence of coefficient times state. This is a candidate construction requiring its own source-contract audit, not an accepted interpretation. |

Reuse searches during this review covered the entire current canonical library
and pinned Mathlib, followed by narrower PDE searches. Terms included
`one.?step`, `variable.?coefficient`, `nonconserv`, `source.?term`,
`principal.?part`, `parabolic`, `discriminant`, `OneStep`,
`IsHyperbolic`, `SecondOrder`, and `PrincipalSymbol`. The initial whole-library
output was overly broad (linear algebra and probability matches) and was narrowed.
Two guessed paths, `NumericalAnalysis` and `Algorithms/FiniteVolume`, did not
exist; the actual reusable finite-volume family is under
`Analysis/PartialDifferentialEquations/FiniteVolume`.

The inspected PDE family supplies constant-coefficient transport, conservation
laws, integral balances, acoustics, eigenmode waves, finite-volume grids and
updates, and operator splitting. The searched Mathlib hyperbolicity predicate is
for a two-by-two matrix discriminant, not a general second-order PDE principal
part. Mathlib one-step matches concern unrelated computation and order relations.
These scoped findings identify further work; they do not establish semantic
absence from the full library.
