# Information-only admitted coordinate sweeps

This is an unselected scratch composition. It preserves the entire frozen returned-field coordinate packet and introduces no production, source-wrapper, gate, ledger, audit, or Git change. The independently placed canonical information-method API is used only after its exact native-ready receipt is frozen and bound in `production-context.json`.

## What the new contract requires

The core takes a direction- and duration-indexed `RiemannInformationFluxMethod`. A method has a domain, a dependent result family, a selected routine, extraction from its selected result, a numerical-flux map, and constant-data admission/consistency. A routine is not thereby asserted to solve the governing PDE exactly or to be accurate. There is no returned-field, initial-field identity, rectangle-solution certificate, trace function, or integrability premise in the information-only admission/sweep/balance contract.

`FaceAdmitted` concerns the actual ordered adjacent input on the actual current coordinate line. `StageAdmitted` requires admission at every face used by that full-grid stage. `SweepAdmitted` checks later stages recursively on the actual preceding output. It does not infer later admission from initial admission. `admitted_face_observation` identifies the exact left/right states and extraction from the selected routine result; it does not invent a field representing that result.

The existing canonical rule/update API is total algebraically. `guardedRule` supplies an explicit arbitrary value off the method's domain to interface with that API. The fallback has no asserted solver, physical-flux, or approximation meaning. The admitted observations, stage update, recursive admission, and full sweep are independent of the fallback. Every executed prefix has the admission required for its next stage, and every observed operational face uses the selected method result. No total routine on arbitrary Riemann problems is inferred.

## Existing producers and specialization

Shared-face indexing, strict coordinate-line locality, volume-weighted cell balance, finite-line cancellation, and ordered intermediate-state composition reuse canonical `CoordinateLineBalance` and `CoordinateLineSweep`. The new proofs only identify their actual face terms with the admitted method's extracted information. The basic finite-volume update and measure/integral foundations are not redefined.

Positive supplied cell volumes suffice for the balance identities. Supplied face factors alone do not prove a physical chart, normal compatibility, or constant preservation on arbitrary logical grids. Cartesian specialization uses the frozen product-of-axis cell geometry and transverse face measures; restriction to a coordinate line equals the existing one-dimensional `riemannFiniteVolumeUpdate` with the actual information method's interface flux. That geometry remains explicitly distinguished from unspecified logically rectangular geometry.

`fieldMethods` uses canonical `RiemannInformationFluxMethod.ofField`. Explicit equalities preserve face admission, selected extracted flux, guarded rule, full stage update, full sweep, and recursive admission. The new and old recursive admission predicates are compared propositionally by induction; no nominal/recursive definitional-equality claim is substituted. The old exact Tensor sweep remains a further checked specialization through the frozen field adapter. Its total exact time-one restrictions are properties of that old special case, not premises of the new general sweep.

## Nonvacuity and limits

The finite example uses canonical `LeftStateInformationFlux.method`, whose result is only an ordered state pair with its input equalities. For the existing one-component unit-speed law, positive unit-duration stages with positive unit volumes and unit face factors produce predecessor shifts. A two-direction execution is admitted and has distinct specified output values. This is a concrete finite computation without a returned-field premise or an all-real trace requirement.

No general accuracy, high-resolution property, convergence, CFL condition, entropy criterion, or domain-preservation theorem is claimed. Canonical conditional error estimates remain separate mathematics requiring their own reference/trace/error premises. The pending logical-geometry and accuracy choices are not adopted by this draft. The separately pending full-field question is not retrospectively answered: that representation is now a special case, while the general operation uses only numerical information.

The information method family is indexed by direction and duration and receives the two actual adjacent states. The additional `cartesian_full_line_update` takes an arbitrary full-line numerical-flux rule, reads the actual current line and face index, weights its flux by the measured transverse area, and proves equality to the existing one-dimensional finite-volume update. The admitted information theorem is derived from this generic correspondence. The intervening exact change-of-units identity rescales the arbitrary off-domain fallback by inverse positive face area; admitted observations still never use that fallback.

No reconstruction algorithm is introduced. A consumer may supply a full-line rule through this interface, but must separately supply any promised consistency or accuracy evidence. These declarations do not classify all high-resolution schemes or infer that every arbitrary numerical rule is accurate.

## Reproducibility

`preparation.json` records actual library/Mathlib searches and the prior frozen packet hashes. `derivation.json` and `cartesian-derivation.json` record the exact mechanical starting points; immutable per-attempt input files, rather than later editable fragments, are authoritative for failed attempts. The runner validates the native-ready production pins, pinned Lean/Mathlib versions, direct compiled imports and all current inputs before/after each native invocation. A separate core invocation checks the information-only declarations without importing the old returned-field sweep. The complete invocation includes the old checked input byte for byte to verify specialization, plus each new fragment byte for byte.

Final PASS is recorded only after actual native exit zero, all selected and inherited declaration/axiom checks, no successful-output warnings/errors/placeholders, and independent hash verification. Such PASS describes local mathematics and reproducibility, not source-faithfulness or production-placement completion.

The standalone `core01` run passed 17 declarations in 33,811 ms, raw SHA256 `bd4c1f3d337cd76fe2290c5a2eef835707184ba1f01255f65a869426efbf2463`. The pre-extension `full02` passed its 34 declarations. After the requested generic full-line consumer was added, final `full04` exited 0 in 145,827 ms and checked 37 new declarations plus 79 inherited checks. Its raw output SHA256 is `0a1b0e99ec52e7e31fa6f5c5c1feb3f3620056ab5530726aa5cc8d994514b411`.

Failed `full01` retained an omitted `noncomputable` annotation on the concrete example family and one unused section-variable warning. Failed `full03` retained a dependent-index guard reduction issue in the information specialization of the new generic theorem; the generic Cartesian theorem itself checked. Final `full04` resolves that guard using admission at the actual updated index and then rewrites the nondependent interface-flux index. No statement was weakened to resolve either failure. All full inputs, outputs and actual exits are preserved.
