# Independent review of the physical-capacity bridge

The six checked theorems establish the advertised algebraic bridge. I found no correction needed in their statements or proofs. They remove the common-area factorization from the active-cell update/projection correspondence. They do not yet remove that restriction from the high-resolution primary, whose current `LineRealization` still requires it. This is a mathematical/API review, not a source-faithfulness judgment.

Reviewed manifest: `39a08aa44e0241d08a6c85c7ae57f10ee3f88623d062906554c0d3f184dc7c62`. Reviewed complete source: `c6c77dae3873f36b6535ecd8e38cf1db030347022ac3904829b0134a129714fc`. The native-02 receipt actually records exit 0 and binds output `5f062c8e9c58339a4b3e4fd33fa8274c985f9cee2d6d2405899df466b37e1406`; the six exact axiom reports contain only allowed axioms. My read-only binding check exited 0 and bound 18 inputs. No new Lean run, source modification, or semantic role was performed.

## What the bridge actually proves

- `capacity` / `capacity_cell` (lines 20/34) use `data.cellVolume` at every successful lookup. `lookup_cell` gives exact equality at every active cell. Positivity follows from the actual positive finite cell measure. Capacity is not an independently chosen surrogate for active-cell geometry.
- `faceRule` / `lineAdvance` (lines 40/46) use the very supplied numerical flux, evaluated on the extracted current line, at its actual left and right integer face indices. `dt` is an explicit argument to both the routine and update.
- `advance_eq` (line 55) uses the four stated incidence equalities to identify the two faces, the exact physical capacity, and the current active-cell value. It is a definitional algebraic equality for every supplied numerical flux and every real `dt`. It contains no accuracy claim, area cancellation, flux-averaging closure, or inference that an integrated nonlinear Jacobian is hyperbolic.
- `projection_cell` (line 66) identifies the same active-cell average formula used by `PhysicalData.cellMean`, with its actual physical measure and region. It is valid for arbitrary `q` as an equality of totalized definitions. To interpret this as the integral mean of a physical reference, the later `PhysicalData.ReferenceOn` supplies the required integrability; the equality itself does not prove integrability.
- `advance_line_local` (line 75) is locality with respect to the entire selected coordinate line, reusing the guarded lookup and fixed supplied ghost values. It does not prove a particular finite stencil or independence from changes to the ghost function.
- `weighted_mass_balance` (line 85) is exactly the existing finite physical mass identity, retaining the full sum of face differences. It does not set exterior transfer to zero or assert boundary conditions. Incidence is unnecessary for this algebraic mass statement; separate shared-face counting is needed to rewrite the sum as a particular exterior-boundary formula.

The `Incidence` premise is still substantive coordinate compatibility. It represents path-like integer-indexed lines with left face `j` and right face `j+1`. It is not automatically available from arbitrary `PhysicalData`, nor does the bridge construct an indexing for periodic or branching incidence. This is a narrower issue than the removed common-area restriction and should remain explicit in any adapter.

## Ghost and physical-flux limits

The fallback capacity 1 is used only when `lookup` returns none. It harmlessly totalizes `lineAdvance` outside actual cells, but supplies no measured ghost region, spatial scale, reference projection, boundary accuracy, or CFL bound. `projection_cell` only covers successful active-cell lookup. A later accuracy input window containing absent cells must provide a physical extension/projection or retain independent ghost-error bounds. An interior-only accuracy statement may instead prove that every used input is an actual represented physical cell. Neither option follows from the dummy capacity.

`faceRule` is a numerical rule. Calling its values already integrated means that no later line-area factor is applied; it does not prove comparison to `PhysicalData.faceFlux`. That comparison must use the actual physical face integrals of the reference, with their integrability and balance. In general an integral of nonlinear physical fluxes cannot be identified with the flux at a cell average. Nor does pointwise normal-flux hyperbolicity imply hyperbolicity of an integrated or averaged Jacobian.

The current coordinate map need not make the pair `(faceLine, faceIndex)` injective on face IDs. Thus different face IDs with the same pair receive the same numerical output. This is compatible with the algebraic theorem, but a proposed single line reference flux must either prove the relevant physical face traces agree for such aliases or avoid collapsing them. The direct finite physical reference/error APIs already keep the actual face IDs and do not need that extra identification.

## Smallest next mathematical increment

