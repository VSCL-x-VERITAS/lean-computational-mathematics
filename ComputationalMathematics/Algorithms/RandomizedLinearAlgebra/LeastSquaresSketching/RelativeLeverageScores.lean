import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.LeastSquaresSketching.ResidualCross
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.IndependentTrace

/-!
# Supplied relative leverage scores

Normalization and lower probability bounds for supplied relative estimates of
squared row norms. This API does not compute those estimates or assert score
computation cost, running time or randomized sketch quality.
-/

namespace NumStability
open scoped BigOperators

/-- Supplied relative row-leverage estimates; this condition does not compute
those estimates or assert the cost of obtaining them. -/
def RelativeLeverageScores {m d : ℕ} (U : Fin m → Fin d → ℝ)
    (a : Fin m → ℝ) (α : ℝ) : Prop :=
  ∀ i, (1 - α) * rowNormSq U i ≤ a i ∧ a i ≤ (1 + α) * rowNormSq U i

/-- Relative scores have positive total mass on a positive-dimensional basis. -/
theorem relativeLeverageScores_sum_pos {m d : ℕ}
    (U : Fin m → Fin d → ℝ) (hU : HasOrthonormalColumns U) (hd : 0 < d)
    (a : Fin m → ℝ) {α : ℝ} (hα : α < 1) (ha : RelativeLeverageScores U a α) :
    0 < ∑ i : Fin m, a i := by
  have hdR : 0 < (d : ℝ) := by exact_mod_cast hd
  have hsum : (1 - α) * (d : ℝ) ≤ ∑ i : Fin m, a i := by
    have h := Finset.sum_le_sum (fun i (_ : i ∈ (Finset.univ : Finset (Fin m))) => (ha i).1)
    rw [← Finset.mul_sum] at h
    change (1 - α) * rowSqNormProbDen U ≤ _ at h
    rwa [rowSqNormProbDen_eq_nat_of_orthonormal_columns U hU] at h
  exact (mul_pos (by linarith) hdR).trans_le hsum

/-- Normalized supplied-score row law. -/
noncomputable def relativeLeverageScoreProbability {m d : ℕ}
    (U : Fin m → Fin d → ℝ) (hU : HasOrthonormalColumns U) (hd : 0 < d)
    (a : Fin m → ℝ) {α : ℝ} (hα : α < 1) (ha : RelativeLeverageScores U a α) :
    FiniteProbability (Fin m) where
  prob i := a i / ∑ j : Fin m, a j
  prob_nonneg i := div_nonneg
    ((mul_nonneg (by linarith) (rowNormSq_nonneg U i)).trans (ha i).1)
    (relativeLeverageScores_sum_pos U hU hd a hα ha).le
  prob_sum := by
    have hden := relativeLeverageScores_sum_pos U hU hd a hα ha
    simp_rw [div_eq_mul_inv]
    rw [← Finset.sum_mul]
    exact mul_inv_cancel₀ hden.ne'

/-- Normalization preserves a quantitative fraction of the exact leverage law. -/
theorem relativeLeverageScoreProbability_ge_fraction {m d : ℕ}
    (U : Fin m → Fin d → ℝ) (hU : HasOrthonormalColumns U) (hd : 0 < d)
    (a : Fin m → ℝ) {α : ℝ} (hα0 : 0 ≤ α) (hα : α < 1)
    (ha : RelativeLeverageScores U a α) (i : Fin m) :
    ((1 - α) / (1 + α)) * (rowNormSq U i / (d : ℝ)) ≤
      (relativeLeverageScoreProbability U hU hd a hα ha).prob i := by
  have hden := relativeLeverageScores_sum_pos U hU hd a hα ha
  have hdR : 0 < (d : ℝ) := by exact_mod_cast hd
  have hsum : (∑ j : Fin m, a j) ≤ (1 + α) * (d : ℝ) := by
    have h := Finset.sum_le_sum (fun j (_ : j ∈ (Finset.univ : Finset (Fin m))) => (ha j).2)
    rw [← Finset.mul_sum] at h
    change _ ≤ (1 + α) * rowSqNormProbDen U at h
    rwa [rowSqNormProbDen_eq_nat_of_orthonormal_columns U hU] at h
  have hlev := rowNormSq_nonneg U i
  have hminus : 0 < 1 - α := by linarith
  have hplus : 0 < 1 + α := by linarith
  change _ ≤ a i / ∑ j : Fin m, a j
  apply (le_div_iff₀ hden).mpr
  calc
    _ ≤ (((1 - α) / (1 + α)) * (rowNormSq U i / (d : ℝ))) * ((1 + α) * (d : ℝ)) :=
      mul_le_mul_of_nonneg_left hsum (by positivity)
    _ = (1 - α) * rowNormSq U i := by field_simp
    _ ≤ a i := (ha i).1

end NumStability
