/-
SPDX-License-Identifier: MIT
-/

import Mathlib.Analysis.InnerProductSpace.l2Space
import Mathlib.Tactic.Linarith
import Mathlib.Tactic.Ring

/-!
# Bounded real multipliers on square-summable sequences

A uniformly bounded real coefficient sequence defines a bounded linear
multiplier. Nonnegative coefficients give a positive quadratic form.
-/

open scoped InnerProductSpace

namespace NumStability
noncomputable section

private theorem l2_summable_sq {ι : Type*} (u : lp (fun _ : ι => ℝ) 2) :
    Summable (fun i => ‖u i‖ ^ (2 : ℕ)) := by
  simpa using (lp.memℓp u).summable (by norm_num : 0 < (2 : ENNReal).toReal)

private theorem l2_norm_sq {ι : Type*} (u : lp (fun _ : ι => ℝ) 2) :
    ‖u‖ ^ 2 = ∑' i, ‖u i‖ ^ (2 : ℕ) := by
  simpa using lp.norm_rpow_eq_tsum (by norm_num : 0 < (2 : ENNReal).toReal) u

private theorem l2_multiplier_mem {ι : Type*} (b : ι → ℝ) (C : ℝ)
    (hb : ∀ i, |b i| ≤ C) (u : lp (fun _ : ι => ℝ) 2) :
    Memℓp (fun i => b i * u i) 2 := by
  have hsum : Summable (fun i => ‖b i * u i‖ ^ (2 : ℕ)) := by
    apply Summable.of_nonneg_of_le (fun i => sq_nonneg _) ?_ ((l2_summable_sq u).mul_left (C ^ 2))
    intro i
    rw [norm_mul, mul_pow]
    exact mul_le_mul_of_nonneg_right
      (pow_le_pow_left₀ (norm_nonneg _) (by simpa only [Real.norm_eq_abs] using hb i) 2)
      (sq_nonneg _)
  apply memℓp_gen
  simpa using hsum

/-- Multiplication by a uniformly bounded real sequence on `ℓ²`. -/
def l2BoundedRealMultiplier {ι : Type*} (b : ι → ℝ) (C : ℝ)
    (hC : 0 ≤ C) (hb : ∀ i, |b i| ≤ C) :
    lp (fun _ : ι => ℝ) 2 →L[ℝ] lp (fun _ : ι => ℝ) 2 := by
  let T : lp (fun _ : ι => ℝ) 2 →ₗ[ℝ] lp (fun _ : ι => ℝ) 2 :=
    { toFun := fun u => ⟨fun i => b i * u i, l2_multiplier_mem b C hb u⟩
      map_add' := by
        intro u v
        ext i
        change b i * (u i + v i) = b i * u i + b i * v i
        ring
      map_smul' := by intro c u; ext i; change b i * (c * u i) = c * (b i * u i); ring }
  apply T.mkContinuous C
  intro u
  have hsq : ‖T u‖ ^ 2 ≤ C ^ 2 * ‖u‖ ^ 2 := by
    rw [l2_norm_sq, l2_norm_sq, ← tsum_mul_left]
    apply Summable.tsum_le_tsum ?_ (l2_summable_sq (T u)) ((l2_summable_sq u).mul_left _)
    intro i
    change ‖b i * u i‖ ^ 2 ≤ _
    rw [norm_mul, mul_pow]
    exact mul_le_mul_of_nonneg_right
      (pow_le_pow_left₀ (norm_nonneg _) (by simpa only [Real.norm_eq_abs] using hb i) 2)
      (sq_nonneg _)
  apply (sq_le_sq₀ (norm_nonneg (T u)) (mul_nonneg hC (norm_nonneg u))).mp
  simpa only [mul_pow] using hsq

@[simp] theorem l2BoundedRealMultiplier_apply {ι : Type*} (b : ι → ℝ) (C : ℝ)
    (hC : 0 ≤ C) (hb : ∀ i, |b i| ≤ C) (u : lp (fun _ : ι => ℝ) 2) (i : ι) :
    l2BoundedRealMultiplier b C hC hb u i = b i * u i := rfl

/-- Pointwise nonnegative coefficients give a nonnegative actual `ℓ²` inner product. -/
theorem l2BoundedRealMultiplier_inner_nonneg {ι : Type*} (b : ι → ℝ) (C : ℝ)
    (hC : 0 ≤ C) (hb : ∀ i, |b i| ≤ C) (hpos : ∀ i, 0 ≤ b i)
    (u : lp (fun _ : ι => ℝ) 2) :
    0 ≤ ⟪l2BoundedRealMultiplier b C hC hb u, u⟫_ℝ := by
  rw [lp.inner_eq_tsum]
  apply tsum_nonneg
  intro i
  rw [l2BoundedRealMultiplier_apply]
  change 0 ≤ ⟪b i • u i, u i⟫_ℝ
  rw [real_inner_smul_left, real_inner_self_eq_norm_sq]
  exact mul_nonneg (hpos i) (sq_nonneg _)

end
end NumStability
