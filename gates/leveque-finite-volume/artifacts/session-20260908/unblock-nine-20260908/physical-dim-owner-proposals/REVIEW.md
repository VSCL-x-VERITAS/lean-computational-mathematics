# Physical DIM owner proposals

The final proposal is `attempt-06/proposed/`, with exact original-span and namespace mappings in `attempt-06/mapping.json`. It contains twelve new leaves, three changed mathematical owners, and one materially changed source owner. Production has not been written by this task. Native Lean elaboration and nominal transport remain root-owned and pending; the actual exit 0 recorded here is the artifact preparation script, not a Lean build.

The approved twelve-leaf map is retained. Five existing `NumStability.FiniteCoordinate.LineCoordinates` declarations move unchanged to `FiniteLineCoordinates`; the old two consumers import/reuse those same names. `PhysicalLineCapacity` uses actual measured cell volume and already integrated face flux. `CapacityCoordinateMethod` separates time-step admission and optional same-step stability. Only the stage-dependent sweep is extracted, avoiding a duplicate fixed-coordinate recursion. `PhysicalCellMesh` uses actual metric diameters, independently of capacities. `CoordinateLineVariation` is the single once-edge producer; the physical-family variation is a transparent specialization with the same finite-cell instance and supplied ghosts.

`PhysicalRefinementQuality` directly imports the upstream `Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries` owner and keeps genuine inner-infinity C∞, fixed law/measure/state data, actual measured projections, positive step availability, uniform constants before all later levels and admitted steps, and quantitative oscillation. Pairwise stability remains separate. The two zero-flux physical mean/face lemmas are sufficient for the generic zero-quality proofs; no zero-method alias or optional small-bias algorithm was added. Cartesian geometry and boundary regions are example owners; the full zero-flux family includes a genuine spatially nonconstant reference. The full source application remains a separate artifact.

The source replacement comes from the successful admitted successor, including `ValidSubsteps` and `admitted_specification`. It retains the same source theorem name with a materially different type. No equivalence to the old rejected source contract is asserted. Its assumptions are supplied measured directional balances; tensor/normal data do not establish continuum PDE equivalence. No universal geometry construction, integrated-flux hyperbolicity, or composite high temporal order is inferred.

| Owner suffix | Lines | Authored declarations | Change |
|---|---:|---:|---|
| FiniteVolume/FiniteLineCoordinates.lean | 106 | 10 | new |
| FiniteVolume/PhysicalLineCapacity.lean | 103 | 10 | new |
| FiniteVolume/FinitePhysicalFluxError.lean | 98 | 5 | new |
| FiniteVolume/PhysicalCellMesh.lean | 59 | 7 | new |
| FiniteVolume/CapacityCoordinateMethod.lean | 135 | 11 | new |
| FiniteVolume/CapacityCoordinateSweep.lean | 171 | 11 | new |
| FiniteVolume/CoordinateLineVariation.lean | 79 | 4 | new |
| FiniteVolume/PhysicalRefinementQuality.lean | 263 | 12 | new |
| FiniteVolume/PhysicalHighResolutionSweep.lean | 216 | 7 | new |
| Examples/RefiningCartesianGeometry.lean | 240 | 42 | new |
| Examples/RefiningCartesianBoundary.lean | 132 | 13 | new |
| Examples/ZeroFluxCartesianRefinement.lean | 171 | 17 | new |
| Chapter01/CoordinateHighResolutionMethods.lean | 42 | 1 | changed |
| FiniteVolume/CoordinateLineMethod.lean | 104 | 4 | changed |
| FiniteVolume/CoordinateLineMethodEstimates.lean | 198 | 9 | changed |
| ConservationLaws/Hyperbolicity.lean | 98 | 6 | changed |

The 149 declarations in new leaves include the five unchanged moved declarations. There are 169 declarations across all sixteen complete snapshots, including retained declarations in changed owners. Static inventories count explicit authored declarations, not automatically generated structure projections/recursors. The proposed-files inventory includes every explicit name and kind.

The mapping records simultaneous token/namespace substitutions and exact source-span hashes. It separately records the shared variation specialization and removal of one unused `SequentialError` namespace opening from the minimal method owner. The withGhost documentation accurately describes a changed coordinate value indexing the same Method type; historical audit discussion is confined to this review, not the source module header. New namespaces are `NumStability.FiniteCoordinate.PhysicalLine`, `NumStability.CapacityCoordinate` (with `Sweep`), `NumStability.PhysicalRefinementQuality`, `NumStability.PhysicalHighResolutionSweep`, `NumStability.RefiningCartesianGrid`, and `NumStability.ZeroFluxCartesianRefinement`. Mesh and variation declarations use their existing mathematical type namespaces. The generic constant-flux hyperbolicity proof is added to the current canonical hyperbolicity owner with explicit upstream derivative/basis imports.

All input and direct-import source bindings were reread. Direct-import provenance distinguishes proposal snapshots, current production sources, and pinned Mathlib sources; it is not a compiled dependency closure. Root's separate five-owner C∞/choice placement receipt is pinned. Those intentional current-source changes do not relabel any historical native receipt or old audit. Every earlier proposal attempt remains untouched: attempt 01 stopped on a nonunique source anchor; attempt 02 on a Windows long-path existence check; attempt 03 on the English word “admit” in a documentation comment. Attempts 04, 05 and 06 passed static preparation. Actual output/exit sidecars for 02–06 are retained; 01 has the observed-failure record and partial generated files.

Root's remaining checks are native focused builds, all explicit declaration/axiom checks, unchanged-name/type checks for the five moved declarations and retained old owners, explicit field maps/round trips and commuting observations for renamed nominal structures, transparent variation reduction, and the full joint source application. The source theorem deliberately requires a fresh audit. No source acceptance, gate closure, publication, or complete import compatibility is certified by this proposal packet.
