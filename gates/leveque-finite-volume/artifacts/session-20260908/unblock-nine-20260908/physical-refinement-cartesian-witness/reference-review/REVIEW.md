# Affine Fin 2 physical-reference route

Read-only proposal, with no new Lean execution, source judgment, or change to the running audit. The mesh/coverage constructor remains the parent worker's task.

Take `Point = Fin 2 → ℝ`, `State = Fin 1 → ℝ`, Lebesgue volume, admissible states `Set.univ`, and each directional scalar flux `id`. The candidate is `q x t := fun _ => x 0 + x 1 - t`. It is nonconstant and genuinely C-infinity. For either selected coordinate `d`, its time derivative is -1 and its derivative in that coordinate is 1. Thus it is a reference for each separate unit-speed directional subproblem. It does **not** solve the unsplit PDE with both flux derivatives added; no such assertion should accompany it.

The physical tensor can be `physicalFlux x u k = u`; normals `normal n d face point k = if k = d then 1 else 0` recover the existing canonical `FiniteCartesian.data` normal flux `id` by `Finset.sum_ite_eq'`/simp. There is no claim that averaging a general hyperbolic flux preserves hyperbolicity. The identity-flux hyperbolicity proof pattern is already in frozen `DIMTwoDirectionJointWitness.identity_hyperbolic`.

## Exact reusable geometry and reference API

- `FiniteCartesian.data`, `data_cell_measure`, `data_cellVolume`, `data_face_measure`, `data_face_measurable`, `data_normal_flux` and `faceMeasure_area` provide actual Ico boxes, Lebesgue cell volume, restricted pushforward face measures and shared physical faces for any finite active set.
- `FiniteCartesian.CartesianIdentification.cellMean_eq` and `faceFlux_eq` identify the same measured averages/fluxes. `CartesianGrid.integral_cellBox_projection` and `cellVolumeAverage_projection` reduce coordinatewise cell terms to the actual 1D interval integral.
- `CartesianGrid.cellVolume_eq_width_mul_area`, `faceArea_update`, and the actual axis adjacency identify right/left face differences. Mathlib `integral_id` (`Mathlib/Analysis/SpecialFunctions/Integrals/Basic.lean:201`), `intervalIntegral.integral_const`, ordinary integral addition/subtraction, and existing finite-product restricted measures finish the affine calculation.
- `CartesianIdentification.rectangle_balance_lift` is **not** directly applicable to this `q`: that theorem's field depends only on `x d`, whereas this affine field also varies transversely. The frozen Fin 2 full witness has `reference := 0` and selected level 0; its geometry/identification and `ReferenceOn` construction are useful patterns, not a proof of the new nonconstant reference.

## Small remaining reference calculation

For a Cartesian position `c`, write `mid k c = (left k c + right k c)/2`. Prove the exact vector identity

`data.cellMean q c t = fun _ => mid 0 c + mid 1 c - t`.

For a face in direction `d`, prove

`data.faceFlux d q face t = faceArea d face • (fun _ => faceLeft d face + mid (other d) face - t)`.

Use integral linearity after proving integrability on the bounded boxes/faces. The cell identity follows by the two coordinate projections. The face identity uses `faceFlux_eq`, the fixed normal coordinate, and the single tangential-coordinate interval integral. The required affine integrability follows from continuity on compact closed boxes, restricted to their Ico subsets; the pushed-forward face integral is the same bounded tangential integral. This is a small additional reference proof, not a chart theorem.

Consequently the left-minus-right face flux is the time-independent vector `fun _ => -data.cellVolume c`, while the cell-mean time difference is `fun _ => s-t`. Constant time integration gives the exact `ReferenceOn` balance on every subinterval. Cell integrability, face integrability, time integrability and state membership must all be supplied in the `ReferenceOn` conjunction; `Set.univ` makes only the state clause immediate.

Global affine C-infinity follows by `contDiff_pi` from the two coordinate projections and the time projection, then `.contDiffOn` gives the required closure(region) × [0,T] regularity. This route works uniformly for every refining level because `q` itself never depends on n. It establishes reference provenance, not method accuracy or oscillation control.

For the actually read ghost slots, use the neighboring Cartesian boxes within a fixed buffered region. Their initial means are the same midpoint sum, so `referenceGhost` is a genuine physical average without treating those boxes as active cells. A fixed buffer must contain the used boxes at every n. Under the current all-slots boundary interface, unused slots may use one fixed positive-volume filler region; this must not be reported as an infinite Cartesian mesh inside a bounded box. No boundary mesh-size restriction is needed merely for integrability; correctness of the actual accuracy claim must still be proved from the actual selected ghost values.

## Actual interface observations sent to root

The reviewed draft correctly shares the physical flux tensor, measure and state set, uses reference-specific measured ghosts, places C,N before all n and admitted positive dt, and compares against the same `data.cellMean`. An interior-nonempty fixed target prevents singleton coverage from passing as a nondegenerate refinement region. Boundary positivity/finiteness/inside/integrability can be restricted to an explicitly used ghost footprint when that footprint is available. Projection availability correctly remains separate because a nonconvex state set need not contain its averages.

One concrete issue was found in the current `variation`: internal jumps are counted twice and boundary jumps once. On a finite line with at least two cells, left ghost 0, all active values 1 and right ghost 1, the incoming value is 1. A unit CFL-one shift gives first cell 0 and the remaining cells 1, making the outgoing value 2. A uniform `(1+K*dt)` coefficient with vanishing dt and additive vanishing rate cannot absorb this factor. Counting each edge once (each cell's left jump, plus a right jump only at a missing next lookup), or also weighting boundary jumps twice, removes this mismatch. This is an elementary counterexample to the proposed fixture/variation combination; it is not a newly compiled Lean result or a source judgment. Root and parent have been informed.

The exact reviewed draft snapshot, selected native witness receipts and reusable source pins are recorded alongside this review. No full-quality instance or new reference theorem is claimed compiled here.
