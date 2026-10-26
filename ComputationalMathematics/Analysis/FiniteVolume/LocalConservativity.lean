/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Algebra.Group.Defs

/-!
# Local conservation of outward numerical fluxes

An interface has two incident cells, given by `left` and `right`. The flux is
measured outward from each incident cell. This predicate specifies cancellation
at that interface; it does not assert that a chosen numerical flux satisfies it,
or that abstract incidence data realize a geometric mesh.
-/

namespace NumStability.FiniteVolume

/-- The outward fluxes on the two sides of every interface have opposite signs.
`Time` may index discrete time levels or a single stationary state. -/
def IsLocallyConservative
    {Cell Face Time Value : Type*} [Neg Value]
    (left right : Face → Cell) (flux : Time → Cell → Face → Value) : Prop :=
  ∀ time face, flux time (left face) face = -flux time (right face) face

end NumStability.FiniteVolume
