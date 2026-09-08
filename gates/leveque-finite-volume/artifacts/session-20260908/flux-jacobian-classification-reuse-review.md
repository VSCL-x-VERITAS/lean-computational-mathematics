# Pointwise flux-Jacobian classification prerequisite

The independent inventory review reopened the definition/criterion on printed
page 3/raw page 25. The candidate exposes a genuine Fréchet derivative of the
independently supplied flux at the selected state, and classifies its standard
coordinate matrix by the existing real eigenbasis predicate. Derivative
uniqueness removes the choice of derivative. It proves equivalence to a full
independent family of real eigenvectors with real eigenvalues; distinct
eigenvalues and well-posedness are absent. A domain predicate simply requires
the pointwise criterion at each explicitly admissible state.

Current canonical and pinned Mathlib searches used `fluxJacobian`,
`jacobian_hyperbolic`, `toMatrix.*mulVec`, `mulVec.*toMatrix`,
`ext.*mulVec`, and the exact existing hyperbolicity names. The global
`OneDimensionalHyperbolicConservationLaw` structure already stores the actual
derivative, its matrix representation, and its hyperbolicity. It is not
redefined. A compatibility lemma derives the local predicate from that
existing global structure. The new predicate serves independent local/domain
classification without manufacturing a bundled global law as a premise.

Selected producers are the integrated
`isRealHyperbolicMatrix_iff_independent_real_eigenvectors`,
`HasFDerivAt.unique`, `LinearMap.toMatrix'_mulVec`, and
`Matrix.ext_iff_mulVec`. The general matrix basis proof is reused directly;
no new eigenbasis construction is introduced. These scoped searches do not
prove global semantic absence.

The two classification theorems elaborated with native exit 0 and allowed
axioms; their precursor output is `flux-jacobian-classification-foundation-output.txt`.
The final file adds the existing-law compatibility lemma, with its final
elaboration recorded separately in `flux-jacobian-classification-output.txt`.
Production placement and a sealed independent source audit remain actionable.

The final three-theorem run, including that compatibility lemma, also exited
0 with only propext, Classical.choice, and Quot.sound in all printed closures.
