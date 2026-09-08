# Literal finite-vector density-capstone nonvacuity

This additive scratch witness closes the narrow type-applicability gap identified in the independent batch-9 review. It does not adopt the pending ordinary-density source interpretation, change any source claim, or modify either frozen capstone package. No canonical source, gate, audit, ledger or Git state was edited.

`Witness.lean.fragment` defines the state and production in **`Fin 1 → ℝ`**, exactly the `m = 0` instance of `ProspectiveSourceAlternatives.density_rectangle_capstone`. The explicit profile is vector-valued Riemann data with left and origin values zero and right value the all-ones vector. For an arbitrary signed real rate `r`, the state is `(r*t) • profile x`, the physical flux is zero, and production is `r • profile x`.

`balance` uses canonical `linearAmplitude_isRectangleBalanceLawSolution` with canonical `riemannData_intervalIntegrable`. Thus the actual fields satisfy every integrability and rectangle-balance premise of the exact prospective target; none is assumed for an abstract placeholder field. `profile_eq_scalar_smul` identifies the vector profile with the existing scalar step times a fixed vector. `source_integral` then reuses Mathlib `intervalIntegral.integral_smul_const` and canonical `riemannStep_signed_source_integral` to obtain

`∫ t in 1..2, ∫ x in 1..2, production r x t = r • unitState`.

`capstone_instance` directly invokes the **full frozen target** at `m := 0`. It preserves all rectangles, both conservation/source-contribution equivalences, and the temporal derivative almost everywhere for each fixed spatial interval. It does not replace those conclusions with a narrower example statement. `nonconservation` applies the target's own nonzero-rectangle equivalence to the computed source integral and obtains the obstruction for every `r ≠ 0`. `positive_and_negative_instances` checks rates `1` and `-1` and first-component rectangle contributions `1` and `-1` respectively.

The source-integral calculation is an ordinary signed production/depletion calculation, with no positivity restriction on `r`. This witness is not an assertion about singular production measures, a common exceptional null set for all intervals, source faithfulness, or adoption of the unanswered `call_uHJOZR8JifMR8TsqhW2IOTRX`. It supplies mathematical target-bound nonvacuity independently of that source-domain choice. No separate theorem about spatial discontinuity is needed or claimed here.

## Reuse and exact check

`reuse.json` records three scoped project/Mathlib searches with raw outputs and actual exits. The selected producers are the generic amplitude rectangle law, generic Riemann-profile integrability, existing signed scalar rectangle integral, and Mathlib's vector integral of a scalar multiple of a constant. A duplicate balance proof, duplicate scalar step integral proof and a scalar-only target witness were rejected. The search is not a global absence claim.

The checked `native-01.lean` consists of the complete frozen `Capstones.lean` bytes (SHA `dc65d2f7412a99594efbe8b0936ee59685d71e3fd8cd1ec3501cd73dd19a5ec7`), followed by this additive fragment and exact declaration/axiom checks. Keeping the complete frozen base means the witness invokes the actual checked target, rather than a copied claim with an invented proof assumption. The frozen capstone source itself is untouched.

The native command is `lake env lean native-01.lean` with the absolute input path recorded in `native-01.receipt.json`; actual exit **0** on the first attempt. Its exact source, raw output, command, runner, before/after source hashes and 21 canonical source/compiled dependency pairs are retained. Ten new declarations (four definitions, six theorems), five exact reuse checks and eleven frozen-base checks produce **26 axiom reports**. Every report uses only `propext`, `Classical.choice`, `Quot.sound`; there are no errors, warnings or `sorryAx`. No Lean failure occurred, and none was fabricated.

The original selected real-measure supplement, its native output/receipt and the independent batch-9 verification remain hash-bound inputs. They establish the same `Real.measureSpace` instance used by the frozen target and the standard real interval-length normalization. The immutable source PDF remains SHA `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`. Source ambiguity and previous audit decisions remain unchanged.
