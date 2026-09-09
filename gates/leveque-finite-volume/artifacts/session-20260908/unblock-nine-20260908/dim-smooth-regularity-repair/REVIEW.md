# DIM regularity repair diagnosis

The regularity issue is confirmed. The production definitions currently require the outer top of `WithTop ℕ∞`, denoted `ω`, whereas C∞ is the coerced inner top `((⊤ : ℕ∞) : WithTop ℕ∞)`, denoted `∞` in the `ContDiff` scope. This is a mathematical domain change, not a cosmetic notation or printer repair. No production file, frozen audit, gate, ledger or Git state was changed.

## Exact pinned meaning and source scope

Pinned Mathlib `Analysis/Calculus/ContDiff/FTaylorSeries.lean:112–114` defines the two scoped notations. `ContDiff/Defs.lean:90` explains them, and its `ContDiffWithinAt` definition at line 131 separates the analytic outer-top branch from every finite-order requirement in the coerced ENat branch. `contDiffOn_infty` identifies C∞ with all finite differentiability orders. `contDiffOn_omega_iff_analyticOn` provides the analytic characterization under `UniqueDiffOn`; no unrestricted within-set analytic equivalence is assumed here. The native probe confirms `∞ < ω` and `ContDiffOn ℝ ω → ContDiffOn ℝ ∞`.

The actual images inspected were raw page 28/printed 6 and raw 125–126/printed 103–104. Section 1.3 describes successive one-dimensional coordinate solves on rectangular or logically rectangular grids. Section 6.3 discusses accuracy on smooth portions and controlled behavior near discontinuities. Neither image adds analyticity. The literal high-resolution answer requires order greater than one on smooth solutions and quantitative oscillation control, without selecting a norm, limiter, CFL bound or universal existence result. Q10 separately supplies coordinate connectivity, physical volumes and shared normal face fluxes. C∞ is the proposed standard smoothness realization; this review is not a new source verdict or a new literal user answer.

## Minimal proposal copies

The `proposed/` tree contains only four complete file copies. `before/` preserves their original bytes. Nine annotations change from `ContDiff[On] ℝ ⊤` to the fully explicit `ContDiff[On] ℝ ((⊤ : ℕ∞) : WithTop ℕ∞)`:

| Owner | Changed occurrences |
| --- | --- |
| ConservationLaws/LocalRectangleReference.lean | `SmoothReferenceOn` line 34 and `SpatialSmoothReferenceOn` line 51 |
| ConservationLaws/LocalLinearAdvection.lean | `smooth_reference_interior`, `interior_partials_continuous`, `interior_differentiableAt`, `interior_mass_derivative` |
| FiniteVolume/Examples/CFLUnitShift.lean | `smoothProfile_smooth` and `smooth_refinement` |
| FiniteVolume/Examples/HighResolutionAdvectionLine.lean | the local `hc` annotation in `smooth_local_reference` |

The explicit coercion avoids requiring a new alias or a scoped notation change. An equally meaningful spelling would use `open scoped ContDiff` with `∞`; bare `⊤`, `ω`, and `(⊤ : WithTop ℕ∞)` remain analytic and are unsuitable for this repair. Rectangle conservation, state domains, finite windows, norms, constants, geometry and numerical updates remain byte-identical in the proposal except for these nine substitutions. `RefiningLineMethod.lean` contains no direct outer-top token: it inherits the domain through `SpatialSmoothReferenceOn`.

## Checked proof impact

One scratch file copied the full local-reference and local-advection bodies into a new `NumStability.DimSmoothRepair` namespace. Apart from namespace adaptation and the explicit regularity parameter, the local proof tactics are unchanged. Native `lake env lean` exited **0 in 33.52 seconds**, without warnings or errors. It checked the interior first derivatives, differentiating local mass, rectangle-to-classical equation, backward characteristic propagation and local cell-average shift with C∞. These proofs use continuity, differentiability and a continuous first derivative; they do not require analyticity. Eleven axiom reports were printed: two empty, nine using only the allowed `propext`, `Classical.choice`, `Quot.sound` set.

The production family quality proof and full source/joint application were **not rebuilt**. Static inspection shows that `family_quality` uses the now-checked local cell-average bridge and algebraic geometry/TV estimates. Its polynomial nonconstant fixture uses `contDiff_pi`, `contDiff_id` and composition, which work at arbitrary differentiability orders. This is good reuse evidence, but not a substitute for the eventual native family/source/joint replay.

All 16 owners were inspected through their exact frozen inventory. Nine lie in the import closure of the four proposed files: the four direct files, `RefiningLineMethod`, `CoordinateLineMethod`, `CoordinateLineMethodEstimates`, `HighResolutionCoordinateSweep`, and the source wrapper. The other seven owners have unchanged independent interfaces; the eventual 16-owner focused closure must still rebuild against the repaired definitions.

`expression-impact-v2.json` is the authoritative explicit type/body dependency analysis. It streams and verifies the full 576,230,699-byte native archive against SHA256 `2ca9699d281313d776a0452d6e4ed1ee6f124748fee458d8f1b203f37c51c2f4`, retaining 293 constants and identifying 31 dependent constants after adding the changed inductive quality predicate as a structural seed. The preliminary `impact.json` list of 23 inspected only stored type expressions: the fingerprint JSON contains body hashes, not bodies. That limitation is explicitly corrected rather than overwriting the preliminary artifact. A dependency change does not imply every alpha-structural type/proof hash changes: references to unchanged declaration names can have unchanged syntax while their imported definitions change. New owner/dependency pins and a fresh audit are therefore required even for an unchanged source-wrapper byte hash.

The 46 matching historical scratch files in the scoped search remain untouched. This covers relevant named DIM/CFL/reference/production scratch directories, not an exhaustive absence claim. In particular, the old Quality snapshots, local bridge proofs, joint application and old source audit stay historical. The old source joint application imports the production quality witness; it needs a successor replay, not relabeling as C∞-checked evidence.

## Independent remaining issues

The frozen round-trip `r_final.json` is an undetermined, nonaccepted role result, not a final verdict invented by this review. Its D020 choice issue has an existing exact theorem: `LineFamily.stabilityRate_spec` identifies the selected value and its entire admitted-data stability predicate. The production `stabilityRate` uses `Classical.choose quality.stability`; no mathematical connection is missing. Its predicate was elided in the blind dossier. A printer/interface supplement that actually reaches blind translation is separate work; this packet changes no stability definition.

Geometry remains independent and is addressed in `GEOMETRY-PROPOSAL.md`. C∞ alone does not establish that all Q10 logical geometries admit the current `LineRealization`. The family-wide estimate is genuinely eventual in refinement; its fixed executed-level corollary remains conditional on meeting the reference-dependent threshold. A scalar nonempty witness does not certify accuracy at every arbitrary selected level or establish universal geometric representability.

After root reviews the proposal, necessary next work is a controlled canonical repair or additive successor owners, current focused builds and the full joint source application, renewed exact fingerprints and organization/dependency receipts, and a fresh source audit preserving the original result. No old record should be rebound as though this were a pure move or mere notation change.
