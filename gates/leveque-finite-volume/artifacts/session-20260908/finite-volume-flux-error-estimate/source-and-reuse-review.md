# Conditional finite-volume estimates and actual linear-solver flux linkage

This is a new scratch-only extension of the frozen `finite-volume-flux-update-repair` result. It does not choose a quantitative source interpretation, change a canonical file, or assert source acceptance. The prior draft, receipt, and all prior evidence are preserved and rehashed unchanged.

## What is proved

`estimate-fragment.lean` contains four new theorems. Its generic norm lemma bounds the result of a weighted balance using the old error and the two face errors. Applied to the independently checked rectangle-derived identity, it proves

`‖Qnew_i - A_i(t)‖ ≤ ε_i + (t-s)/width_i · (δ_left + δ_right)`

from `‖Qold_i-A_i(s)‖ ≤ ε_i` and upper bounds on the numerical-minus-physical **time-averaged** flux errors at the two faces. The conclusion about the new array is not a premise. Positivity comes from the actual grid width and `s<t`. The old and face bounds remain arbitrary quantified real numbers satisfying the stated input inequalities; no numerical tolerance or convergence order is selected.

The block theorem bounds the **norm of total mass error** by the sum of width-weighted old cell error bounds plus the duration times the two exterior face error bounds. It uses the frozen block identity, the finite-sum norm inequality, and the same weighted-balance lemma. It is not a bound on the sum of absolute new cell errors; interior errors can cancel in total mass.

The fourth theorem says that an upper bound on the norm of the difference of two integrable time traces implies the same bound on the difference of their normalized time averages. It reuses Mathlib's integral norm estimate. The helper explicitly uses complete real normed spaces; the finite-volume application uses the complete real finite-vector space.

## Actual Riemann solver linkage

`solver-link-fragment.lean` contains eight new declarations. They use the integrated explicit eigenbasis solver for a real hyperbolic matrix `A`.

`selectedLinearSolve` is exactly the particular call to the existing method's `solve`, not an existentially chosen alternative solution. `selectedLinearFlux` is exactly `numericalFluxFromInformation (extractInformation (method.solve ...))`. The existing positive-time ray-zero information theorem proves that this flux is `A.mulVec` of that returned solution at every positive time. Interval integration then proves exact equality with the time-average of the physical matrix flux of the same solver over `[0,dt]`, for every `dt>0` and every ordered pair of states, including unequal states. The origin-time value need not equal the positive-time trace; the integral proof uses equality on `(0,dt]` rather than asserting equality at zero.

`linearRule` feeds the numerical array's correctly ordered adjacent states into this selected method. A checked definitional bridge identifies it with the existing `rectangleRiemannInterfaceFlux` API. No arbitrary unequal-state information-to-flux function is inserted. This is a substantive physical-flux linkage for the available linear solver, rather than constant-state consistency alone.

An independent global exact field is a different object. `linearRule_flux_error_le` therefore accepts a **trace error** bound between the selected local solver's physical matrix flux and the global field's physical flux at the actual grid face, and derives the averaged numerical-flux error bound. `linearRule_next_error_bound` combines those derived face estimates with an old numerical error bound to prove the next numerical cell-average error estimate. This is an explicit chain from solver trace comparison to averaged flux error to update error.

The global comparison is conditional: no domain-of-dependence, CFL noninteraction, stability, or convergence theorem is assumed to follow from the two separate conservation certificates. The linear solver statements use elapsed time from zero to `dt`; the general numerical-update estimate supports arbitrary `s<t`. No time-translation theorem for the solver comparison is silently asserted.

## Source and frozen audit

Source facts come only from the selected LeVeque PDF, SHA-256 `b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`. The full renderings were actually viewed earlier in this conversation and are rehashed here:

- Printed 4 / raw 26: Eq. (1.10), physical exchange through both endpoints, and the integral/classical discussion.
- Printed 5 / raw 27: Section 1.2 describes numerical edge fluxes approximating the physical flux using approximate cell averages; following Eq. (1.11), the Riemann solution provides information used to compute a numerical flux and update averages.
- Printed 10 / raw 32: Section 1.7 distinguishes exact `q` and numerical `Q_i^n`, with current-time conventions.

The source describes approximation quality qualitatively. It supplies neither a norm nor a numerical threshold in this passage. The user has not adopted a quantitative FV convention. Accordingly these statements are auxiliary conditional mathematical estimates, not a claim that the source defines accuracy by these bounds. The concrete `Fin m → ℝ` norm is Lean's finite-product supremum norm. No identification with a source-selected Euclidean norm or physical nondimensionalization is made.

