# Physical DIM promotion map

This is a proposal-only organization review. It does not change production, assign source acceptance, rerun a build, or measure final organization closure. The parent-authorized output scope is this new session folder. The code-review and naming guidance informs the assessment; this packet is not represented as a sealed multi-role review workflow.

The recommended minimal primary/zero-family promotion is **12 new reusable leaves**, **three changed mathematical owners**, and replacement of the existing Chapter01 source wrapper. The exact paths, source declaration selections, dependencies, omissions and validation obligations are in mapping.json. The already checked five-owner C∞/explicit-choice repair remains a separately identified change group, rather than an unrecorded side effect of these extractions. Root owns aggregates, tiers, source binding and audits.

## Required extraction and import order

1. Move the four LineCoordinates declarations at CoordinateLineMethod.lean:22–51 and LineCoordinates.extract_error_le at CoordinateLineMethodEstimates.lean:19–26 into FiniteLineCoordinates.lean. Keep their exact existing NumStability.FiniteCoordinate names and bodies. The old owners import the new leaf and retain every LineRealization declaration. Add the five checked coordinate-only ghost replacement/error declarations here.
2. Build PhysicalLineCapacity and PhysicalCellMesh independently. The former uses measured positive volumes and actual face/index incidence; the latter uses actual metric diameters of bounded cells and has no capacity or numerical-method dependency.
3. Build FinitePhysicalFluxError from existing ReferenceOn and update owners; then CapacityCoordinateMethod from the capacity/lookup layer. The method uses supplied integrated flux and actual dt-indexed admission. Stability remains a separate property, with actual-cell and missing-ghost error controlled by max E G.
4. Build the stage-dependent CapacityCoordinateSweep and the independent CoordinateLineVariation. Only the generalized sweep is promoted: its fixed-coordinate case is already a checked rfl specialization. The current finite mass balance and SequentialError recurrence remain canonical producers.
5. Build PhysicalRefinementQuality, explicitly importing Mathlib.Analysis.Calculus.ContDiff.FTaylorSeries. This direct real dependency is required even after the old lookup-to-quality import path disappears. Use one common variation definition, with Family.variation a definitional specialization under the actual finite-cell instance. The root's zero-flux quality/stability theorems fit here as general consequences for any supplied family.
6. Build PhysicalHighResolutionSweep and the three concrete Cartesian/zero-family examples. The final source wrapper imports only the mathematical specification owner. A complete joint source application remains a checked artifact, not a duplicate generic source owner.

Each proposed leaf is currently absent, with no same-named directory collision. No empty umbrella or parallel numerical-method owner tree is proposed. Direct imports in the map are semantic candidates, not a claim that a new canonical import test has already passed. Root should preserve the existing casefold-sorted aggregate convention.

## Reuse and duplicate avoidance

The necessary architecture defect is the current lookup dependency: CoordinateLineMethod imports RefiningLineMethod, and CoordinateLineMethodEstimates imports both that owner and old quality/error machinery. The new capacity core needs only lookup/extraction and its elementary norm bound. Moving these five unchanged declarations removes that dependency without a new nominal copy of LineCoordinates.

The scratch method/projection and weighted-mass aliases add no mathematical content. The map retains one physical projection producer and calls existing finite_mass_balance directly. Net error remains before triangle bounds; the local per-face theorem is preserved as its older distinct API. The two scratch capacity-line error adapters can remain concrete checked applications outside production.

The same once-edge expression currently occurs in CapacityZeroFlux.onceEdgeVariation and Family.variation. A common coordinate-variation owner avoids maintaining two public definitions. Its boundary count counts actual missing predecessor/successor positions; the two-edge bound remains conditional on the count. No arbitrary lookup topology is declared to have exactly two boundary edges.

The constant-flux hyperbolicity lemma belongs in the existing ConservationLaws/Hyperbolicity.lean owner. Its actual zero derivative and standard basis are already checked. This avoids importing the entire artificial-bias example merely to show zero physical flux is hyperbolic.

The new example geometry reuses canonical finite Cartesian measures, shared faces and interval grids. Its h=1/(n+2), growing integer box and buffered target are concrete example choices, so they remain under Examples. The zero-law family and spatially nonconstant stationary field are a complete applicability fixture. The separate identity-flux moving example and small-bias construction remain preserved successful evidence; promoting them is not required for the zero-family primary application.

The geometry currently reuses HighResolutionAdvectionLine for its grid/mesh constants and interval bounds. This is genuine producer reuse, but imports the older interval-quality owner into the **example** closure. It does not justify a dependency from the new generic core to that owner. The five-owner regularity repair must be tracked separately; if later reducing the example dossier, replacing an axes projection by its definitionally equal CFLUnitShift.grid is a reviewable proof/import optimization, not a reason to duplicate interval estimates now.

## Source and compatibility boundaries

The current source wrapper describes common-area LineRealization and controlled quality including stability. The proposed replacement has a different contract: actual measured capacity methods and fixed-law physical refinement, with stability used only for conditional analysis. The same source declaration name is an intentional type change, not a theorem-preserving alias. Preserve the complete old source bytes, audits and decisions, then bind a fresh audit to the final replacement.

The capture viewed the five-declaration sweep and initial wrapper. Root subsequently announced the exact additional ValidSubsteps/admitted_specification layer so the source use has actual positive within-horizon durations and admission of the executed intermediate arrays. Those final types/native receipts remain pending inputs to promotion; this review does not silently certify the earlier view as the finished admitted contract.

Canonical documentation must describe **supplied measured directional balances**. The fixed tensor/normal binding keeps the law consistent across levels; it does not by itself prove continuum PDE equivalence, valid geometry for every conceivable grid, or hyperbolicity after integrating arbitrary Jacobians. Mesh size is the actual finite maximum of diameters, never a ghost filler capacity. Boundary regions are measured inputs, and concrete adjacent-region identities belong to the Cartesian example.

Genuine smoothness must remain the explicitly coerced ENat infinity, not the outer WithTop infinity. Uniform C and threshold N precede all later levels and admitted time steps. Positive projected-input availability prevents an empty admitted-time premise from masquerading as accuracy. The physical reference, numerical method, core order/oscillation and optional pairwise stability remain distinct.

The module policy preserves ComputationalMathematics paths, authored NumStability names, source-only correspondence and existing import compatibility. New scratch namespaces may acquire their approved NumStability semantic names; newly nominal structures require explicit maps/round trips and commuting operator/admission/projection checks. Existing five moved declarations are not renamed. No source-faithfulness result is inferred from layout or proof success.

## Evidence and remaining work

inputs.json binds 59 actual read views and policies, with complete snapshots for reviewed fragments. reuse-search.json records the current canonical-tree name/reuse query and its actual exit; misses are scoped textual observations. Existing native receipts are referenced as existing evidence, not replaced by new runs. The five-owner proposal and its successful isolated overlay are retained separately. No source fact was inferred from a web page or another textbook.

The next work is exact extraction, final admitted-source freeze, native transport/type checks and full joint application, followed by current graph/fingerprint/organization measurements and a new source audit. The repository-wide legacy ratchet is separate; this report does not manufacture empty finding lists or final counters. Root can adopt or refine this map without treating it as production authorization or final closure.
