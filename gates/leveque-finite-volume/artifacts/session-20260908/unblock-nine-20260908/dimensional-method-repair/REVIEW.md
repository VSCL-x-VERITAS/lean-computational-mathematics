# Substantive directional-method repair for dimensional splitting

This is an additive scratch candidate. The completed DIM audit remains undetermined, with Lean-to-source `no` and reverse implication `unclear`. No audit, gate, source wrapper or existing producer was changed. The proposed primary statement is `NumStability.DirectionalMethodRepair.directional_splitting_contract` in `Candidate.lean`.

## Exact finding and selected source

I read the frozen decision, report, task, original primary and its information/Cartesian companions, and viewed the exact raw page 28 rendering from the selected immutable book. Section 1.3 describes applying one-dimensional numerical methods successively along coordinate directions. Its nearby context also allows approximate Riemann methods. The original Q10 receipt selects supplied physical geometry and conservative coordinate execution. Neither source nor receipt replaces a directional numerical method by an arbitrary state-changing algebraic rule.

The adjudicator's major finding is substantive. The old primary quantifies over every numerical normal-flux function; its balance/locality identities also hold for a coordinate-index flux that decreases every cell despite constant input. The separately supplied information routine and Cartesian propositions do not add an equation/reference premise to that primary. The exact companions were available; recapturing their definitions would not repair the implication.

## New mathematical linkage

`PhysicalData` supplies a measurable partition of a physical domain, finite positive cell measures, shared-face parameter measures and physical point maps. A face point lies in both incident cell closures. The same indexed face flux is shared by its two neighbors. Its actual physical value is the face integral of the supplied normal flux applied to a physical reference field at those points. Hyperbolicity is `IsHyperbolicFluxOn` for that actual normal-flux function on its explicitly supplied admissible state set; no globally admissible or globally differentiable law is imposed. No normal vector, chart or coordinate transformation is inferred from an integer index.

The positive-dimensional primary receives a full-line numerical rule and an explicit admission predicate. It requires each actual intermediate input to be admitted and its numerical cell values to lie in the corresponding admissible state set. Constant consistency is required only at an admitted constant input with positive step, and identifies the numerical flux with the same actual integrated physical normal flux. It does not require admission on all constants or negative/zero durations.

For each executed positive substep, an independently supplied reference field gives:

- Integrable actual cell fields and spatial face integrands on that finite time interval, with state-domain membership at the used physical points.
- Cell averages defined by the existing normalized `cellVolumeAverage`, using the actual physical cell measure.
- Time-integrable shared physical face-flux traces and a physical cell/time integral conservation law. This reference condition contains no numerical update.
- An old numerical-cell-average error bound and a numerical-minus-time-averaged-physical-face-flux error bound. Neither premise mentions the next numerical output or assumes its error estimate.

The derived conclusion bounds the error of the actual update by
`oldError + dt / cellVolume * (leftFaceError + rightFaceError)`.
It follows from the weighted physical reference identity and the existing conservative numerical balance, followed by the norm triangle inequality. Large supplied errors yield weak bounds; no tolerance, convergence, order, high-resolution property or unconditional accuracy is asserted. The hypothesis is a meaningful conditional comparison to a separately conserved physical reference, not a certificate that merely repeats the desired output conclusion.

The same primary conjunction includes every stage's prefix-state execution, physical-volume mass balance, finite-line cancellation and strict line locality. It retains the nonempty finite schedule, supplied order, coverage of each direction and positive substep convention.

## Cartesian realization and nonvacuity boundaries

The primary also contains a conditional realization of the *same executor*: when its volume is the product of the supplied axis-grid widths and its numerical normal rule is the area-weighted full-line rule, the coordinate restriction equals the existing one-dimensional finite-volume update. The cell and transverse face measures are the canonical measured Cartesian values. `cartesian_reference` proves the independent cell/time reference balance from an actual supplied rectangle-conservative one-dimensional PDE solution, using its actual interval cell averages and area-weighted physical boundary fluxes. This bridge needs a flux function and its reference balance, not the older global hyperbolic-law structure.

`nonconstant_cartesian_reference` supplies a transported nonconstant step in either of two directions, using the already proved rectangle conservation law. The earlier canonical `LeftStateCoordinateSweep.left_two_stage_nonvacuity` still demonstrates genuinely changing two-direction numerical execution. These prove nonvacuity of the reference and execution components. They are not claimed to instantiate every premise of the new `PhysicalData` primary simultaneously. A full physical-partition/face-map Cartesian constructor is not included in this bounded candidate; the Cartesian branch is explicitly conditional on matching data. In particular it does not identify an arbitrary supplied `facePoint` with a chart.

`index_rule_not_constant_consistent` independently excludes the audit's coordinate-index rule on fixed physical-flux/unit-area faces, even at one chosen state: the same constant state's physical flux cannot equal both the zero-index and one-index outputs. A physical normal flux may genuinely vary with geometry; in that case its actual reference balance and explicit errors must be supplied. This is not an assertion that every spatially varying flux is invalid.

## Reuse and remaining scope decisions

Reused current producers are `CoordinateLineBalance.advance_mass_balance`, `finite_line_mass_balance`, `advance_line_local`, the existing `sweep`/`orderedOperatorSweep` executor, `CartesianCoordinateUpdate.cartesian_full_line_update`, measured `CartesianGrid` cell/face results, `cellVolumeAverage`, `cellWidth_smul_oneDimensionalCellAverage`, `IsHyperbolicFluxOn`, and the existing transported-step rectangle and two-stage examples. The current `riemannFiniteVolumeUpdate_error_le` has one-dimensional grid/global-reference premises, so it could not directly serve the generic finite-substep physical-cell geometry. The new small norm argument generalizes that weighted error calculation; it does not reprove integral or measure basics. Actual project and pinned Mathlib searches are recorded in the packet.

This fixes a real missing premise/consequence chain. It does not, by itself, prove that every bounded or periodic numerical grid is represented by the total `D -> Int` line arrays and disjoint physical partition. Such executions require an explicitly supplied extension/cover and compatibility evidence. The logical geometry, choice of oriented physical face flux, reference regularity/representatives and positive-step schedule remain modeling inputs, not printed specifications. The generic reference is a control-volume/time integral formulation; no arbitrary pointwise Cartesian PDE is attributed to curvilinear coordinates, and no common multidimensional solution evolution is asserted.

Before any fresh audit, root must review this exact contract, decide the transparent boundary/extension applicability in the Q10 interpretation, and make any additional physical-realization witness needed for the selected comparison. The selected source must continue to include directional numerical-method linkage and all original ambiguities. No accepted classification or genuine theorem-strengthening is inferred from this scratch proof.
