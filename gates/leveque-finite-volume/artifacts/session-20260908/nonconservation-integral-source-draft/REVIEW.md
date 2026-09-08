# Integral production scratch repair

The frozen NONCONSERVATION-SOURCE-TERMS audit is preserved. Its exact decision
`c48f5b9e8e6121f618e8f54292a56c4f7f3daad9df513794a904bdfb2abaefe3`
found reduced applicability from global spatial derivatives and interchange
assumptions, an unresolved measure-evidence boundary, and missing explicit
finite-mass slice integrability. The current draft addresses the mathematical
applicability and finite-mass issues; it does not declare a new audit accepted.

## Primary source

The actual rendered raw PDF page 26 (printed page 4), the task's exact locator,
was read visually, together with raw page 27 (printed page 5) for its immediately
adjacent discontinuity explanation. The pinned PDF SHA is
`b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`.
Equation (1.10) represents mass rate by boundary inflow minus outflow. The
contaminant example gives scalar flux `speed * q`, then says internal reactions
or other mass nonconservation require source terms. The next passage distinguishes
the smooth differential representation from integral applicability at jumps.
Neither the selected passage nor this scratch task supplies a chemical rate
law, source sign, exhaustive admissible model class, or precise temporal
interpretation of all nonsmooth mass-rate statements.

## Mathematical contract

`IsRectangleBalanceLawSolution q flux production` records:

- Integrability of the state on each bounded spatial interval at every time.
- Integrability of each endpoint flux on bounded time intervals.
- Spatial interval integrability of the production density at every time.
- Time integrability of each spatially integrated production density.
- Actual mass difference equals integrated left-minus-right boundary flux plus
  the time integral of the spatial source integral, for every oriented rectangle.

All these integrals use the selected real `volume` instance. No spatial
derivatives, differentiation-under-the-integral premise, global integrability
on the whole line, source sign, convergence assumption, or constitutive model
is imposed. The generic balance and equivalence statements permit any real
normed vector space; the a.e. derivative result uses finite real vectors and
the explicit constructed-amplitude family uses a complete space.

Given this actual balance relation, homogeneous rectangle conservation is
equivalent to zero integrated production on every rectangle. Its failure is
equivalent to an existential rectangle with a nonzero integrated contribution.
For every rectangle that contribution equals mass change minus boundary
exchange. Any two production densities realizing the same actual q/flux fields
therefore have equal rectangle integrals. Pointwise uniqueness or pointwise
vanishing is deliberately not asserted: isolated values do not represent net
production.

The zero-density specialization is exactly equivalent to the existing
`IsRectangleConservationLawSolution`, including its integrability obligations.
For finite real vectors the mass derivative equals endpoint transport plus
the spatial source integral almost everywhere in time on each fixed spatial
interval; its exceptional null set may depend on that interval. This is a
proved consequence of the chosen rectangle relation, not an interpretation
silently attributed to the source.

## Concrete nonsmooth witness

For every locally integrable profile p and every real rate r,
`q(x,t) = (r*t) * p(x)`, zero flux, and `production(x,t) = r*p(x)` satisfy the
rectangle balance. The arbitrary real r permits production and depletion.
The profile need not be spatially differentiable. For the stationary step
`p = riemannData 0 0 1`, the state at positive time 1 is discontinuous at x=0.
Its mass on every bounded spatial interval has an ordinary derivative at
every time, equal to that interval's production integral. The production
contribution on `[1,2] x [1,2]` is exactly 1 when r=1, and exactly r in general.
The unit-production field fails homogeneous rectangle conservation.

The constructed family also has an exact bridge to the existing
`IsBalanceLawSolutionAt` relation for finite real vectors: its temporal state
derivative is r*p and its actual zero flux has zero spatial derivative.
This optional bridge does not require spatial differentiability of p and is
not used as an assumption of the integral necessity theorem. The generic
mass-derivative lemma is an algebraic statement about the total integral;
physical finite mass in the advertised witness is guaranteed separately by
the proved profile integrability and rectangle relation.

## Reuse

Current-tree and pinned Mathlib searches are recorded with raw outputs in
`reuse-search.json`. The existing classical `BalanceLaw.lean` supplies the
source-term relation and earlier conditional residual theorems. They remain
correct for their stated domain, but cannot supply integral applicability at
spatial jumps through the old target's qx premises. The existing rectangle
definition is reused unchanged. Mathlib interval-integral additivity,
scalar multiplication, constant integrals, and interval congruence supply the
new algebra. Existing `riemannData_intervalIntegrable` and the strict-trace
discontinuity theorem supply the nonsmooth example; the existing finite-vector
Lebesgue differentiation producer supplies the a.e. derivative result. Searches
found no existing exact rectangle balance-with-production predicate in the
searched current tree or pinned Mathlib; this is not a global absence claim.

## Integration and remaining scope

All mathematics is in scratch namespace `NumStability.IntegralSourceDraft`.
Separate reusable balance definitions/equivalences, temporal derivative support,
and example producers before production placement. The independent
`SourceWrapperProposal.lean.fragment` is a thin scalar-advection specialization;
`run-check.py` concatenates its exact bytes after the generic draft and checks
that combined file, with raw input, actual exit, hashes, and axiom output.
It is a proposal fragment, not a standalone importable production file.

The source's full admissible nonconservative-model domain is not resolved here.
The new predicate explicitly selects bounded-interval integrable source
densities and rectangle balance. It does not establish that every arbitrary
mass defect has such a density, cover singular production measures, or choose
an exhaustive physical model class. Applying the rectangle convention to this
separate source row has not been authorized by an inferred earlier user choice.
The primary source facts and these explicit mathematical assumptions must
remain separate in a fresh task and independent statement audit. The previously
compiled native real-measure/normalization supplement is available for a future
hash-bound audit packet; this scratch work does not relabel the old evidence
gap as resolved within its sealed packet.

Every native attempt is retained. Only a final exit-zero input with all named
axiom lists restricted to `propext`, `Classical.choice`, and `Quot.sound` is
accepted as the compiled scratch handoff. No source, production, gate, ledger,
audit, Git index, or commit mutation is part of this work.