The first useful extension can remain a thin theorem family, without defining a large new quality framework. Reuse `PhysicalData.ReferenceOn`, `advance_mass_balance`, `PhysicalCapacityBridge.advance_eq`, and `projection_cell` to expose the exact capacity-weighted error identity on the selected active cell. For physical means `qbar_s`, `qbar_t` and actual time-averaged physical faces `Phi_L`, `Phi_R`, it is

`V • (lineAdvance U - qbar_t) = V • (U_j - qbar_s) + dt • ((Fnum_L - Phi_L) - (Fnum_R - Phi_R))`.

The same-law reference, measured projection and actual time interval must be the same inputs on both sides. This identity is already present inside `FiniteCoordinate.advance_error_le`; extracting/reusing it should avoid duplicating integration proofs. That existing theorem immediately supplies a sufficient bound by `oldBound + dt / V * (leftBound + rightBound)`.

Keep the **net** flux defect available before taking that triangle inequality. Making separate face errors of order `V * h^p` compulsory would be a stronger class than merely controlling their signed difference, and could discard cancellation that gives the claimed local order. Separate face-error estimates are useful sufficient hypotheses, not the definition of every high-resolution method.

After this small increment is reviewed, a capacity-family quality interface should use those actual measured projections and the capacity update directly, rather than requiring a common-area witness to apply the existing width-based `LineFamily` theorem. Its required content is:

1. A genuine physical refinement scale and fixed-region coverage tied to the actual cells. Positive volumes alone do not imply shrinking physical diameter or uniform geometric quality. In higher dimensions, time-step control involves integrated face transport relative to volume; replacing it by `dt <= C * volume` or a fictitious unit-area grid is unjustified.
2. Explicit input/active windows and physical or independently bounded boundary/ghost projection. The supplied routine, supplied time step, projected input and actual update must remain connected.
3. A fixed mathematical smooth-reference condition on the relevant physical domain, together with actual physical integral balance. Do not replace it by an arbitrary eligibility predicate. The present generic `Point` has only topological/measurable structure, so a smooth-order branch needs an explicitly suitable physical differentiable space or a separately proved restriction/projection bridge; it cannot silently infer a chart.
4. Uniform higher-order defect constants quantified before refinement levels and supplied admissible time steps, plus actual admission, perturbation stability and oscillation bounds. Their numerical operator must be this capacity update. No unrestricted existence of accurate solvers on all geometries is supplied by the bridge.

Laplace is independently handling state- and time-step-dependent admission and stability/oscillation at the same supplied `dt`. I communicated the ghost-capacity boundary and am not duplicating that work. The capacity/projection extension should accept that admission interface rather than reintroducing a single state-independent CFL choice.

The Cartesian family can remain a concrete sufficient instance, with its actual volume and physical-face identities proved explicitly. The generic capacity branch should not require averaging to preserve hyperbolicity, a chart for every logical grid, or an area-one reinterpretation of all physical face laws. Appending this bridge as an unrelated conjunct while keeping `LineRealization` compulsory would not remove the primary's common-area domain condition.

## Reuse and evidence limits

The implementation correctly reuses `finiteVolumeCellAverageUpdate`, `LineCoordinates.lookup_cell`, `extract_cell`, `extract_local`, and `FiniteCoordinate.finite_mass_balance`. The current `CoordinateLineBalance` already supports arbitrary supplied volumes on a tensor-indexed array, but does not itself identify guarded finite physical lookup/projection with the actual measure. The current `LineRealization.advance_eq` proves the older area/width-scaled correspondence and is not an equivalent replacement. `FinitePhysicalReferenceError.advance_error_le` and `LocalCellErrorBounds.norm_le_of_weighted_error_balance` are the next selected producers; the norm infrastructure found in pinned Mathlib is already below those owners. Searches were scoped and do not establish global absence.

One provenance limit is explicit in `verification.json`: the original native-02 receipt records the input path, exit and output hash, but not a pre-execution source hash. The current command-path source and frozen manifest copy agree exactly, and I checked the six named output reports. This review does not reconstruct a missing runtime source pin or pretend to rerun that proof. Any future canonical placement should use the ordinary fresh input-bound native checks, as the root packet already requires.

No broad new API was implemented. The current bridge is a sound small foundation; full capacity-family order/oscillation and source-domain closure remain subsequent work.
