/-
SPDX-License-Identifier: MIT
-/
import Mathlib.Analysis.InnerProductSpace.Basic
import Mathlib.Analysis.Normed.Module.RCLike.Basic
import Mathlib.Tactic.Ring

/-!
# Normalization of complex quadratic forms

Unit normalization, reconstruction and homogeneity for complex-linear maps.
-/
set_option autoImplicit false
open scoped ComplexConjugate
universe u
namespace NumStability.ContractionAffineConstruction
variable {H : Type u} [NormedAddCommGroup H] [InnerProductSpace ℂ H]

theorem complex_unit_normalization (x : H) (hx : x ≠ 0) :
    ‖(‖x‖ : ℂ)⁻¹ • x‖ = 1 := by
  simpa only [Complex.ofReal_inv] using (norm_smul_inv_norm (𝕜 := ℂ) hx)

theorem complex_normalization_reconstruct (x : H) (hx : x ≠ 0) :
    (‖x‖ : ℂ) • ((‖x‖ : ℂ)⁻¹ • x) = x := by
  have hn : (‖x‖ : ℂ) ≠ 0 := by
    exact_mod_cast (norm_ne_zero_iff.mpr hx)
  rw [smul_smul, mul_inv_cancel₀ hn, one_smul]

theorem linear_quadratic_real_smul (A : H →ₗ[ℂ] H) (r : ℝ) (v : H) :
    inner ℂ ((r : ℂ) • v) (A ((r : ℂ) • v)) =
      (r : ℂ) ^ 2 * inner ℂ v (A v) := by
  simp only [map_smul, inner_smul_left, inner_smul_right, Complex.conj_ofReal]
  ring

theorem linear_quadratic_normalization (A : H →ₗ[ℂ] H) (x : H) (hx : x ≠ 0) :
    inner ℂ x (A x) = (‖x‖ : ℂ) ^ 2 *
      inner ℂ ((‖x‖ : ℂ)⁻¹ • x) (A ((‖x‖ : ℂ)⁻¹ • x)) := by
  calc
    inner ℂ x (A x) =
        inner ℂ ((‖x‖ : ℂ) • ((‖x‖ : ℂ)⁻¹ • x))
          (A ((‖x‖ : ℂ) • ((‖x‖ : ℂ)⁻¹ • x))) := by
      rw [complex_normalization_reconstruct x hx]
    _ = _ := linear_quadratic_real_smul A ‖x‖ _

end NumStability.ContractionAffineConstruction
