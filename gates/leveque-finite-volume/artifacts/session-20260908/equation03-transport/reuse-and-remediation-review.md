# Equation (1.3) transport successor draft

The complete GLOBAL audit remains frozen and nonaccepted, with decision
SHA-256 b23abeb6383d5b4aee51da3ab92bcf113798a63ebed6f17390027cd67681b530.
It found that unconditional profile translation plus a conditional classical PDE
statement did not settle the printed “any function” solution wording. This draft
does not remove that finding or assert that it will be accepted.

The current-tree search is preserved in equation03-transport-reuse-search.txt.
Selected reusable producers are travelingWave_zero,
travelingWave_at_translated_point, travelingWave_isLinearAdvectionSolution,
and travelingWave_isRectangleConservationLawSolution. Mathlib's
hasDerivAt_const supplies the derivative of the constant characteristic
restriction. Existing pointwise and global classical wrappers omit the new
rectangle conclusion. No current producer was found in this scoped search for
the two exact regularity characterizations; this is not a global absence claim.

The new source wrapper retains the arbitrary-profile initial trace and unchanged
shape, adds a checked derivative along each characteristic, and adds rectangle
conservation for every interval-integrable profile. This strictly extends the
earlier mathematical coverage to discontinuous profiles. It does not assert
classical partial derivatives for such profiles or redefine the printed partial
derivatives as a derivative along characteristics. The reusable characterizations
make both regularity domains exact and include speed zero.

The new independent source selection must include equation (1.3), printed page 1,
and Section 1.1.2, printed pages 4–5, in the same hash-pinned chapter. The latter
explicitly distinguishes sufficiently smooth classical solutions from
discontinuous solutions governed by an integral conservation law. Whether this
context establishes equivalence to the selected source claim remains for fresh
independent roles and any triggered adjudication.

Organization: three proposed leaves separate characteristic transport, the
rectangle regularity characterization, and source correspondence. They preserve
all public owners and existing audit inputs. Actual canonical placement and import
validation wait for the preceding 34-module organization checkpoint.
