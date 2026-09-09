# Capacity-weighted net reference error: bounded proof draft

The new general theorem retains the signed difference of numerical-minus-physical left and right face errors before taking a norm. For a positive physical cell volume V and a positive actual time step dt, it proves

`V • nextError = V • oldError + dt • netFluxDefect`

and, from independent bounds on the old error and this net defect,

`‖nextError‖ ≤ oldBound + (dt / V) * netDefectBound`.

No separate per-face accuracy or asymptotic order assumption is added. The numerical rule can read the complete old array. The physical face references are the time averages of `data.faceFlux` on the same selected slab; those face fluxes already use the supplied physical normal flux and face integration. The identity's sign is left-error minus right-error, consistent with the existing right-minus-left numerical update.

## Exact reuse and scope

The weighted identity is extracted from the internal balance in `FinitePhysicalReferenceError.advance_error_le`. It reuses `advance_mass_balance`, the reference's exact subinterval balance, `intervalIntegral.integral_sub`, and `cellWidth_smul_oneDimensionalCellAverage`. The proof retains the whole existing `PhysicalData.ReferenceOn` premise: actual cell and face integrability, admissibility, and all subinterval balances are not weakened or silently discarded.

The norm estimate reuses `norm_le_of_weighted_error_balance` with its left error equal to the **entire net defect** and its right error equal to zero. This avoids duplicating the generic norm and positive-volume division argument. The resulting bound does not contain the sum of two face-error bounds.

The exact root bridge `PhysicalCapacityBridge.lean` (SHA-256 `c6c77dae3873f36b6535ecd8e38cf1db030347022ac3904829b0134a129714fc`) is embedded byte for byte in the complete native input. The two capacity-line theorems rewrite using that bridge's `capacity_cell`, `advance_eq`, and `LineCoordinates.extract_cell`. They therefore use the same actual supplied face rule, extracted current array, measured physical projection, and active cell volume. Neither a second numerical operator nor a fictitious one-dimensional reference is introduced.

Scoped project searches found the existing physical error theorem and generic weighted norm lemma; these are selected producers. Existing `DirectionalReferenceError.advance_error_le` and the separate-face local contracts remain valid alternatives but do not expose the desired measured physical net defect directly. Rebuilding their norm proof or assuming individually high-order face errors would be unnecessary. The Mathlib search records the interval subtraction and norm scalar-multiplication/subtraction infrastructure; the existing project norm theorem already packages that machinery. Search receipts name their exact limited directories; no whole-library absence claim is made.

## Native checks and example

There are six new declarations under `CapacityNetReferenceError`: `netFluxDefect`, `advance_error_balance`, `advance_error_le_net`, `capacity_line_error_balance`, `capacity_line_error_le_net`, and `scalar_nonzero_net_example`.

The scalar example uses zero exact density and zero physical face fluxes, volume 2 and time step 1, with numerical left flux `bias + 2` and numerical right flux `bias`. It verifies zero-reference interval integrability and every scalar rectangle balance, net defect 2, next numerical value 1, and actual error 1, which equals `(1/2)*2`. The arbitrary common bias cancels. This is a local scalar arithmetic/integral example; it does not separately instantiate every field of a complete `PhysicalData` structure.

Native attempt 01 compiled the net definition, general identity and bound, and both capacity specializations, but the scalar proof left a reflexive numeral goal. Its actual exit 1 and `sorryAx` diagnostic are preserved and are not treated as a successful proof. Attempt 02 adds only the final `rfl` for that goal and exits 0. The first freeze guard then correctly rejected its three unused integral-binder warnings; the failed guard and its script are preserved. Attempt 03 only renames those unused binders with underscores. Its complete input exits 0 without warnings; all twelve axiom reports (six embedded bridge theorems and six new declarations) use only `propext`, `Classical.choice`, and `Quot.sound`. The capture records the native executable, direct compiled import resolution, project source/compiled dependency closure, exact input, command, outputs, actual exits, and before/after input hashes. Historical mutable fragment references resolve only to their byte-identical retained attempt snapshots.

## Remaining boundaries

These are artifact-only foundations. They do not construct incidence compatibility for arbitrary grids, assign physical geometry to missing lookup positions, certify ghost projections, prove a CFL/admission condition, or establish a high-resolution quality family. The actual-cell specialization never uses the bridge's dummy ghost capacity as physical geometry. The net estimate still needs an actual bound on the net defect; obtaining a uniform mesh-dependent bound on a fixed smooth physical reference is subsequent mathematical work. There is no inference about common face area, preservation of hyperbolicity under flux averaging, a universal Cartesian chart, source faithfulness, or adoption of a source interpretation.

No production, gate, audit, ledger, topology, or Git file was modified. Final authoritative source, dependency, check, search, and evidence hashes are in `receipt.json`, `verification.json`, and `manifest.json` beside this review.
