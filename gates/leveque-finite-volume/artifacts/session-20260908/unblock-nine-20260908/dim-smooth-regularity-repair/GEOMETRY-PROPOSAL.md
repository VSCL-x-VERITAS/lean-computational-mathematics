# Geometry: concrete bounds and repair options

This is a mathematical/API diagnosis, not a source-faithfulness decision or an interpretation receipt. Q10 does not supply a chart/Jacobian definition or a universal construction theorem. Its actual fields are pinned in `source-and-mathlib-pins.json`.

## What the existing realization really requires

`CoordinateLineMethod.LineRealization` links a supplied physical datum and actual integer line coordinates to supplied one-dimensional families. Its sufficient hypotheses are explicit:

* one positive normalization `area d line` per line;
* `data.cellVolume cell = area × family.grid.cellVolume index`;
* shared left/right face indices and membership in the selected active window;
* equal selected step duration across the lines in one direction;
* for every state, an integrable physical normal flux whose face integral equals `area • family.flux(faceCoordinate) state`;
* exact equality of the physical and family admissible state sets.

These hypotheses are used to prove the actual operator equality `LineRealization.advance_eq`. The common area is not asserted to equal a geometric face measure, but it is an algebraic conversion factor. The restriction is therefore not removable by changing its name.

The coefficient calculation is concrete. The physical update uses `dt / Vcell` times integrated face fluxes. An ordinary one-dimensional family uses `dt / Δxcell` times its numerical face fluxes. Multiplying both face fluxes by one line factor `A` yields the same operator only when `Vcell = A Δxcell`. Allowing arbitrary face factors generally loses this equality; dropping it while repeating the same conclusion would be false. Choosing `A=1` merely moves the unproved obligations into constructing a grid with widths equal to supplied volumes, compatible physical face laws, synchronized family steps, projections, and a high-resolution quality proof for that changed family.

In particular, `PhysicalData.hyperbolic` is pointwise in the face parameter. It does not prove hyperbolicity of the integrated face law. Even for linear two-component fluxes, two real-diagonalizable matrices may have a non-real-diagonalizable average: the matrices `[[1,2],[0,-1]]` and `[[-1,0],[-2,1]]` each square to the identity, while their average is `[[0,1],[-1,0]]`. Thus a construction may not infer integrated-law hyperbolicity from pointwise hyperbolicity. This elementary diagnostic calculation is not a new Lean theorem or a claim about the source's physical models.

## Recommended minimal broadening if arbitrary supplied Q10 volumes must be covered

Introduce a **physical-capacity line method** as an additive generic API, retaining the old unweighted `LineFamily` and its adapter. Its update should be the existing `finiteVolumeCellAverageUpdate` with an explicit positive capacity `V n j`, rather than obligatorily the coordinate width. The supplied one-dimensional numerical routine remains the very `numericalFlux n values j` used in that update; no unrelated operator or assumed desired conclusion is substituted.

The necessary data and proof boundaries are:

1. Ordered coordinate cells and shared face indices, a positive finite physical capacity for every used cell, fixed actual incoming/active windows and genuine mesh/coverage data. Coordinate mesh width and physical capacity are distinct quantities. Keep all ghost/exterior inputs explicit.
2. A physical line measure or actual measured-cell realization with `capacity = measure(cell)`. Define its initial projection by the existing `cellVolumeAverage` under that measure. Smooth references satisfy the actual local measured conservation law and explicit C∞ condition. Do not normalize by coordinate length unless a bridge proves equality of the two measures/capacities. A merely chosen positive array plus the old unweighted projection is insufficient.
3. Integrated numerical face fluxes on that same line; physical reference face fluxes stay independent and come from the supplied physical law. State-integrability and hyperbolicity of any effective integrated law are explicit properties of that law, not consequences silently inferred from facewise data. Where only pointwise normal hyperbolicity is known, keep physical flux comparison directly against the existing measured `PhysicalData.faceFlux` and do not manufacture an integrated hyperbolic Riemann law.
4. Reuse the current order/stability/oscillation quantifier order for the **actual capacity-normalized operator and actual physical projections**. Supplied quality applies to that method itself. A later projection/reference-to-physical error can be separate, but must be bounded and included in the recurrence; changing normalization is not automatically accuracy-preserving.
5. Realization into finite multidimensional data identifies the capacities with `data.cellVolume` and the very shared integrated numerical flux with the executed rule. Then `advance_eq` follows by unfolding the same update, with no common-area factorization premise. All weighted mass identities, finite shared-face cancellation and direct physical flux-error estimates already exist in `FinitePhysicalUpdate` / `FinitePhysicalReferenceError`; reuse them. The existing chronological and sequential-error proofs are algebraic and should transport with the new exact operator link.
6. Give an adapter from the old uniform-area model using capacity `A Δx` and measured projection scaling, and replay the present scalar CFL-one family as the special case `A=1`, Lebesgue measure. Prove the adapter's actual projection, update, smooth-reference and quality links; copying the old quality witness without those links would not repair the gap.

This is the smallest substantive route identified that removes the volume factorization from the general physical model while preserving real one-dimensional method execution. It requires bounded new definitions/adapters and a fresh quality witness; this proposal does not claim those proofs are already present. No arbitrary eligibility predicate or unbounded full-field extension is proposed.

## Smaller construction, with a narrower established scope

An independently useful shorter step is a general **Cartesian realization constructor** from actual tensor-product coordinate grids and explicitly compatible supplied line families. Existing `FiniteCartesianGeometry`, `FiniteCartesianReference`, cell-volume product and face-integration identities supply the physical volume/area/flux equalities. The constructor must derive transverse line area from actual coordinates, show shared face/index compatibility and use each supplied family's actual selected grid and duration. It must work for general finite positive dimension and finite active cells, rather than merely the existing Fin 1 witness.

That establishes realizability for the rectangular branch and clarifies which assumptions are ordinary method/grid compatibility. It does not establish every unspecified logically rectangular Q10 geometry. The source target must not turn this constructor into an unrestricted logical-grid coverage claim.

## What can be reused without either construction

The existing `FinitePhysicalUpdate.advance`, `finite_mass_balance`, `sweep`, `sweep_split`, locality and measured reference-error results already apply to arbitrary supplied positive physical cell volumes and shared fluxes. They can expose a broad conservative-execution clause without `LineRealization`. The existing high-resolution clause can separately state its actual supplied compatibility assumptions. This makes the domain honest and avoids hiding the stronger model inside a generic label, but a broad execution-only clause does not by itself prove high-resolution coverage on arbitrary logical geometry. Whether the source's conditional method construction is fully captured by that explicit pairing remains a source-audit question, not something to decide by adjusting an acceptance label.
