# Directional numerical-method placement

This additive placement keeps the corrected frozen mathematics and supplies a simultaneous physical witness. It does not establish source acceptance. The old CoordinateSplittingBalance source file, all prior audits, and the original selected-interpretation receipt are unchanged.

## Placement and dependencies

The exact repository paths, modules, public authored declaration names, line counts and SHA256 values are in `placement-inventory.json`.

- `DirectionalReference`: independent cell/time conservation and physical face averages, with the weighted balance identity.
- `DirectionalReferenceError`: error of the actual coordinate update from old-average and two shared-face flux errors. The reference excludes the numerical method and its output; no output error bound is assumed.
- `CartesianDirectionalReference`: derives the finite directional reference from an independently rectangle-conservative real PDE field, using actual axis-cell averages and face-area weighting.
- `PhysicalCoordinateGeometry`: measured real/vector state cells, genuine topological shared-face incidence, admissible states and actual normal fluxes hyperbolic on those states; realized cell/face integrals and finite-substep reference conditions.
- `DirectionalMethodSweep`: one conjunction binds these physical data to admitted positive-step constant consistency, each actual intermediate state, independent references, conservative prefix execution, strict line locality, derived update errors and the conditional measured Cartesian realization of the same executor.
- `Examples/PhysicalIntervalSweep`: simultaneous real-interval geometry, identity physical flux, translated-step reference and nonconstant left-state numerical execution.
- `Source/LeVeque/Chapter01/CoordinateDirectionalMethods`: thin full statement corresponding to the selected coordinator interpretation. Its proof uses the generic producer without changing its type.

The generic code does not import examples or source wrappers. The example imports the existing transport witness and two-direction information-method example; it defines no new averaging, finite-volume executor, hyperbolicity predicate or integral calculus.

## Mathematical preservation

The prior exact Candidate.lean is retained byte-for-byte in the comparison input. `comparison.fragment` defines explicit field-preserving `fromDraft` and `toDraft` maps for the nominally distinct PhysicalData structures and proves both round trips. It compares the reference, face average, weighted balance, error theorem and Cartesian constructor; it also compares cell volume, cell average, face integral, reference predicate and the complete primary theorem after transporting the data. The source theorem has the same full type. Equality of proofs uses Lean proof irrelevance after their types align; this is not a claim that the two nominal structures themselves are definitionally equal.

The former draft's coordinate-index counterexample and separate two-dimensional physical-reference witness remain in the unchanged draft and are elaborated again in the comparison file. They need not be exposed as redundant new production API. The existing `LeftStateCoordinateSweep.left_two_stage_nonvacuity` is checked directly.

## Simultaneous nonvacuity

`PhysicalIntervalSweep.cells` partitions the real line into Ioc((j:real)-1,j), indexed by Fin1→integer. Coverage follows from the actual integer ceiling; disjointness follows from its unique interval characterization. The topology is the ordinary topology of the reals. The shared interface is the lower endpoint of a cell and the upper endpoint of its predecessor; both closure memberships are proved using `closure_Ioc`.

The physical cell measure is real volume, and each cell has measure one. Point faces use Unit with Dirac unit measure. The actual flux is the identity and the state dimension is one. Hyperbolicity uses the existing unit-speed transport producer. The reference is the actual translated step from state zero to state one, with its existing rectangle conservation proof. Its cell means are exactly the existing normalized interval averages, and its face integrals are evaluations at the actual common endpoints.

The rule returns the adjacent left state. It is consistent with this identity physical flux on admitted positive steps. The input state is zero in cells j≤0 and one in cells j>0. The executed unit step changes cell1 from one to zero; final cells1 and2 are zero and one. The physical reference is likewise nonconstant, with initial values zero and one at x=-1 and x=1.

`simultaneous_contract` applies the entire generic theorem, including the final conditional Cartesian clause, to these same data and the actual single-stage schedule. Its tolerances are the norms of independent old-average and physical face-flux discrepancies, not a certificate about the next numerical state. It makes no claim that they vanish or meet a requested accuracy order. The existing separate two-direction witness remains available and is checked; this new simultaneous physical example is one-dimensional.

## Preserved scope limits

The Cartesian clause remains conditional on equality of the physical cell-volume function and numerical rule with the supplied axis realization. It does not identify an arbitrary PhysicalData.facePoint with a chart. Actual physical cells, face measures and flux functions are supplied, and no inferred Jacobian or normal field is claimed. A bounded or periodic numerical problem still needs an explicit representation/boundary extension into the total coordinate arrays. The finite positive schedule and scoped state/flux conditions are explicit. No arbitrary high-resolution method, convergence, unconditional accuracy, or exact multidimensional evolution is asserted.

The source selection is coordinator-recorded under the user's goal, not a literal detailed user answer. Fresh independent audit must judge whether this explicit model and conditional scope faithfully represent the selected source claim. Production placement, successful proofs, and this review do not supply that verdict.

## Evidence

`reuse-review.json` binds the prior preimplementation search and new focused project/Mathlib searches. Native receipt files record exact commands, actual exits, raw output hashes and before/after source/dependency pins. Every failed attempt and its input snapshot is retained. The final manifest and receipt bind the successful focused build, declaration/axiom reports and nominal/type comparisons. No aggregate, tier, gate, ledger, audit, ref, staging or commit operation is part of this placement.
