# Admitted returned-field coordinate sweeps

This is unselected scratch mathematics. It does not select a source wrapper, change the prior DIM audit, adopt a pending interpretation, or change production files.

The frozen Cartesian/Tensor composition is mathematically correct for its `LineSolver`: that class requires a total exact rectangle-certified solver, and its face extraction uses the returned field at time one. The present composition removes those three restrictions from the new general operational contract. It uses canonical `RiemannFieldFluxMethod` values, allowed to depend on direction and stage duration. It neither asserts that every local Riemann problem is admitted nor asserts that the returned field is an exact solution. Numerical extraction is the selected method's own operation, applied to its actual selected result.

## Exact operational contract

`FaceAdmitted` applies the selected method's domain predicate to the ordered adjacent states of the actual current coordinate line. The left state is the predecessor cell, the right state the current cell. `StageAdmitted` requires this at every face used by the full-grid stage. `SweepAdmitted` recursively checks every later stage on the actual preceding numerical update. Admission of the initial state alone does not imply any later admission.

The canonical coordinate-line rule is total as an algebraic function. `guardedRule` therefore has an explicit off-domain fallback, already valued as an integrated normal-face numerical flux. This fallback is not claimed to solve a problem, approximate a physical flux, or carry a returned field. `normalFaceFlux_of_admitted`, `admitted_face_observation`, and `executed_face_uses_selected_solve` show that every admitted operational observation instead uses exactly `numericalFlux (extract (solve actualProblem admission))`, weighted by the supplied face area. The observation also retains the existing field method's prescribed strict initial states and all-real temporal trace integrability; these requirements have not been weakened invisibly.

Face flux, full-stage update, admission of a complete execution, and final sweep result are independent of the fallback under realized admission. The induction establishing sweep independence compares the actual intermediate states before continuing. `admission_at_prefix` identifies admission at an arbitrary executed prefix. Thus no operational assertion rests on an off-domain value. No total-solver existence theorem is asserted.

## Reuse and geometric specialization

The implementation reuses canonical `CoordinateLineBalance.normalFaceFlux`, `advance`, `advance_line_local`, `advance_mass_balance`, `finite_line_mass_balance`, and the canonical `CoordinateLineBalance.sweep`/`sweep_cons`/`sweep_two`. It composes the existing finite-volume update algebra; it does not define a replacement numerical update or reprove interval-integral foundations. Interior shared-face contributions cancel in the finite-line mass theorem. The two-stage balance explicitly uses the first actual output for its second selected fluxes.

Supplied volumes must be positive in mass-balance results. Supplied face factors alone do not establish a physical geometry, compatible normals, or constant preservation on arbitrary logical grids. The general algebra permits real stage durations; numerical stability or convergence is not asserted. Locality is strict coordinate-line locality for the full-state operation, inherited from the canonical line-reading API.

The Cartesian specialization includes the frozen `cartesian-coordinate-line-composition-draft/final03-input.lean` byte for byte. Its cell volumes are products of positive one-dimensional cell widths, and its face weights are transverse face measures. `cartesian_measured_balance` uses those actual measured boxes. `cartesian_line_update` restricts an admitted full-state stage to exactly the existing one-dimensional `riemannFiniteVolumeUpdate`, with the selected method's actual interface flux. The old exact `LineSolver` embeds through `RiemannFieldFluxMethod.ofExact`; the admitted advance and ordered sweep then equal the frozen Tensor operators. These are exact specialization equalities, not an assertion that the new returned-field class and the old exact class have equal domains.

## Nonvacuity

The example reuses canonical `StationaryRiemannField.method`. It supplies its own total admission proof, without making totality a premise of the general method. With positive unit volumes, unit face weights, and positive unit stage durations, the actual update is a predecessor shift. The two-direction sweep on the frozen stripe state has distinct output values at two specified cells, and the same method has a returned field that is not rectangle-conservative. This demonstrates a concrete inexact operational example and excludes a cell-value broadcast as the meaning of this update. No duplicate hyperbolicity or integral witness is introduced.

## Boundaries retained

The pinned source discussion and prior rejected audit are evidence inputs, not judgments reused to accept this draft. The existing logical-geometry choice (`call_axfTXsEjNKG3lawf5Dq10qQv`), the conditional finite-volume accuracy choice (`call_1UY4fVuKrjpIIQfhLdeuFoRH`), and the separately asked returned-field representation question remain outside this mathematical result. No reply is inferred. The field method still requires a full returned field, exact prescribed initial states, and integrable interface trace for every real interval. The independently frozen information-only method is not imported by this draft; a later adapter, if wanted, is separate work.

## Verification and preserved failures

`run.py` writes each complete Lean input, raw combined output, command, UTC timing, actual exit, source/dependency hashes, compiled direct-import hashes, and before/after equality into a distinct attempt. It checks the pinned Lean/Mathlib versions. `core01` failed only because an opaque admission predicate prevented guard simplification; `core02` passed. `full01` retains the dependent-result transport failures in the first specialization proofs. Later attempt results are recorded without overwriting either failure. The final receipt is generated only after actual native exit zero, every selected declaration's allowed-axiom check, no warnings or placeholders in the successful output, and exact current input validation. The imported frozen Cartesian/Tensor declaration checks are also validated, separately from the new declarations.

No source acceptance, candidate/epoch acceptance, gate status, or protected reference is asserted by these receipts.

The final `full03` native run exited 0 in 101,031 ms. It checks all 31 new declarations as well as the inherited frozen Cartesian/Tensor checks. Raw output SHA256: `a1b8a2b26bf5b7d7c65bb912bf8a293a8ba2a48b69c8df6e5b173be6f32acb1e`. `full02` is also retained: its sole remaining failure was the definitional equality between the explicit line lambda and the frozen `line` definition. The final proof reduces that equality with `rfl` after the explicit dependent-result congruence argument.
