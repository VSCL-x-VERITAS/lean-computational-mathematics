# Local Riemann information: concrete applicability

This is a scratch mathematical witness for the frozen canonical `NumStability.LocalRiemannInformation` API. It is not a source wrapper, source-faithfulness decision, selected accuracy tolerance, or a replacement for any historical audit. No production source, gate, ledger, Git state, released helper, or model audit was changed or invoked.

The law is unit-speed scalar transport on the proper admissible state subset `0 ≤ u ≤ 1`. The states zero and one are admitted; two is excluded. The ambient flux is the existing identity flux, whose existing hyperbolicity certificate is restricted to that set. This particular total flux also happens to be hyperbolic outside the set; the witness does not claim otherwise or require that fact in the new law's contract.

The method admits positive horizons at most one. A duration-one nonconstant problem is admitted and a duration-two problem is not. This deliberately illustrates a proper method domain; the cutoff is a fixture choice, not a time-step restriction inferred from the book.

The result is precisely the existing `LeftStateInformationFlux.OrderedResult` at the problem with the same ordered states. It stores two vectors and their equality facts, not a space-time field. The selected solve reuses the existing information-only solver. Extraction returns the actual selected pair. The physical reference is the existing *translating* unit-speed Riemann reference from `StationaryRiemannField.reference`; it is not that module's intentionally inexact `stationary` field. Existing initial-data and rectangle-conservation producers provide its certificate, restricted to the selected slab. Its values are always one of the two input states, so it stays in the proper admissible subset.

For a parameter θ, the numerical flux is `L + θ • (R - L)`. The proof derives its actual error from the existing exact reference-average identity:

`‖numericalFlux - referenceMean‖ = |θ| * ‖R - L‖`.

The right-hand side is stored as the method's error bound and its `accurate` field is proved. Constant inputs have zero jump and recover the physical constant flux for every θ. For the actual input `(L,R)=(0,1)` and duration one:

- θ = 0 returns information `(0,1)`, flux zero, and error zero.
- θ = 1/2 returns the same information, flux one-half, and actual error one-half. A separate theorem proves that this flux differs from the reference mean.

The half-jump rule is an illustrative approximate flux. No convergence, order, entropy property, stability region, selected source tolerance, or numerical usefulness follows from this witness. The abstract core's existential weak-reference choice is unchanged; here a particular pre-existing reference is supplied explicitly.

## Reuse and rejected alternatives

The exact scoped commands and outputs are in `reuse-search/receipt.json` and its four outputs. Earlier interactive navigation also found no file at the guessed Mathlib `Analysis/Normed/Group/Pi.lean` path; the actual constant-function norm producer is in `Group/Constructions.lean`. This documented path miss is not a library-absence claim.

- `hyperbolicConservationLaw_isHyperbolicFluxAt` supplies the local ambient derivative/eigenstructure certificate. A new derivative proof was unnecessary.
- `LeftStateInformationFlux.OrderedResult` and `method.solve` preserve the existing two-value result and ordering. No duplicate nominal output structure was introduced.
- `StationaryRiemannField.reference_initial` and `reference_rectangle` supply the same-problem exact reference. Rebuilding the transport integral proof or the linear eigenbasis solver was unnecessary.
- `LeftStateInformationFlux.selected_flux_eq_reference_average` supplies the physical mean. No new time-integral evaluation was needed.
- Mathlib `norm_smul`, `pi_norm_const`, and elementary module simplification provide the quantitative calculation. No custom norm or integration definition was introduced.

## Evidence limits and replay

Run `python.exe -B run.py native-NN` from this directory using the prepared native Python. Each label must be new. The runner verifies the frozen canonical core SHA, exclusively creates a fresh attempt folder, preserves the complete Lean input, records the actual native Lake command/output/exit, and hashes selected source and compiled dependencies before and after. It invokes no Git command. These are selected relevant dependency bindings, not an independent reconstruction of the whole transitive Mathlib closure.

The first attempt is intentionally retained with its actual nonzero exit: the generic certificate and exact fixture elaborated, but the concrete half-jump theorem needed an explicit pointwise scalar-action simplification. Its error-induced `sorryAx` reports are failed evidence and are never counted as successful checks. The final receipt names the actual successful attempt and validates every authored declaration's reported axioms. No hand-written `sorry` or additional axiom is present in the final source.

The underlying Chapter 1 source and recorded coordinator-selected interpretations remain owned by the parent task. This packet adds mathematical applicability evidence only and does not read or reuse any live source-audit judgment.
