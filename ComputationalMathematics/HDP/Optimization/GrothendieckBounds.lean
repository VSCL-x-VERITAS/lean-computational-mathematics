import ComputationalMathematics.HDP.Optimization.GrothendieckTruncation

/-!
# Elementary finite Grothendieck bounds

This module proves the multilinear extreme-point argument behind Exercise
3.5.2(a): it is enough to test a finite real bilinear form on sign vectors.
The norm on a finite function space is its maximum absolute coordinate.
-/

noncomputable section

open scoped BigOperators

namespace NumStability.HDP.Optimization

/-- The value of a finite real bilinear form. -/
def bilinearValue {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ)
    (x : Fin m → ℝ) (y : Fin n → ℝ) : ℝ :=
  ∑ i, ∑ j, A i j * x i * y j

/-- A real coordinate vector all of whose entries are signs. -/
def IsSignVector {n : ℕ} (x : Fin n → ℝ) : Prop :=
  ∀ i, x i = 1 ∨ x i = -1

private def extremalSign {n : ℕ} (c : Fin n → ℝ) (i : Fin n) : ℝ :=
  if 0 ≤ c i then 1 else -1

private theorem extremalSign_isSignVector {n : ℕ} (c : Fin n → ℝ) :
    IsSignVector (extremalSign c) := by
  intro i
  by_cases h : 0 ≤ c i
  · exact Or.inl (by simp [extremalSign, h])
  · exact Or.inr (by simp [extremalSign, h])

private theorem linearValue_le_extremalSign {n : ℕ}
    (c x : Fin n → ℝ) (hx : ∀ i, |x i| ≤ 1) :
    ∑ i, c i * x i ≤ ∑ i, c i * extremalSign c i := by
  apply Finset.sum_le_sum
  intro i hi
  by_cases hc : 0 ≤ c i
  · rw [extremalSign, if_pos hc]
    exact mul_le_mul_of_nonneg_left (abs_le.mp (hx i)).2 hc
  · rw [extremalSign, if_neg hc]
    exact mul_le_mul_of_nonpos_left (abs_le.mp (hx i)).1 (le_of_not_ge hc)

/-- A bilinear form bounded by one on pairs of sign vectors is bounded by one
on the whole product of coordinate cubes. -/
theorem bilinearValue_le_one_of_sign
    {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ)
    (hsign : ∀ x y, IsSignVector x → IsSignVector y → bilinearValue A x y ≤ 1)
    (x : Fin m → ℝ) (y : Fin n → ℝ)
    (hx : ∀ i, |x i| ≤ 1) (hy : ∀ j, |y j| ≤ 1) :
    bilinearValue A x y ≤ 1 := by
  let sx : Fin m → ℝ := extremalSign (fun i => ∑ j, A i j * y j)
  let sy : Fin n → ℝ := extremalSign (fun j => ∑ i, A i j * sx i)
  have hfirst : bilinearValue A x y ≤ bilinearValue A sx y := by
    calc
      bilinearValue A x y =
          ∑ i, (∑ j, A i j * y j) * x i := by
            unfold bilinearValue
            apply Finset.sum_congr rfl
            intro i hi
            rw [Finset.sum_mul]
            apply Finset.sum_congr rfl
            intro j hj
            ring
      _ ≤ ∑ i, (∑ j, A i j * y j) * sx i :=
        linearValue_le_extremalSign _ _ hx
      _ = bilinearValue A sx y := by
        unfold bilinearValue
        apply Finset.sum_congr rfl
        intro i hi
        rw [Finset.sum_mul]
        apply Finset.sum_congr rfl
        intro j hj
        ring
  have hsecond : bilinearValue A sx y ≤ bilinearValue A sx sy := by
    calc
      bilinearValue A sx y =
          ∑ j, (∑ i, A i j * sx i) * y j := by
            unfold bilinearValue
            rw [Finset.sum_comm]
            apply Finset.sum_congr rfl
            intro j hj
            rw [Finset.sum_mul]
      _ ≤ ∑ j, (∑ i, A i j * sx i) * sy j :=
        linearValue_le_extremalSign _ _ hy
      _ = bilinearValue A sx sy := by
        unfold bilinearValue
        rw [Finset.sum_comm]
        apply Finset.sum_congr rfl
        intro j hj
        rw [Finset.sum_mul]
  exact hfirst.trans (hsecond.trans
    (hsign sx sy (extremalSign_isSignVector _) (extremalSign_isSignVector _)))

