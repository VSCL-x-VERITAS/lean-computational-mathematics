# Internal production versus boundary transport

The independent source inventory review identified the source-term statement
on printed page 4/raw page 26 as actionable. The candidate distinguishes
internal production from the net incoming physical boundary flux. A change
in interval mass alone is not treated as a source term.

Current project and pinned Mathlib searches used `IsBalanceLaw`, `balanceLaw`,
`internalProduction`, `sourceTerm.*[Pp][Dd][Ee]`, `source.?[Tt]erm`,
`balance.*(source|defect)`, and `flux.*(defect|production)`. Existing
`IntegralConservationLaw.lean` supplies the interval/differential setting and
the finite-volume local-flux module supplies discrete boundary cancellation.
The latter is not a continuous internal-production theorem. No compatible
balance-law source predicate or production-defect theorem was selected from
these searches; this is not evidence of global semantic absence.

The selected Mathlib primitives are `HasDerivAt.unique`,
`intervalIntegral.integral_add`,
`intervalIntegral.integral_eq_sub_of_hasDerivAt`, and additive-group
identities. They prove that the integral of q_t plus the spatial flux
derivative equals the measured mass rate minus net boundary inflow. If that
defect is nonzero, the constructed production field is nonzero and the
homogeneous conservation law cannot hold at every point. The new balance
predicate exposes both actual derivatives and the production residual.

The regularity assumptions and differentiation-under-the-integral premise
are explicit classical hypotheses. This candidate does not prescribe a
reaction model, a constitutive source function, or a time integration method.
An independent audit must judge whether this is an applicable formal
realization of the introductory necessity statement, and whether a separate
source-level wrapper or applicability witness is required.

Native `lake env lean gates/leveque-finite-volume/artifacts/session-20260908/source-term-candidate.lean`
exited 0 after the final addition of the homogeneous-law exclusion. The three
printed axiom closures contain only propext, Classical.choice and Quot.sound.
`source-term-output.txt` is the final output; the prior successful two-lemma
version is retained in `source-term-foundation-output.txt`. No source row is
closed by this scratch proof.
