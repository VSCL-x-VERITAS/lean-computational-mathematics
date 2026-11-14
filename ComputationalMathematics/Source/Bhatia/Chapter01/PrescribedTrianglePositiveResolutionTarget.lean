/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Positive
import Mathlib.Analysis.Convex.Hull
import Mathlib.Analysis.Normed.Module.FiniteDimension

/-!
# Positive resolutions for a prescribed triangle

Proof-free source target for Bhatia, Matrix Analysis (1997), Problem I.6.17(i),
printed page 25 / PDF page 37. The fixed unit-circle coefficients and the full
unit-sphere numerical range retain the source domains, including degenerate
vertex triples and zero-dimensional spaces.
-/

set_option autoImplicit false
open scoped BigOperators
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Numerical-range containment in the prescribed unit-circle triangle is
    equivalent to a positive resolution with those fixed coefficients. -/
def prescribedTrianglePositiveResolution : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (z : Fin 3 → ℂ),
    (∀ j : Fin 3, ‖z j‖ = 1) →
    ∀ A : H →ₗ[ℂ] H,
      let W : Set ℂ :=
        {w : ℂ | ∃ x : H, ‖x‖ = 1 ∧ w = inner ℂ x (A x)}
      (W ⊆ convexHull ℝ (Set.range z)) ↔
        ∃ P : Fin 3 → (H →ₗ[ℂ] H),
          (∀ j : Fin 3, (P j).IsPositive) ∧
          (∑ j : Fin 3, P j) = (LinearMap.id : H →ₗ[ℂ] H) ∧
          A = ∑ j : Fin 3, z j • P j

end NumStability.Bhatia.Chapter01.Targets