private theorem bilinearValue_smul_left {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (c : ℝ)
    (x : Fin m → ℝ) (y : Fin n → ℝ) :
    bilinearValue A (c • x) y = c * bilinearValue A x y := by
  unfold bilinearValue
  simp only [Pi.smul_apply, smul_eq_mul]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i hi
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j hj
  ring

private theorem bilinearValue_smul_right {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) (c : ℝ)
    (x : Fin m → ℝ) (y : Fin n → ℝ) :
    bilinearValue A x (c • y) = c * bilinearValue A x y := by
  unfold bilinearValue
  simp only [Pi.smul_apply, smul_eq_mul]
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro i hi
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j hj
  ring

/-- The sign-vector hypothesis implies the max-coordinate-norm bound for all
real coordinate vectors. -/
theorem bilinearValue_le_norm_mul_norm_of_sign
    {m n : ℕ} (A : Matrix (Fin m) (Fin n) ℝ)
    (hsign : ∀ x y, IsSignVector x → IsSignVector y → bilinearValue A x y ≤ 1)
    (x : Fin m → ℝ) (y : Fin n → ℝ) :
    bilinearValue A x y ≤ ‖x‖ * ‖y‖ := by
  by_cases hx0 : ‖x‖ = 0
  · have hx : x = 0 := norm_eq_zero.mp hx0
    subst x
    simp [bilinearValue]
  by_cases hy0 : ‖y‖ = 0
  · have hy : y = 0 := norm_eq_zero.mp hy0
    subst y
    simp [bilinearValue]
  have hxpos : 0 < ‖x‖ := lt_of_le_of_ne (norm_nonneg x) (Ne.symm hx0)
  have hypos : 0 < ‖y‖ := lt_of_le_of_ne (norm_nonneg y) (Ne.symm hy0)
  let xn : Fin m → ℝ := ‖x‖⁻¹ • x
  let yn : Fin n → ℝ := ‖y‖⁻¹ • y
  have hxn : ∀ i, |xn i| ≤ 1 := by
    intro i
    dsimp [xn]
    rw [abs_mul, abs_inv, abs_norm]
    rw [inv_mul_le_one₀ hxpos]
    simpa only [Real.norm_eq_abs] using norm_le_pi_norm x i
  have hyn : ∀ j, |yn j| ≤ 1 := by
    intro j
    dsimp [yn]
    rw [abs_mul, abs_inv, abs_norm]
    rw [inv_mul_le_one₀ hypos]
    simpa only [Real.norm_eq_abs] using norm_le_pi_norm y j
  have hunit := bilinearValue_le_one_of_sign A hsign xn yn hxn hyn
  have hscale : bilinearValue A xn yn =
      (‖x‖ * ‖y‖)⁻¹ * bilinearValue A x y := by
    rw [show xn = ‖x‖⁻¹ • x by rfl, show yn = ‖y‖⁻¹ • y by rfl,
      bilinearValue_smul_left, bilinearValue_smul_right]
    field_simp
  rw [hscale] at hunit
  have hprodpos : 0 < ‖x‖ * ‖y‖ := mul_pos hxpos hypos
  rwa [inv_mul_le_one₀ hprodpos] at hunit

/-- Exercise 3.5.2(a): bounding a finite bilinear form on all pairs of sign
vectors is equivalent to bounding it by the product of the two maximum
absolute coordinate norms. -/
theorem signBound_iff_normBound {m n : ℕ}
    (A : Matrix (Fin m) (Fin n) ℝ) :
    (∀ x y, IsSignVector x → IsSignVector y → bilinearValue A x y ≤ 1) ↔
      ∀ x y, bilinearValue A x y ≤ ‖x‖ * ‖y‖ := by
  constructor
  · intro h x y
    exact bilinearValue_le_norm_mul_norm_of_sign A h x y
  · intro h x y hx hy
    calc
      bilinearValue A x y ≤ ‖x‖ * ‖y‖ := h x y
      _ ≤ 1 := by
        have hxnorm : ‖x‖ ≤ 1 :=
          (pi_norm_le_iff_of_nonneg zero_le_one).2 fun i => by
            rcases hx i with hxi | hxi <;> simp [hxi]
        have hynorm : ‖y‖ ≤ 1 :=
          (pi_norm_le_iff_of_nonneg zero_le_one).2 fun j => by
            rcases hy j with hyj | hyj <;> simp [hyj]
        nlinarith [norm_nonneg x, norm_nonneg y]

end NumStability.HDP.Optimization
