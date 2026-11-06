/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.Normed.Operator.Basic
import Mathlib.Tactic.Linarith

/-!
# A quadratic criterion for contractions

A bounded operator is a contraction exactly when the identity-diagonal block
quadratic expression with its actual cross term is nonnegative on every pair
of vectors. The converse tests the first vector at the negative image of the
second, avoiding unit vectors and division. Neither space needs to be complete,
finite-dimensional or nonzero.
-/

set_option autoImplicit false

namespace NumStability

variable {𝕜 E F : Type*} [RCLike 𝕜]
  [NormedAddCommGroup E] [InnerProductSpace 𝕜 E]
  [NormedAddCommGroup F] [InnerProductSpace 𝕜 F]

/-- A contraction is characterized by the nonnegative identity-diagonal block
form, with the fixed cross term `2 * re ⟪x, A y⟫`. The zero spaces are included. -/
theorem opNorm_le_one_iff_block_form_nonneg (A : E →L[𝕜] F) :
    ‖A‖ ≤ 1 ↔ ∀ (x : F) (y : E),
      0 ≤ ‖x‖ ^ 2 + ‖y‖ ^ 2 + 2 * RCLike.re (inner 𝕜 x (A y)) := by
  constructor
  · intro hA x y
    have hAy : ‖A y‖ ≤ ‖y‖ := by
      simpa only [one_mul] using
        (A.le_opNorm y).trans
          (mul_le_mul_of_nonneg_right hA (norm_nonneg y))
    have hi : -RCLike.re (inner 𝕜 x (A y)) ≤ ‖x‖ * ‖A y‖ := by
      simpa only [inner_neg_left, map_neg, norm_neg] using
        (re_inner_le_norm (-x) (A y))
    have hc : -RCLike.re (inner 𝕜 x (A y)) ≤ ‖x‖ * ‖y‖ :=
      hi.trans (mul_le_mul_of_nonneg_left hAy (norm_nonneg x))
    nlinarith [sq_nonneg (‖x‖ - ‖y‖)]
  · intro h
    apply A.opNorm_le_bound zero_le_one
    intro y
    have ht := h (-(A y)) y
    simp only [norm_neg, inner_neg_left, map_neg, ← norm_sq_eq_re_inner] at ht
    have hs : ‖A y‖ ^ 2 ≤ ‖y‖ ^ 2 := by nlinarith
    simpa only [one_mul] using
      (sq_le_sq₀ (norm_nonneg (A y)) (norm_nonneg y)).mp hs

end NumStability
