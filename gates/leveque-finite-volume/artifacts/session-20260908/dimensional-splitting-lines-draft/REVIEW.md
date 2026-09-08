# Coordinate-line finite-volume foundation

This scratch draft repairs the concrete missing-operation defect found by the
sealed DIMENSIONAL-SPLITTING audit without claiming that a tensor-grid special
case closes the source's full rectangular/logically-rectangular discussion.
The prior decision `f4bc6e665499951d8ddf5a80cba2f0c5ed5d548e97fef9fb9984a7b22012ccf8`
and every prior audit artifact remain unchanged.

## Primary-source facts

The exact task selects raw PDF page 28, printed page 6, Section 1.3. Its actual
image was viewed; raw page 27, printed page 5, was also viewed for the finite
volume and adjacent-state Riemann construction. The pinned PDF is
`b3adec0d3616dbde57a5522cfce1861890887d7c03a2232d2136cb94c9bac1d5`.
Printed page 5 describes numerical cell averages and flux-based updates.
Printed page 6 describes one-dimensional Riemann problems normal to cell
edges/faces and defines dimensional splitting by coordinate problems solved
in turn, for rectangular or logically rectangular grids. It points to a later
discussion and does not define the latter geometry on the selected pages.

## Concrete reviewed contract

For a finite set D of directions, let cell indices be `D → ℤ`. Each direction
has an actual adjacent one-dimensional interval grid, with strictly positive
cell widths. A tensor cell is the Cartesian product of its half-open intervals.
The draft proves its Lebesgue volume is the product of those widths and is
positive. It also supplies the actual normalized volume-average reference for
any field integrable on that cell. Numerical arrays are independently supplied
approximations; they are not assumed equal to the reference at every stage.

Fix a direction d. The input to its one-dimensional solve is exactly

`line(d, base, U)(j) = U(base with coordinate d replaced by j)`.

For each adjacent pair on this line, the solver constructs the actual ordered
Riemann problem for a differentiable physical flux whose actual Jacobian has
a complete real eigenbasis. Its returned field has the exact left/right
initial trace and rectangle conservation. The computed face flux is explicitly
the physical flux of that same returned solution on ray zero at time 1.
The existing constant-state flux consistency remains required. This is an
explicit exact-interface solver class, not a definition of all high-resolution
or approximate solvers. No entropy, accuracy order, CFL, or convergence result
is asserted by this foundation.

The whole-state directional operation reads those same line data and applies
the existing one-dimensional conservative finite-volume update. The duration,
directional cell width, numerical cell state, and both adjacent face fluxes
occur in the actual formula. It proves both forms:

`width_d * U_next = width_d * U_old - dt * (F_right - F_left)`

`cell_volume * U_next = cell_volume * U_old - dt * face_area_d * (F_right - F_left)`.

Restricting the full updated array to any line is exactly the one-dimensional
update of that input line. In particular, changing other lines cannot change
this line's result. These are semantic conditions on the executed operation,
not incidental consequences of a generic schedule.

The old `CoordinateHighResolutionMethod`/schedule/execution types are reused
only as generic execution machinery: their maps are now constructed from the
proved line update. A scheduled fractional request is passed as `fraction*dt`
to the numerical update. The concrete sweep uses fraction 1 for each direction
in the given exhaustive order, a single first-order ordered sweep. For every
scheduled stage and every intermediate input state, the exact line-update
identity holds. The two-direction result explicitly composes the second solve
on the first solve's output. The legacy type's name does not confer an unproved
high-resolution property on this concrete construction.

## Nonvacuity and broadcast exclusion

The existing explicit eigenbasis linear Riemann solver supplies the new
interface structure. The draft reuses the previously frozen selected-linear
rule exactly, including its theorem that the numerical flux equals the time
average of the physical flux of that particular returned solution for every
positive duration. This does not identify it with an independent global exact
solution's trace or add an unproved accuracy claim.

The concrete inhabitant uses two coordinate directions, unit Cartesian cells,
and the scalar identity-matrix hyperbolic PDE in each direction. A stripe array
is 0 on transverse index 0 and 1 elsewhere. On the horizontal line at transverse
index 1, the actual directional update remains 1 for every admitted solver and
every duration. Broadcasting the origin would give 0 there. A checked theorem
therefore excludes the precise broadcast operation admitted by the old audit
target, uniformly over this solver class. A concrete solver and complete
two-direction execution jointly inhabit the stronger premises.

## Reuse and proof provenance

The complete frozen prerequisite file
`finite-volume-flux-error-estimate/combined-check.lean` is included byte-exact
as a compilation prefix, SHA
`e39e864134339eb5a6c639db0c995ffdf138b70cbebc407db72efd95c4afca22`.
It contains the unchanged prior update candidate
`f90dbaa19d16da3617dac27e982557ebe501249afb03566b9bdb6b191ae935be`
and the selected-solver/error foundation. The new weighted update theorem
directly applies `FVFluxUpdateDraft.numericalUpdate_mass_balance`; the linear
rule and its time-average identity directly reuse `FVFluxEstimateDraft`.
No earlier scratch file is edited.

Canonical reuse includes actual grids/normalized averages, certified rectangle
Riemann solvers, adjacent-cell problems, conservative flux differences, and
the existing sweep machinery. Mathlib supplies function-update laws, finite
products, and actual Cartesian box-volume normalization. Current-tree and
pinned Mathlib searches are preserved separately; failure to find an exact
existing tensor-line wrapper is not claimed as global absence.

`TensorLines.lean.fragment` is intentionally a scratch fragment depending on
those frozen prerequisites. `run-check.py` assembles its exact checked input,
records native commands and actual exits, and preserves every failed and final
attempt. Parent-owned production integration should introduce the generic
prerequisites first and then split tensor geometry/reference averages, line
solver adapters, directional update/sweep theorems, and the broadcast witness
into reusable modules. No source wrapper or audit is launched here.

## Geometry interpretation still needed for the full source row

The proved statement concerns physical Cartesian tensor boxes. It neither
defines logical rectangularity as a bare bijection nor derives physical
face normals, areas, cell volumes, or transformed fluxes from such a bijection.
An arbitrary coordinate equivalence is insufficient for those links. No user
geometry convention has been adopted.

Concrete alternatives for the coordinator's review, before any question or
fresh full-row audit:

1. Keep this result as a separately scoped Cartesian tensor-grid foundation.
   Leave the broader logical-grid source obligation open. This requires no new
   geometry interpretation and makes no claim to complete the original row.
2. Record logical rectangularity as tensor-product cell connectivity, carrying
   physical cell volumes, shared face geometry/orientation, and the associated
   physical normal-flux problems separately. A further generic finite-volume
   extension must use those supplied geometric data instead of coordinate
   widths alone. This can include curvilinear geometry without requiring one
   arbitrary global bijection to supply missing metric meaning.
3. Record a specified sufficiently regular invertible physical-coordinate map
   from a logical tensor grid, together with the exact Jacobian/face-metric
   transformation of the conservation law. Prove the transformed directional
   flux/update relation for that map. This is more restrictive and requires
   additional change-of-variables mathematics, not merely measurable pullbacks.

Any adopted alternative must be identified as an explicit interpretation and
audited with the source facts kept separate. The source also leaves the full
high-resolution method class and broader fractional schedules unstated here;
the concrete exact-interface ordered sweep is a useful foundation, not proof
of exhaustive algorithmic/source correspondence or universal practical efficacy.
