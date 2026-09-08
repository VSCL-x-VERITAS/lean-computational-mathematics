# Equation (1.1): candidate selection, not acceptance

The independently reviewed inventory requires coverage of defining PDE forms,
not just standalone existence theorems. For equation (1.1), the integrated
canonical module contains both a definitional correspondence theorem and a
theorem projecting a proof-carrying solution. They are different candidates.

The historical `LEV-CH01-EQ-1.1-CONSTANT-LINEAR-SYSTEM` decision rejected the
projection `leveque01_equation01_constantLinearSystem`: its input already
contains the complete global equation that its conclusion returns. That
rejection is preserved and the projection is not selected for reuse.

The current candidate
`NumStability.leveque01_equation01_constantLinearSystemAt_iff` quantifies an
independently supplied real vector field, a real square matrix, and a point.
It relates the defined pointwise solution predicate to existence of the two
slice derivatives with zero residual. It does not assume a proof-carrying
solution or assert existence of a PDE solution. This is proposed solely as
definition correspondence, not as an existence or universal-satisfaction claim.

Current-tree source inspection found this candidate and its reusable predicate
in `ConstantCoefficientLinearSystem.lean`; both are integrated baseline assets.
The module has already compiled as a dependency of the focused hyperbolicity
build. No theorem or proof was written or altered to prepare this candidate.

A new canonical-path task will independently decide whether this definitional
proposition captures the selected source object. A tautology alone cannot
establish correspondence: the full imported predicate body, dimensions,
quantifiers, derivative interpretation and source defining context must be
audited. Historical rejection of any earlier definitional candidate remains
relevant evidence for the coordinator; fresh isolated judges receive only
their prescribed primary evidence. If this representation is rejected, retain
the row as actionable and record the precise representational obstruction.
