/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.Convex.Hull
import Mathlib.Analysis.Normed.Module.FiniteDimension

/-!
# Mirman's bound with the real order interface

Bhatia, Matrix Analysis (1997), Problem I.6.17(iii), printed page 25 /
PDF page 37. The radius explicitly uses the maximum operation belonging
to Mathlib's lawful linear order on the reals.
-/

set_option autoImplicit false
universe u

namespace NumStability.Bhatia.Chapter01.Targets

/-- Numerical range containment in an arbitrary prescribed triangle bounds
the norm by the largest vertex modulus, using the real linear-order maximum. -/
def mirmanTriangleNormBoundOrderedMaximum : Prop :=
  ∀ (H : Type u) [NormedAddCommGroup H] [InnerProductSpace ℂ H]
      [FiniteDimensional ℂ H] (z : Fin 3 → ℂ) (A : H →ₗ[ℂ] H),
    let W : Set ℂ :=
      {w : ℂ | ∃ x : H, ‖x‖ = 1 ∧ w = inner ℂ x (A x)}
    let realMax : ℝ → ℝ → ℝ :=
      @Max.max ℝ (@LinearOrder.toMax ℝ Real.linearOrder)
    let R : ℝ := realMax ‖z 0‖ (realMax ‖z 1‖ ‖z 2‖)
    (W ⊆ convexHull ℝ (Set.range z)) →
      ∀ x : H, ‖A x‖ ≤ R * ‖x‖

end NumStability.Bhatia.Chapter01.Targets
