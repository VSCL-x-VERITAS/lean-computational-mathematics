/-
SPDX-License-Identifier: MIT
-/

import ComputationalMathematics.Source.LeVeque.Chapter04.LaxFriedrichsConjugateSmoothGlobal

/-!
# Mean error transfer across a fixed state basis

Finite basis reconstruction transfers mean absolute errors in all
characteristic coordinates to each physical state component. The basis
factor is independent of the periodic grid size.
-/

namespace NumStability

/-- A finite basis reconstructs each physical-component error from its
characteristic-coordinate errors. -/
theorem leveque04_basis_physicalComponent_abs_le
    {m : ℕ} (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (u v : Fin m → ℝ) (k : Fin m) :
    |u k - v k| ≤ ∑ p : Fin m, |basis p k| *
      |basis.equivFun u p - basis.equivFun v p| := by
  let d := u - v
  have hrepr : d k = ∑ p : Fin m,
      basis.equivFun d p * basis p k := by
    conv_lhs => rw [← basis.sum_equivFun d]
    simp only [Finset.sum_apply, Pi.smul_apply, smul_eq_mul]
  calc
    |u k - v k| = |d k| := rfl
    _ = |∑ p : Fin m, basis.equivFun d p * basis p k| := by rw [hrepr]
    _ ≤ ∑ p : Fin m, |basis.equivFun d p * basis p k| :=
      Finset.abs_sum_le_sum_abs _ _
    _ = ∑ p : Fin m, |basis p k| *
        |basis.equivFun u p - basis.equivFun v p| := by
      simp only [d, map_sub, Pi.sub_apply, abs_mul]
      apply Finset.sum_congr rfl
      intro p _
      ring

/-- The physical mean absolute error is bounded by the basis-weighted
sum of characteristic mean absolute errors on the same periodic grid. -/
theorem leveque04_basis_physicalComponent_meanL1_le
    {m : ℕ} (n : ℕ) [NeZero n]
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (u v : ZMod n → Fin m → ℝ) (k : Fin m) :
    (∑ i : ZMod n, |u i k - v i k|) /
        (Fintype.card (ZMod n) : ℝ) ≤
      ∑ p : Fin m, |basis p k| *
        ((∑ i : ZMod n,
            |basis.equivFun (u i) p - basis.equivFun (v i) p|) /
          (Fintype.card (ZMod n) : ℝ)) := by
  have hpoint (i : ZMod n) :=
    leveque04_basis_physicalComponent_abs_le basis (u i) (v i) k
  have hcard : (0 : ℝ) < (Fintype.card (ZMod n) : ℝ) := by
    exact_mod_cast Fintype.card_pos_iff.mpr inferInstance
  calc
    (∑ i : ZMod n, |u i k - v i k|) /
        (Fintype.card (ZMod n) : ℝ) ≤
      (∑ i : ZMod n,
        ∑ p : Fin m, |basis p k| *
          |basis.equivFun (u i) p - basis.equivFun (v i) p|) /
        (Fintype.card (ZMod n) : ℝ) := by
          apply div_le_div_of_nonneg_right _ (le_of_lt hcard)
          exact Finset.sum_le_sum (fun i _ => hpoint i)
    _ = ∑ p : Fin m, |basis p k| *
        ((∑ i : ZMod n,
            |basis.equivFun (u i) p - basis.equivFun (v i) p|) /
          (Fintype.card (ZMod n) : ℝ)) := by
      rw [Finset.sum_comm, Finset.sum_div]
      apply Finset.sum_congr rfl
      intro p _
      rw [← Finset.mul_sum]
      ring

/-- A common characteristic mean-error increment transfers to each
physical component with a mesh-independent finite basis factor. -/
theorem leveque04_basis_physicalComponent_meanL1_increment
    {m : ℕ} (n : ℕ) [NeZero n]
    (basis : Module.Basis (Fin m) ℝ (Fin m → ℝ))
    (initial final : ZMod n → Fin m → ℝ)
    (increment : ℝ) (k : Fin m)
    (hcharacteristic : ∀ p : Fin m,
      (∑ i : ZMod n,
          |basis.equivFun (final i) p - basis.equivFun (initial i) p|) /
        (Fintype.card (ZMod n) : ℝ) ≤ increment) :
    (∑ i : ZMod n, |final i k - initial i k|) /
        (Fintype.card (ZMod n) : ℝ) ≤
      (∑ p : Fin m, |basis p k|) * increment := by
  calc
    (∑ i : ZMod n, |final i k - initial i k|) /
        (Fintype.card (ZMod n) : ℝ) ≤
      ∑ p : Fin m, |basis p k| *
        ((∑ i : ZMod n,
            |basis.equivFun (final i) p - basis.equivFun (initial i) p|) /
          (Fintype.card (ZMod n) : ℝ)) :=
        leveque04_basis_physicalComponent_meanL1_le n basis final initial k
    _ ≤ ∑ p : Fin m, |basis p k| * increment := by
      apply Finset.sum_le_sum
      intro p _
      exact mul_le_mul_of_nonneg_left (hcharacteristic p) (abs_nonneg _)
    _ = (∑ p : Fin m, |basis p k|) * increment := by
      rw [Finset.sum_mul]

end NumStability
