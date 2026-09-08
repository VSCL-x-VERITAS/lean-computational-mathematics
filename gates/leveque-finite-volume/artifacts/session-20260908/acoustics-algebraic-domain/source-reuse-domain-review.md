# Right acoustic mode: separate positive-ratio target

The draft is `AcousticsRightModeAlgebraic.lean`, intended for the new source leaf
`ComputationalMathematics/Source/LeVeque/Chapter01/AcousticsRightModeAlgebraic.lean`.
It adds only `NumStability.leveque01_acousticsRightMode_of_pos_ratio`. Production,
the old `AcousticsModes.lean`, the Equation 1.4 wrapper, and all prior audits are
unchanged. This is proof and scope evidence, not an independent source audit.

The selected source is the immutable LeVeque PDF with SHA-256
`b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`.
Printed page 1 / raw 23 supplies real space-time coordinates and genuine partial
derivatives. Printed page 2 / raw 24 gives the pressure--velocity equations and
the explicit right invariant `w = p + ρ c u`, with `c = sqrt(K/ρ)`, satisfying
the positive-speed one-way equation. Those renderings were inspected in this
work and the preceding Equation 1.4 task. Source and rendering hashes are bound
in the receipt.

The preserved right-mode decision and adjudicator were read in full. The final
decision hash matches `a6363aafd8ed62009ba884b91bcabc7d8af735da52d5894375a35344f8eecb28`.
The decision is nonaccepted and undetermined solely because the selected pages
do not settle whether individual positive material signs exhaust the source's
parameter domain. The adjudicator confirms the existing fields, equations,
derivative interpretation and nonvacuity. It does not establish a source defect
or physical admissibility of both-negative material parameters. This draft does
not alter that decision or assign itself a faithfulness classification.

The new theorem preserves the original given-system characteristic conclusion:
the actual `system.pressure` and `system.velocity` form the right invariant, and
that field satisfies the same pointwise PDE at every real `x,t`. It replaces the
two individual positivity premises with the single condition `0 < K/ρ`.
`Real.sqrt_pos` identifies this as precisely the algebraic condition for the
prescribed sound speed to be strictly positive. The existing system certificate
already carries `ρ ≠ 0` and all four needed coordinate derivatives, together
with both acoustic equations. The target adds no regularity restriction.

Fresh scoped searches over `ComputationalMathematics`, `NumStability`, and pinned
Mathlib preceded drafting. `reuse-searches.json` retains terms, roots, native
return codes and raw candidates. The proposed new wrapper name had no match;
the combined search also found the old private material-identity helper. That
helper and `leveque01_acousticsRightMode` require separate positive signs and
therefore do not directly provide the requested broader algebraic interface.
This is a contract mismatch for reuse, not a fault in their proved statements.

The selected producer is the source-independent
`linearAcousticsRightInvariant_isLinearAdvectionSolutionAt`. It needs only
nonzero density, the material identity `K = ρ*c²`, and the actual acoustic PDE.
The local material calculation uses `Real.sq_sqrt` on the positive ratio and
ordinary field cancellation. `Real.sqrt_pos` proves speed positivity. The
generic producer then supplies the full derivative and PDE conclusion. The
examined `mul_div_cancel_left₀` was an alternative elementary cancellation
lemma; the existing `field_simp` arithmetic sufficed. No derivative proof,
acoustic owner, or private helper was duplicated.

The new mathematical domain includes positive and both-negative parameter
pairs having positive ratio, while excluding zero or negative ratio. This is
an algebraic-domain statement. It does not assert that negative density or
negative bulk modulus describes a physical material or belongs to the book's
intended physical parameter set. No empirical, nonlinear-model, uniqueness,
initial-value existence, or weak-solution claim is added.

The native scratch check imports only the existing canonical reusable acoustic
owner, the existing Equation 1.4 residual wrapper, and Mathlib's square-root
owner. Exact declaration and axiom checks cover the new theorem and selected
generic/square-root producers. The final receipt records actual native exits
and frozen LF draft hashes. Root owns production placement, canonical builds,
source auditing and gate decisions.
