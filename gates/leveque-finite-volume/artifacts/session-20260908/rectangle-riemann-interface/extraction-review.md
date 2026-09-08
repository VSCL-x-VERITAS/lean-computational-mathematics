# Rectangle-certified Riemann interface extraction

This bounded implementation provides a separate certificate for discontinuous
local Riemann solutions. It preserves the existing generic interface and source
wrapper files. The selected Chapter 1 locator is printed page 5 / raw PDF page 27,
following equation (1.11); the pinned PDF SHA-256 is
`b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`.
This is an implementation and scope review, not an independent source audit or a
chapter gate claim.

## Mathematical contract

`IsRectangleHyperbolicRiemannSolution` combines the ordered `IsRiemannData` initial
trace with the shared `IsRectangleConservationLawSolution`. The latter includes
spatial state integrability, temporal boundary-flux integrability, and conservation
on every oriented space-time rectangle. It is not the classical cell-mass
derivative predicate used by the preserved old interface owner.

`RectangleRiemannInterfaceFluxMethod` specifies its solver domain explicitly.
The generic workflow requires domain membership for the ordered pairs obtained
from the actual `finiteVolumeCellAverageOn` values. It constructs normalized cell
averages, ordered certified solutions, extracted information, numerical fluxes,
and the existing `riemannFiniteVolumeUpdate`. Constant problems belong to the
domain, and their extracted flux equals the physical flux.

`linearHyperbolicConservationLaw` supplies an actual continuous-linear-map flux
derivative and matrix Jacobian. The concrete method uses the independently
checked eigenbasis `linearRiemannSolution` on all ordered state pairs, takes its
actual value at `(x,t)=(0,1)` as information, and applies the physical matrix flux.
The constant-data lemma proves constant consistency. Positive-time ray-zero
self-similarity proves that the information agrees with the same solution on
the interface ray at every positive time. The total-domain existence theorem
constructs an actual method from the real hyperbolic eigenbasis, so the new
method contract is not justified by assuming its desired conservation property.

The source wrapper retains positive dimension and a positive time step, exposes
the solver-domain hypothesis, and proves the full workflow by the reusable
producer. The wrapper does not universally assert nonlinear Riemann solvability.

## Reuse and rejected candidates

Fresh scoped `rg` searches, exact paths, return codes and raw matches are in
`reuse-searches.json`. They searched the current canonical library, compatibility
tree, and pinned Mathlib. The absence of name matches is only a scoped search
result, not a global semantic-absence claim.

- Reused `OneDimensionalFiniteVolumeGrid`, `finiteVolumeCellAverageOn`, its `_spec`
  theorem, `OneDimensionalHyperbolicConservationLaw`, `HyperbolicRiemannProblem`,
  `adjacentCellRiemannProblem`, and `riemannFiniteVolumeUpdate` from the preserved
  `FiniteVolume/RiemannInterface.lean` owner.
- Reused `IsRiemannData` and `riemannData_isRiemannData` for the initial trace.
- Reused the shared `ConservationLaws/Rectangle.lean` predicate without copying
  its prelude, integrability conditions, or rectangle proof.
- Reused `linearRiemannSolution_isRectangleSolution`,
  `linearRiemannSolution_initial`, and `linearRiemannSolution_rayZero` from the
  checked `FiniteVolume/LinearRiemannSolution.lean` producer.
- Reused Mathlib's `Matrix.toLin'`, `LinearMap.toContinuousLinearMap`,
  `ContinuousLinearMap.hasFDerivAt`, and basis reconstruction. The finite
  dimensional continuous-linear-map conversion needs local `classical` for
  matrix indexing; its first missing-instance elaboration failure was repaired.
- Rejected the old `CertifiedHyperbolicRiemannSolution` and
  `RiemannInterfaceFluxMethod` as producers for this certificate because their
  law is a classical mass derivative at every time. The previously checked
  moving-step counterexample shows why no unproved conversion is assumed.
- No existing exact new method or linear-law-constructor declaration was found
  by the recorded scoped searches. The constant reconstruction lemma is a small
  bridge from the existing eigenbasis producer, not a second Riemann solver.

## Organization and explicit limits

The three proposed leaves are the approved existing finite-volume sibling family
and a thin Chapter 1 source wrapper, with 132, 111 and 65 lines respectively.
They keep namespace `NumStability`; no reusable module imports a source wrapper.
`canonical-drafts-manifest.json` records the exact intended paths, LF bytes,
hashes, and 14 authored declaration names. Structure fields are elaborated as
part of their owning structure declarations. Parent controls final placement,
aggregate imports, tier metadata, source audits, gates and integration.

The law structure still assumes a globally differentiable flux with a real
hyperbolic Jacobian at every state; the explicit solver domain is a domain of
ordered problems, not a newly formalized physical state-space restriction.
The linear method chooses the left state as the initial origin representative.
Local Riemann coordinates put each grid interface at zero. No theorem says the
independent local fields glue into a global exact solution. Constant consistency
does not give an approximation-error estimate. No CFL, positivity preservation,
stability, convergence, full entropy inequality, uniqueness, or classical
cell-mass derivative at every time is asserted.

## Verification evidence

`first-elaboration.txt` / `first-exit.json` preserve the missing classical-instance
failure. `second-failed-candidate.lean`, `second-elaboration.txt` and
`second-exit.json` preserve the source-wrapper parenthesis failure. Neither failed
run is accepted proof evidence, including any recovery-generated `sorryAx` in
its output. A successful full run and the final hash receipt are recorded
separately. Exact canonical-import builds must be run after coordinated placement;
the combined candidate check alone is not presented as those import checks.

The two preserved existing owners are hashed in `preserved-owners.json` and are
rechecked in the final receipt. Earlier Huber source and all its frozen evidence
remain unchanged by this task.
