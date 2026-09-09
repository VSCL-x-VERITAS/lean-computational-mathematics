# Additive local Riemann routine repair

The four new leaves contain 22 authored declarations. They preserve the old `Method`, its owners, and its audited source target. The new primary is `NumStability.leveque01_localRiemannRoutineInterface_sourceContract`.

The completed prior decision `afc764d552b0f3ee9739eea5ec2a5377d1718635410c12bd957f444ac947178c` identifies exact equal-state consistency as the decisive extra restriction. Its conditional domain/reference scope was acceptable under the recorded Q7 convention. This implementation is a mathematical repair proposal, not a new faithfulness judgment. The original rejected packet remains unchanged.

## Contract and domain

`Routine` has only domain, selected result, extraction, and numerical-flux fields. `Consistent` is a separate optional property. The old `Method.toRoutine` adapter preserves domain/solve/extract/flux definitionally; its two theorems establish selected-flux equality and the inherited optional consistency property.

For every law and bias, `biasedRoutine` is a direct construction: its domain is true, its result is the ordered pair of input states, and its flux is the left-state physical flux plus the bias. The primary visibly includes this unconditional construction. This is availability of a numerical pipeline; it is not existence of a physical Riemann solution, accuracy, convergence, or an algorithmic complexity assertion.

The main local clause quantifies over every routine, then exactly three ordered states with three membership proofs. Only the two actual problems require execution admission. Both problems have the actual positive duration `t-s`; there is no obligation on unused cells/faces or on all future times. Numerical center data remain independent of exact physical averages. Spatial averages and physical face-time averages use the canonical normalized integral. The local physical field has two integrable spatial slices, two integrable physical flux traces, and the actual one-rectangle balance.

The direct estimate uses independent old-cell and numerical-minus-physical face bounds. It has no consistency or `Reference` existence premise. An ancillary universally quantified clause compares any supplied same-problem, same-law finite-time references with the physical averages by the triangle inequality. A reference is physically constrained by the existing `Reference` definition; it is neither returned by the routine nor asserted unique, entropy admissible, or externally selected. The reference clause cannot restrict applicability of the preceding direct estimate.

## Reuse and search record

Before introducing the new names, scoped `rg --files ComputationalMathematics` searches for `LocalRiemannRoutine`, `BiasedLocalRiemannRoutine`, and `RiemannLocalRoutineInterface` found no owner collision. This was a current-tree naming search, not an exhaustive library absence claim.

The finite-volume tree and pinned Mathlib norm-group file were searched for `structure .*Routine`, `def .*toRoutine`, `def .*biased`, `constant.*Reference`, `def reference`, `def law`, `reference.*constant`, and `norm_sub_le`. Existing `Method` was rejected as the primary input because its `consistent` field is precisely the audited restriction. `Routine` reuses its `Law`, `Problem`, and `Reference` types while separating the numerical pipeline. No derivative, physical existence, or new norm theory was introduced.

`finiteVolumeLocalCell_error_contract` in `LocalCellErrorBounds.lean` supplies the normalized averages, conservative update, exact weighted error identity, and direct norm bound. The new producer specializes that theorem to a single `Unit` cell and two `Bool` faces internally; those finite implementation indices impose no exterior-state requirement. `oneDimensionalCellAverage_isCellAverage` supplies reference time-average normalization. The optional comparison uses Mathlib `norm_add_le` and `add_le_add` only.

Searches for `isRiemannData_const`, `riemannData.*const`, `oneDimensionalCellAverage_const`, and `cellAverage.*const` were scoped to the finite-volume tree. A guessed `CellAverages.lean` path was a miss; the actual owner is `CellAverage.lean`. The example instead reuses `StationaryRiemannField.reference_rectangle`, `reference_initial`, and `LeftStateInformationFlux.selected_flux_eq_reference_average`. The thin finite-horizon reference restriction follows the already checked `D/local-riemann-witness/Candidate.lean` construction; no scratch import or duplicated integration proof enters production. Pinned Mathlib `norm_smul`/`norm_one` normalize the explicit bias norm.

## Nonvacuity and checks

The example uses unit-speed scalar transport on the proper state set `[0,1]`, an actual finite-time transport reference, and a result containing only two vectors. `actual_error` computes the exact reference-flux error for every bias and admitted problem. The explicit equal-state problem has bias `1/2`, error exactly `1/2`, and a proof of failure of exact consistency. Identical face biases cancel in the conservative update.

The separate scratch `Applicability.lean` applies the entire primary local clause to the zero physical field, two actual admitted equal-state problems, and this nonconsistent routine, discharging all physical integrability/balance hypotheses. It also supplies a physical reference with the exact positive error. It is test evidence, not a source wrapper dependency.

Native source and example builds and the 22-declaration proof-free check are captured separately. Each failed Lean attempt keeps its actual output/exit and exact failed input snapshot: initial implicit problem inference, generated source binder syntax, transport-flux simplification, the scratch projection's named-argument elaboration, and the explicit finite-enorm side condition for constant integrability. The initial array-wide draft compiled but was replaced, before freezing, by the three-state local contract after scope review. Source build 02 passed with six unused nested-binder warnings; build 03 only prefixes those six binder names with underscores. The complete byte delta is checked by the freeze helper, and affected declaration/application checks were repeated. No old owner, aggregate, tier, gate, ledger, released helper, or audit was edited.

## Source qualification

Source facts are limited to the pinned LeVeque PDF, raw pages 26–27 / printed pages 4–5; raw page 28 / printed page 6 was viewed only as continuation context for approximate Riemann solvers. The selected PDF and rendered images are hash-bound in the manifest. The interpretation receipt is coordinator-selected within the user's request to unblock nine rows, not a fabricated literal detailed user reply.

Q7 supplies independent finite-step error comparisons; the book does not prescribe this norm, a tolerance, order, or convergence rate. The inherited rectangle convention remains distinct from Q7. The primary establishes a conditional finite-volume comparison and a universally constructible numerical routine. It does not claim every Riemann problem has a physical solution, every routine is accurate, or a biased routine is a solved physical problem. Independent audit and integration remain the coordinator's responsibility.
