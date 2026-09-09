# Physical DIM canonical transport plan

Status: proposal for native comparison, not executed. This is an artifact-only implementation handoff under the root coordinator's bounded assignment. It is not a sealed code-review result, source-faithfulness judgment, production-placement receipt, or permission to change repository state. Source impact is material; faithfulness action is `new-audit-required`.

The exact frozen inputs are recorded in `inputs.json`. The adopted placement mapping remains immutable; its own historical proposal status is not rewritten. This plan uses the root-adopted mapping and the final admitted scratch source contract. Canonical owner snapshots and compiled files must be bound after their successful placement/build. No current canonical file is treated as an unchanged historical scratch dependency merely because it has the same path.

## Comparison boundary

There are three different claims to check:

1. The five existing `NumStability.FiniteCoordinate.LineCoordinates` declarations move owners without changing their fully qualified names, types, or authored bodies. Their new import closure is checked separately.
2. Newly promoted scratch structures have different nominal types. Explicit field-preserving conversions, round trips, and computational observations establish transport. No nominal structure equality is asserted by `rfl` merely from matching source text.
3. The final admitted physical-family source contract replaces the earlier rejected canonical target. The old and new source contracts are not claimed equivalent. Only the latest frozen admitted scratch proposal is transported to its canonical realization, followed by a fresh source audit.

The separately corrected C-infinity owners and explicit chooser body belong to the root's five-owner placement. Preserve their old evidence as historical; this comparison does not prove the old analytic regularity statement equivalent to the corrected one.

## Collision-safe comparison input

Start from small, pinned frozen fragments rather than concatenating an entire historical Candidate and importing all new modules. Import the final shared canonical owners. Retain the old nominal scratch namespaces at the root, and use explicit `_root_` qualification for old names where opened `NumStability` namespaces would otherwise introduce ambiguity.

The old `Ghost.lean.fragment` contains a complete namespace block defining the five `NumStability.FiniteCoordinate.LineCoordinates.withGhost*` / extraction declarations that are now canonical. Remove exactly that block, with original-byte offset, byte length, SHA256, and replacement import recorded. The original five moved declarations were imported by the scratch inputs; do not redeclare them. A read-only assembler must reject an absent, duplicate, or changed span. Do not globally replace occurrences of `NumStability` or a short namespace name.

Keep the old `PhysicalCapacityBridge`, `CapacityCoordinate`, `CapacityBoundarySweep`, `CapacityPhysicalMesh`, `PhysicalRefinementQuality`, and `PhysicalHighResolutionSweep` namespaces so their nominal objects can coexist with the new canonical ones. The shared generic physical data, finite-volume update, `LineCoordinates`, and sequential-error types are imported once. Retain old scratch aliases required by old proofs even if production intentionally omits them; evidence-only aliases do not become public producers.

The latest scratch source theorem has the same fully qualified name as the canonical target. If its proof/type is embedded, change only that declaration's binder to a unique comparison name, and remove/retarget its exact trailing check commands. Record this local binder change byte-for-byte. Alternatively, state the transported proposition directly after the generic equivalences. Never load two declarations with the source target's name.

## Ordered transport obligations

Use a dedicated `PhysicalDIMTransport` comparison namespace. The names below are proposed comparison-only API names, not promised native results.

### 1. Shared data and pure observations

Bind the old/new type and authored-expression fingerprints for `LineCoordinates`, `extract`, `extract_cell`, `extract_local`, and `extract_error_le`. New-only `withGhost` definitions must match the exact frozen scratch namespace block, with old/new import smoke checks.

Before constructing dependent maps, prove equalities for old/new capacity lookup, face-rule extraction, line advance, physical mesh, net flux defect, and shared variation. The first four preserve actual measured volume and supplied integrated flux. Missing-index capacity remains the documented totalizing value 1; it is not used to identify physical mesh. The mesh comparison retains the same `Fintype` instance and finite supremum of actual cell diameters.

### 2. Incidence

Map `_root_.PhysicalCapacityBridge.Incidence data coord` to and from `NumStability.FiniteCoordinate.PhysicalLine.Incidence data coord` by its four fields: `left_line`, `right_line`, `left_index`, `right_index`. Prove both round trips. These are propositions, so proof irrelevance is available; record the actual successful proof rather than preclassifying it as definitional equality.

### 3. Method

Map `_root_.CapacityCoordinate.Method data coord` to and from `NumStability.CapacityCoordinate.Method data coord`. Convert only `incidence`; retain `numericalFlux` and `admitted` literally. Prove round trips and commuting observations for both raw fields, `rule`, `Admitted`, `StableAt`, and `withGhost`. Prove the physical update and line advance equalities on the same direction, duration, input array, face/cell, and supplied ghost values.

The `withGhost` comparison is dependent: its result is indexed by `coord.withGhost ghost`. Keep that index identical; do not coerce by an unproved equality. No exact-consistency, total availability, fixed CFL, perturbation stability, or full returned-field premise may appear in these maps.

### 4. Family

Construct `Family.toCanonical` and `Family.toDraft` explicitly. Retain all dependent index families (`Cell`, `Face`, `Line`), `finiteCell`, physical data, coordinates, measures, state sets, tensor flux, normals, regions, horizon, and boundary regions. Map each level's method by the Method conversion. Transport only proof fields that mention the renamed mesh or method definitions. There is no reindexing of cells or replacement of the measure/reference class.

