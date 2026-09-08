# Variable-coefficient flux candidate and effective-domain concerns

Source printed 8/raw 30 says variable-coefficient hyperbolic equations may not
be in conservation form. It does not assert that every such equation lacks
every possible conservative reformulation.

Current canonical PDE and pinned Mathlib Calculus searches used
`flux.*constant`, `constant.*flux`, `variableCoefficient`,
`VariableCoefficient`, and `HasScalarStateOnlyFlux`. The existing
constant-linear-flux bridge requires a constant matrix and cannot simply be
applied to a spatially varying coefficient. Mathlib's
`HasDerivAt.unique`, Deriv/Basic.lean:396, is the selected new prerequisite;
the already resolved scalar-hyperbolicity producer supplies pointwise real
hyperbolicity.

The scratch candidate constructs the coefficient a(x)=x. Any state-only flux
whose derivative represents this coefficient at every independently supplied
space point and state would have derivative both zero and one at state zero,
contradicting uniqueness. This is a mathematical witness proposed by the
formalizer, not an example attributed to the source paragraph. It says nothing
about changing the conserved quantity or permitting an explicitly spatial
flux. A source audit must decide whether this precise operator interpretation
and witness are applicable to the source's qualified statement.

Separate pending effective-domain concern for later Riemann audits: the
integrated `IsIntegralConservationLawSolution` predicate requires a classical
time derivative for all intervals and times. A moving jump crossing a fixed
interval endpoint can produce a corner in interval mass. Before using a
certificate for that predicate as a Riemann solver premise, audit whether
the intended discontinuous solutions are admitted. Missing weak temporal
balance/trace foundations must be developed rather than hidden inside a
certified-solver assumption. This is a recorded concern, not a completed
counterexample or a new judgment on an audited row.
