/-
SPDX-License-Identifier: MIT
-/
import ComputationalMathematics.Analysis.InnerProductSpace.LinearMap.Normalization
import Mathlib.Analysis.InnerProductSpace.Positive

/-!
# Positivity from unit-sphere expectations

Reality and nonnegativity on unit vectors imply positivity on the whole space.
-/
set_option autoImplicit false
open scoped ComplexConjugate
universe u
namespace NumStability.ContractionAffineConstruction
variable {H : Type u} [NormedAddCommGroup H] [InnerProductSpace ℂ H]

/-- Unit-sphere reality and nonnegativity extend to all vectors. The zero
vector is handled separately, so no nontriviality or dimension is assumed. -/
theorem quadratic_real_nonneg_of_unit_sphere
    (A : H →ₗ[ℂ] H)
    (h : ∀ v : H, ‖v‖ = 1 →
      ((inner ℂ v (A v)).re : ℂ) = inner ℂ v (A v) ∧
        0 ≤ (inner ℂ v (A v)).re) (x : H) :
    ((inner ℂ x (A x)).re : ℂ) = inner ℂ x (A x) ∧
      0 ≤ (inner ℂ x (A x)).re := by
  by_cases hx : x = 0
  · subst x
    simp
  · let v : H := (‖x‖ : ℂ)⁻¹ • x
    have hvnorm : ‖v‖ = 1 := complex_unit_normalization x hx
    obtain ⟨hvreal, hvnonneg⟩ := h v hvnorm
    have hscale : inner ℂ x (A x) =
        ((‖x‖ ^ 2 * (inner ℂ v (A v)).re : ℝ) : ℂ) := by
      calc
        inner ℂ x (A x) =
            (‖x‖ : ℂ) ^ 2 * inner ℂ v (A v) :=
          linear_quadratic_normalization A x hx
        _ = (‖x‖ : ℂ) ^ 2 * ((inner ℂ v (A v)).re : ℂ) := by
          rw [hvreal]
        _ = _ := by rw [Complex.ofReal_mul, Complex.ofReal_pow]
    constructor
    · rw [hscale]
      simp only [Complex.ofReal_re]
    · rw [hscale, Complex.ofReal_re]
      exact mul_nonneg (sq_nonneg ‖x‖) hvnonneg

/-- Real nonnegative expectations on every unit vector imply positivity.
The hypothesis uses `inner x (A x)`; Mathlib's positivity characterization
uses `inner (A x) x`, converted here by conjugate symmetry and reality. -/
theorem isPositive_of_unit_sphere
    (A : H →ₗ[ℂ] H)
    (h : ∀ v : H, ‖v‖ = 1 →
      ((inner ℂ v (A v)).re : ℂ) = inner ℂ v (A v) ∧
        0 ≤ (inner ℂ v (A v)).re) :
    LinearMap.IsPositive A := by
  apply (LinearMap.isPositive_iff_complex A).2
  intro x
  obtain ⟨hreal, hnonneg⟩ := quadratic_real_nonneg_of_unit_sphere A h x
  have hswap : inner ℂ (A x) x = inner ℂ x (A x) := by
    calc
      inner ℂ (A x) x = conj (inner ℂ x (A x)) :=
        (inner_conj_symm (𝕜 := ℂ) (A x) x).symm
      _ = inner ℂ x (A x) := by rw [← hreal, Complex.conj_ofReal]
  rw [hswap]
  exact ⟨hreal, hnonneg⟩

end NumStability.ContractionAffineConstruction