Prove both round trips. Use proof irrelevance for proof fields and the Method round trips for method fields, with explicit dependent casts where native Lean requires them. Retaining `finiteCell` is important: variation and maximum diameter use this actual instance. Prove exact field observations before using them to transport higher structures.

Then prove `projected`, `referenceGhost`, and `variation` commute. `referenceGhost` must remain the actual average of the same boundary region at time zero. The shared once-per-edge variation must preserve both exterior boundary contributions and its missing-neighbor branch. Prove `SmoothReference` iff with the exact inner-infinity C-infinity order, closure/region/horizon, all-level `ReferenceOn`, and boundary integrability.

### 5. AccuracyCertificate

For the mapped family, direction, fixed reference, and exponent, construct both certificate maps. Copy `constant` and `threshold` unchanged. Transport `constant_nonneg`, `projection_available`, and `bound` through the already established observation equalities. Prove both round trips, allowing explicit index transport across Family round trips.

Required observations expose the same C and N and the whole `forall n >= N, forall positive admitted dt <= horizon` bound. Also transport positive projected-step availability at N. Do not replace this structure with an existential chosen after a selected level or execution. The optional `perturbed_at` corollary uses that same certificate, same actual/reference duration, and both cell and ghost errors.

### 6. HasHighResolution

Give an iff (or explicit mutually inverse Prop maps) for the mapped families. For `input_available`, preserve the actual-state and missing-lookup ghost-state premises and the same positive step witness. For `order`, preserve the per-direction p > 1 and every genuine fixed reference, mapping each `Nonempty AccuracyCertificate`. For `oscillation`, preserve K, noise, convergence, same admitted duration, and exact variation observations. Stability remains a separate optional assertion and must not become a field or premise of the quality equivalence.

### 7. Stage-dependent sweep, Specification, and ValidSubsteps

First compare generalized old `CapacityBoundarySweep.step/run` with canonical `NumStability.CapacityCoordinate.Sweep.step/run` on pointwise mapped methods and the same stage-dependent coordinates. Prove run equality by its recursion or a checked definitional equality. Separately retain the old fixed-coordinate run as its constant-coordinate specialization; do not introduce another production executor.

Next compare family `coordinates`, `method`, and `execution` with the same selected level, directions, durations, stage ghosts, and initial array. Preserve every intermediate state. `ValidSubsteps` then transports its positive/horizon clauses and admission at that actual intermediate state.

Construct both `Specification` directions field by field: `quality`, `schedule`, `ordered`, `constituent`, `conservative`, `line_local`, `accuracy`, `physical_error`, `cartesian`. Its `accuracy` field quantifies over certificates of a nominally different family: use the inverse certificate map, retaining C/N, rather than assuming the binder type is equal. Preserve all conditional physical reference, admission, stability, net-defect, initial-error, and splitting-defect inputs and the same sequential error budget. The Cartesian component refers to the unchanged physical data and identification, actual volumes/means/face integrals, and rectangle-balance lift; no independent continuum-PDE equivalence is added.

Finally compare the latest admitted scratch source proposition to the canonical source proposition through the Family/quality/Specification/ValidSubsteps maps. The positive state dimension, positive direction count, exhaustive schedule, and actual admitted positive substeps must all survive. Apply the actual canonical source theorem to the promoted zero-flux refining family in a new joint artifact; preserve the frozen nonconstant moving CFL consumer as separate evidence, not as an all-quality assertion.

## Required execution evidence

Root first supplies successful placement/topological-build receipts, exact final owner inventory, and current source/olean closure. A new comparison run must pin these independently of the old frozen receipt references. Do not execute historical finalizers that expect pre-placement canonical bytes.

Each comparison module needs actual native Lean output, exit, timestamp, command and environment; dependency source/olean pins before and after; every authored declaration type and axiom report; preserved failures; and a final immutable summary. Only the usual `propext`, `Classical.choice`, `Quot.sound` or empty axiom lists are allowed. Proposed `rfl` checks are successful only after actual Lean output; a proof using extensionality/propositional transport is recorded as such. No broad build is needed solely for this plan; root owns the final full build and organization checks.

Final acceptance criteria are the seven ordered groups above plus unchanged-FQN import compatibility and the canonical joint source application. Native comparison evidence establishes the specified transport only. Fresh source judgment, gate closure, organization, fingerprints, reconciliation, and publication remain with their owning workflows.

## Current findings and limits

- The nominal conversion boundaries are Incidence, Method, Family, AccuracyCertificate, HasHighResolution, and Specification. Shared physical data and LineCoordinates are reused, not renamed.
- The generated comparison must remove the exact shared ghost namespace block to prevent duplicate declarations; retaining full historical Candidate files is provenance, not a license to import them unchanged.
- Family/certificate dependent transport is the largest proof obligation. Keeping all indices and numeric witnesses unchanged is the minimal strategy.
- The source replacement is material and needs a fresh audit. No comparison with the original rejected source proposition is planned.
- The root's five-owner build is independent and was running when this plan was prepared. Its eventual success and the later canonical proposal placement are prerequisites, not claimed observations here.

Read-only review lenses: semantics/non-vacuity, API/Mathlib alignment, dependency direction, compatibility, and source-impact boundary were completed for this bounded transport plan. Native proof robustness is pending the actual comparison implementation. Performance and new source adjudication were not run.
