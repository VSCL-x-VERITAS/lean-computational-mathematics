# Finite-volume error foundations: organization review

The root reviewed all five new production leaves against the frozen finite-volume
drafts and their actual successful native checks. This placement adds reusable
mathematics without selecting an interpretation of the source's qualitative
accuracy discussion and without adding a source wrapper.

- CellAverageEstimates contains the norm estimate for normalized interval
  averages in a complete real normed space.
- PhysicalFluxAverage defines the physical time-average at the actual grid
  face and derives exact cell mass balance from rectangle conservation.
- FluxUpdateError compares an independently supplied numerical array with
  exact cell averages and proves local and contiguous-block error identities.
- FluxUpdateErrorBounds derives conditional next-cell and total block-mass
  error bounds. The block norm allows cancellation; it is not a sum of norms.
- LinearRiemannFluxAverage links the actual selected existing linear Riemann
  method to the physical flux of its returned solution, then transfers
  separately justified trace-error bounds to numerical error bounds.

The placement reuses existing grid, cell-average, conservative-update,
rectangle-solution, and selected-linear-solver APIs. Draft-only aliases are
inlined into their established producers; the weighted-balance norm argument
and a one-use update algebra adapter remain private. Existing declarations
and modules remain available. No convergence order, CFL condition, global
solver-trace agreement, or universal exact-solver existence is inferred.

All five leaves belong to the existing reusable Analysis hierarchy. The
established Analysis aggregate imports them in case-insensitive sorted order,
and its existing NumStability compatibility forwarder exposes the same public
entry point. No new source-numbered reusable name or compatibility shim is
needed. Current-tree scans, both-root build, actual declaration resolution,
tier census, and compiled dependency graphs must independently verify this
placement before the organization increment is marked complete.

