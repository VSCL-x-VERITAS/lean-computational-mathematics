import ComputationalMathematics.Source.NocedalWright.Chapter02.Exercise213NotLinearTargetV1
import Mathlib.Data.Real.Archimedean
import Mathlib.Algebra.Order.Field.Basic

/-!
Exercise 2.13 of Nocedal and Wright, *Numerical Optimization*, second
edition: the reciprocal sequence does not converge Q-linearly.
-/

namespace ComputationalMathematics.Source.NocedalWright.Chapter02

/-- Every proposed Q-linear contraction factor fails on a positive tail of `1/k`. -/
theorem exercise213NotLinearV1 : exercise213NotLinearTargetV1 := by
  intro r hr0 hr1 K hK
  have hdelta : 0 < (1 : ℝ) - r := sub_pos.mpr hr1
  obtain ⟨k, hk⟩ := exists_nat_gt (max (K : ℝ) (1 / ((1 : ℝ) - r)))
  have hKk : (K : ℝ) < (k : ℝ) := (le_max_left _ _).trans_lt hk
  have hKn : K ≤ k := by exact_mod_cast hKk.le
  have hbound : 1 / ((1 : ℝ) - r) < (k : ℝ) :=
    (le_max_right _ _).trans_lt hk
  have hKpos : (0 : ℝ) < (K : ℝ) := by exact_mod_cast hK
  have hkpos : (0 : ℝ) < (k : ℝ) := hKpos.trans hKk
  have hkplus : (0 : ℝ) < (k : ℝ) + 1 := by positivity
  have hmul := mul_lt_mul_of_pos_right hbound hdelta
  have hden : (1 : ℝ) - r ≠ 0 := ne_of_gt hdelta
  have hone : (1 / ((1 : ℝ) - r)) * ((1 : ℝ) - r) = 1 := by
    field_simp
  rw [hone] at hmul
  have hnum : r * ((k : ℝ) + 1) < (k : ℝ) := by nlinarith
  have hratio : r < (k : ℝ) / ((k : ℝ) + 1) :=
    (lt_div_iff₀ hkplus).2 hnum
  refine ⟨k, hKn, ?_⟩
  have hkone : (0 : ℝ) < 1 / (k : ℝ) := one_div_pos.mpr hkpos
  have hkplusone : (0 : ℝ) < 1 / ((k + 1 : ℕ) : ℝ) := by
    apply one_div_pos.mpr
    exact_mod_cast Nat.succ_pos k
  rw [abs_of_pos hkplusone, abs_of_pos hkone]
  have hkne : (k : ℝ) ≠ 0 := ne_of_gt hkpos
  have hkplusne : ((k + 1 : ℕ) : ℝ) ≠ 0 := ne_of_gt (by exact_mod_cast Nat.succ_pos k)
  have heq :
      (1 / ((k + 1 : ℕ) : ℝ)) / (1 / (k : ℝ)) =
        (k : ℝ) / ((k : ℝ) + 1) := by
    push_cast
    field_simp
  rw [heq]
  exact hratio

end ComputationalMathematics.Source.NocedalWright.Chapter02