The full task, decision, and report of `LEV-CH01-RIEMANN-RECTANGLE-INTERFACE-PRODUCTION-20260908` were inspected before the solver work. Decision SHA-256 `44dfd5c682eb5fdcd9fabd7b747df0ccbabc280d31482e26861c714a7b56c1a4` is a rejection (`not-faithful-weaker`, accepted false). Its general method permits arbitrary unequal-state flux outputs; the target does not identify every existential solution with the selected execution; and its physical-approximation and analytic correspondence remain insufficient. The present linear method has extra independently proved structure. This does not reverse the old verdict or establish general nonlinear availability.

## Reuse evidence

Searches preceded new estimates and exposed prerequisites. `input-provenance.json` records exact scoped commands, outputs, exits, producer/source hashes, the pinned Mathlib revision, and direct imports. An initial broad whole-library `error`/`norm` search produced excessive unrelated numerical-analysis matches and truncated its displayed output; focused flux/average and PDE-family searches replaced it. No truncated output or documented miss is treated as an exhaustive absence result.

| Candidate | Use or rejection |
| --- | --- |
| Frozen prior candidate, SHA `f90dbaa19d16da3617dac27e982557ebe501249afb03566b9bdb6b191ae935be` | Reuse the exact local weighted error and contiguous-block error identities. The byte-identical `frozen-base.lean` is scratch compilation evidence, not a second new producer. |
| Current PDE/project searches for norm-flux, average-norm, and time-averaged physical references | No selected exact next-step error estimate was found. The prior identity is the relevant foundation. |
| Mathlib `norm_add_le`, `norm_sub_le`, `norm_smul`, `norm_sum_le` | Reuse directly for the quantitative consequences. No duplicate norm or sum inequality. |
| Mathlib `mul_le_mul_iff_right₀` | Use the actual pinned positive-left-multiplication equivalence; the older-looking `mul_le_mul_left` spelling has a different type. |
| Mathlib `intervalIntegral.norm_integral_le_of_norm_le_const` and `.integral_sub` | Reuse for averaged trace-error bounds, with explicit integrability hypotheses and positive duration. |
| General `RectangleRiemannInterfaceFluxMethod` | Insufficient by itself for unequal-state physical accuracy, as the frozen audit records. Its constant consistency is not promoted to the required relationship. |
| `linearRectangleRiemannInterfaceFluxMethod_information` and `linearRiemannSolution_rayZero` | Exact relevant producers for the selected linear solver's actual positive-time trace. |
| `certifiedLinearRectangleRiemannSolution`, `linearRectangleRiemannInterfaceFluxMethod` | Supply the actual checked linear solution and its Riemann/conservation certificates; no fresh certificate assumptions or placeholder solves. |
| `rectangleRiemannInterfaceFlux` | The new full-array rule is proved definitionally equal to this existing execution API. |
| Mathlib `intervalIntegral.integral_congr_ae`, `.integral_const` | Reuse to integrate the selected solver's constant positive-time interface flux without constraining its value at time zero. |

The explicit linear method is available on all ordered state pairs for each real hyperbolic matrix, using its existing independently proved construction. The generic error estimate does not require a linear flux. The linear solver linkage is confined to this verified family; no analogous nonlinear theorem is claimed.

## Exact verification and limits

The final standalone `combined-check.lean` consists of a linear-interface import, the byte-identical frozen base, and the two new fragments. Final declaration checking repeats exactly those bytes before the checks. It covers 12 new declarations, the 9 frozen-base declarations, and 14 integrated producers. All native runs and outputs are retained under unique labels.

The first estimate/combined attempts failed on elaboration details: implicit norm arguments, the positive multiplication lemma name, half-open interval membership simplification, and parentheses around an applied integrability projection. A later attempt exposed addition-side orientation and a redundant tactic after a closed goal. Failed source snapshots and actual exits are preserved. The final combination compiles with no warnings; final axioms and hashes are validated by the receipt.

Remaining mathematical work, if a stronger physical error guarantee is wanted, is to prove trace-error premises from a chosen approximation model, stability/consistency estimates, or a concrete domain-of-dependence argument. Selecting such hypotheses as the source's intended definition would require an explicit interpretation and a new independent audit. This subtask makes no such selection and launches no audit.
