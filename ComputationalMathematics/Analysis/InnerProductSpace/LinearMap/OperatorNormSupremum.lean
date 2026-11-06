/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.LinearMap
import Mathlib.Data.Real.Archimedean

/-!
# Operator norm as a supremum of inner-product moduli

The norm of a continuous linear map between real or complex inner-product spaces
is the real supremum of its inner-product moduli on independently varying unit
vectors. Neither space needs to be nontrivial. When either unit sphere is empty,
the real supremum uses its value zero; no real least-upper-bound assertion for
the empty set is made.
-/

set_option autoImplicit false

namespace NumStability

variable {𝕜 E F : Type*} [RCLike 𝕜]
variable [NormedAddCommGroup E] [InnerProductSpace 𝕜 E]
variable [NormedAddCommGroup F] [InnerProductSpace 𝕜 F]

/-- The operator norm equals the real supremum of the inner-product moduli
over both unit spheres, including empty domain or codomain spheres. -/
theorem opNorm_eq_sSup_inner_sphere (T : E →L[𝕜] F) :
    ‖T‖ = sSup {r : ℝ | ∃ x : E, ∃ y : F,
      ‖x‖ = 1 ∧ ‖y‖ = 1 ∧ r = ‖inner 𝕜 y (T x)‖} := by
  let S : Set ℝ := {r | ∃ x : E, ∃ y : F,
    ‖x‖ = 1 ∧ ‖y‖ = 1 ∧ r = ‖inner 𝕜 y (T x)‖}
  change ‖T‖ = sSup S
  have hupper : ∀ r ∈ S, r ≤ ‖T‖ := by
    rintro _ ⟨x, y, hx, hy, rfl⟩
    calc
      ‖inner 𝕜 y (T x)‖ ≤ ‖y‖ * ‖T x‖ := norm_inner_le_norm y (T x)
      _ = ‖T x‖ := by rw [hy, one_mul]
      _ ≤ ‖T‖ * ‖x‖ := T.le_opNorm x
      _ = ‖T‖ := by rw [hx, mul_one]
  have hbounded : BddAbove S := ⟨‖T‖, hupper⟩
  have hnonneg : ∀ r ∈ S, 0 ≤ r := by
    rintro _ ⟨x, y, _, _, rfl⟩
    exact norm_nonneg _
  apply le_antisymm
  · apply ContinuousLinearMap.opNorm_le_of_re_inner_le (Real.sSup_nonneg hnonneg)
    intro x y hx hy
    calc
      RCLike.re (inner 𝕜 (T x) y) ≤ ‖inner 𝕜 (T x) y‖ := RCLike.re_le_norm _
      _ = ‖inner 𝕜 y (T x)‖ := norm_inner_symm (T x) y
      _ ≤ sSup S := le_csSup hbounded ⟨x, y, hx, hy, rfl⟩
  · exact Real.sSup_le hupper (norm_nonneg T)

end NumStability
