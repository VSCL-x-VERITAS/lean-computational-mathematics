# Riemann problem-data repair

The scratch candidate replaces the arbitrary equation predicate with a concrete
first-order equation object:

`q_t + A(x,t,q) q_x = b(x,t,q)`.

The object stores its admissible state domain, the actual principal matrix
function, and its forcing. The residual is derived from these fields. Its
hyperbolicity condition requires a complete real eigenbasis for that same
principal matrix at every admissible state and space-time point. No unrelated
hyperbolic tag or arbitrary predicate on solution fields is accepted.

`InitialValueProblem` stores this governing equation and an independently
supplied initial field. The principal theorem characterizes the two-state
problem-data family using the spectral condition, admissible left/right
states, and precisely the strict half-lines `x < 0` and `0 < x`. The residual
characterization explicitly retains the equation expression. No solution
field, existence theorem, uniqueness theorem, time interval, classical
regularity, entropy convention, or generalized solution theory occurs in the
problem classification.

This addresses the frozen audit's missing-governing-equation finding without
restricting the full problem-data type to conservation laws. Space/time/state
dependent coefficients, explicit domains, and lower-order forcing remain
available. Constant systems and spatially varying linear systems embed
directly. The general normal form is the first-order quasilinear model under
consideration; no claim about every conceivable nonlinear PDE definition is
made.

## Primary-source reading

The exact PDF and frozen images of printed pages 1 and 3–6 were inspected.
Printed page 1 introduces one-dimensional first-order systems, a real vector
state, and partial-derivative notation. Printed page 3 limits the book's main
equation framework to first-order systems and describes conservation laws as
an important class of hyperbolic equations. Printed pages 4–5 distinguish
classical differential and integral descriptions in the presence of jumps.
Section 1.2.1 on printed page 5 defines the Riemann problem as the hyperbolic
equation with two-state initial data. Printed page 6 reiterates its inherently
one-dimensional nature.

The definition is about problem data. It does not require choosing a solution
framework merely to characterize those data. Conservation-law rectangle
semantics and classical PDE semantics are therefore kept as separate optional
relations, with exact bridges to existing canonical producers. Neither is
asserted to exhaust all solutions of the general problem.

## Equal-state boundary

The source prose says jump discontinuity, but its displayed (1.11) does not
require distinct side states. The scratch broad family (`IsRiemann`) allows
equal states; `IsJumpRiemann` separately requires unequal sides. Checked
constructors cover arbitrary origin values. Additional checked theorems show
equal-side data belong to the broad family and cannot be relabeled as a
distinct-side jump problem. This exposes the boundary rather than deciding
which family the source names Riemann problems.

No new user interpretation was requested or inferred. A fresh statement audit
must preserve this visible boundary. This draft does not retrospectively
change or accept the rejected task.

## Reuse and optional relations

- `IsRealHyperbolicMatrix`: exact existing real-eigenbasis criterion.
- `IsRiemannData`, `riemannData`, and its free-origin equivalence: exact reused
  strict-half-line initial-data semantics.
- `IsConstantCoefficientLinearSystemSolutionAt`: exact optional classical
  specialization of the new residual.
- `OneDimensionalHyperbolicConservationLaw`: useful conservation-law subclass,
  with its actual flux derivative and matching Jacobian. Its existing
  `HyperbolicRiemannProblem` embeds into the new problem-data object.
- `IsQuasilinearConservationLawSolutionAt` and
  `conservationLaw_iff_quasilinearAt`: exact optional classical conservation
  bridge, using the existing chain rule.
- `IsRectangleHyperbolicRiemannSolution`: retained as an explicitly separate
  conservation-law solution relation. The associated canonical linear
  eigensolution and certified solver were inspected; their solution/existence
  claims are not added to this definition row.

The old generic predicate constructor remains a valid generic initial-value
combinator, but does not supply the selected source's hyperbolic qualification.
Mathlib searches found no corresponding general hyperbolic-Riemann PDE
object. Its `GL(2)` discriminant hyperbolicity has a different mathematical
contract and was not substituted.

## Integration guidance

All declarations remain in scratch namespace `NumStability.RiemannInitialDraft`.
For production review, separate the equation object/residual and constant
specialization, the hyperbolic initial-value problem-data definitions, and the
conservation-law bridges into reusable modules. Only then add a thin Chapter 1
wrapper for the chosen problem-data characterization. Optional solution
relations need not enter the audited source-wrapper target.

The source-only ambiguity and frozen rejection remain separate evidence.
Compilation demonstrates that the stated draft types are inhabited; it is
not source-faithfulness acceptance.
