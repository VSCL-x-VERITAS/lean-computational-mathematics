# General scalar-equation decoupling prerequisite

The source on printed page 3/raw page 25 says that the general hyperbolic
system decomposes into scalar waves. The current unique-vector-decomposition
row supplies algebraic coordinates; the existing eigenmode wave-speed row
only verifies individual translated modes. Neither result alone states the
coordinate-PDE equivalence for arbitrary fields.

Current-tree searches used `equivFun.*toContinuousLinearEquiv`,
`toContinuousLinearEquiv.*equivFun`, `equivFun.*mulVec`, `mulVec.*equivFun`,
`mulVec_sum`, `mulVec_smul`, `hasDerivAt_pi`, `comp_hasDerivAt`,
`equivFun_symm_apply`, and `sum_repr` across the canonical library and pinned
Mathlib. The selected producers are `Module.Basis.sum_equivFun`,
`Module.Basis.equivFun_symm_apply`, the matrix sum/scalar-action identities,
finite-dimensional `LinearEquiv.toContinuousLinearEquiv`,
`ContinuousLinearMap.hasFDerivAt`, `HasFDerivAt.comp_hasDerivAt`, and
`hasDerivAt_pi`. No compatible general coordinate-PDE equivalence was selected
from those searches; this does not prove global semantic absence.

The new scratch algebra lemma identifies matrix action in eigenbasis
coordinates with coordinatewise multiplication by the eigenvalues. The
classical theorem transports both slice derivatives through the continuous
coordinate equivalence and its inverse. It proves an iff for independently
supplied q, x and t, not a projection from a bundled solution. The proposed
source wrapper obtains a single eigenbasis from hyperbolicity before
quantifying all fields and points. Zero and repeated eigenvalues are allowed.
No differentiability assumption is silently added outside the existing local
classical solution predicates.

Native `lake env lean gates/leveque-finite-volume/artifacts/session-20260908/eigenbasis-decoupling-candidate.lean`
exited 0. All three printed public scratch closures use only propext,
Classical.choice and Quot.sound. The final output is
`eigenbasis-decoupling-output.txt`; the successful two-lemma precursor is
retained as `eigenbasis-decoupling-foundation-output.txt`. The failed initial
coercion simplification is retained separately in `eigenbasis-decoupling-first-output.txt`
and is not successful proof evidence.

Production placement and an independent audit of the newly inventoried source
claim remain. The Riemann construction independently uses matrix linearity to
sum eigenmodes; it does not duplicate this coordinate-action or classical iff.
