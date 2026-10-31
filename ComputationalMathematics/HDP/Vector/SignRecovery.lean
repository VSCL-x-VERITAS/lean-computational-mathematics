import Mathlib.Algebra.Order.BigOperators.Group.Finset
import Mathlib.Algebra.Order.Ring.Abs
import Mathlib.Analysis.InnerProductSpace.PiL2
import ComputationalMathematics.Analysis.MatrixAlgebra

/-!
# Sign recovery from squared error

Each sign disagreement with a `{±1}` target costs at least one unit of squared
Euclidean error.
-/

open Finset

namespace NumStability.HDP.Vector.SignRecovery

/-- Indices where the estimate has the wrong sign, with zero assigned to the
nonpositive side. -/
noncomputable def signDisagreements {n : ℕ} (u v : Fin n → ℝ) : Finset (Fin n) :=
  Finset.univ.filter fun i ↦ u i * v i ≤ 0

/-- Vertices misclassified by thresholding at zero, with a zero score assigned
to community `1`.  This is the classifier convention used by the source
spectral-clustering algorithm. -/
noncomputable def binaryThresholdMisclassifications {n : ℕ}
    (community : Fin n → Fin 2) (v : Fin n → ℝ) : Finset (Fin n) :=
  Finset.univ.filter fun i ↦
    if community i = 0 then v i ≤ 0 else 0 < v i

/-- Exact threshold-classification errors are contained in the symmetric
sign-disagreement set for the associated `{±1}` signal. -/
theorem binaryThresholdMisclassifications_subset_signDisagreements
    {n : ℕ} (community : Fin n → Fin 2) (u v : Fin n → ℝ)
    (hu : ∀ i, u i = if community i = 0 then 1 else -1) :
    binaryThresholdMisclassifications community v ⊆ signDisagreements u v := by
  intro i hi
  simp only [binaryThresholdMisclassifications, Finset.mem_filter,
    Finset.mem_univ, true_and] at hi
  simp only [signDisagreements, Finset.mem_filter, Finset.mem_univ, true_and]
  rw [hu i]
  by_cases h : community i = 0
  · simpa [h] using hi
  · simp only [h, ↓reduceIte] at hi ⊢
    linarith

theorem one_le_sq_sub_of_sign_disagreement {a b : ℝ}
    (ha : |a| = 1) (hab : a * b ≤ 0) : 1 ≤ (a - b) ^ 2 := by
  have ha2 : a * a = 1 * 1 :=
    abs_eq_iff_mul_self_eq.mp (by simpa using ha)
  nlinarith [sq_nonneg b]

/-- The number of sign errors is bounded by total squared coefficient error. -/
theorem card_signDisagreements_le_sum_sq {n : ℕ} (u v : Fin n → ℝ)
    (hu : ∀ i, |u i| = 1) :
    ((signDisagreements u v).card : ℝ) ≤ ∑ i, (u i - v i) ^ 2 := by
  calc
    ((signDisagreements u v).card : ℝ) =
        ∑ i ∈ signDisagreements u v, (1 : ℝ) := by simp
    _ ≤ ∑ i ∈ signDisagreements u v, (u i - v i) ^ 2 := by
      gcongr with i hi
      exact one_le_sq_sub_of_sign_disagreement (hu i) (Finset.mem_filter.mp hi).2
    _ ≤ ∑ i ∈ (Finset.univ : Finset (Fin n)), (u i - v i) ^ 2 :=
      Finset.sum_le_sum_of_subset_of_nonneg (Finset.filter_subset _ _)
        (fun i _ _ ↦ sq_nonneg (u i - v i))
    _ = ∑ i, (u i - v i) ^ 2 := rfl

/-- The source's asymmetric zero-threshold classifier inherits the same
squared-error count bound. -/
theorem card_binaryThresholdMisclassifications_le_sum_sq {n : ℕ}
    (community : Fin n → Fin 2) (u v : Fin n → ℝ)
    (hu : ∀ i, u i = if community i = 0 then 1 else -1) :
    ((binaryThresholdMisclassifications community v).card : ℝ) ≤
      ∑ i, (u i - v i) ^ 2 := by
  have hsubset :=
    binaryThresholdMisclassifications_subset_signDisagreements community u v hu
  have hcard :
      ((binaryThresholdMisclassifications community v).card : ℝ) ≤
        ((signDisagreements u v).card : ℝ) := by
    exact_mod_cast Finset.card_le_card hsubset
  exact hcard.trans (card_signDisagreements_le_sum_sq u v fun i ↦ by rw [hu i]; split <;> simp)

/-- Squaring an `ℓ₂` error bound of size `√C / μ` gives the coordinatewise
squared-error bound `C / μ²`. -/
theorem sum_sq_sub_le_div_sq_of_vecNorm2_le {n : ℕ}
    (u v : Fin n → ℝ) (C μ : ℝ) (hC : 0 ≤ C) (hμ : 0 < μ)
    (h : NumStability.vecNorm2 (u - v) ≤ Real.sqrt C / μ) :
    ∑ i, (u i - v i) ^ 2 ≤ C / μ ^ 2 := by
  have hrhs : 0 ≤ Real.sqrt C / μ := div_nonneg (Real.sqrt_nonneg _) hμ.le
  have hsq : NumStability.vecNorm2 (u - v) ^ 2 ≤ (Real.sqrt C / μ) ^ 2 := by
    nlinarith [NumStability.vecNorm2_nonneg (u - v)]
  rw [NumStability.vecNorm2_sq] at hsq
  have hsqrt : (Real.sqrt C) ^ 2 = C := Real.sq_sqrt hC
  unfold NumStability.vecNorm2Sq at hsq
  simpa [div_pow, hsqrt] using hsq

/-- An ordinary Euclidean-norm error bound controls the number of sign
disagreements with a `{±1}` target. -/
theorem card_signDisagreements_le_div_sq_of_euclideanNorm_le {n : ℕ}
    (u v : EuclideanSpace ℝ (Fin n)) (hu : ∀ i, |u i| = 1)
    (B μ : ℝ) (hB : 0 ≤ B) (hμ : 0 < μ)
    (herror : ‖u - v‖ ≤ B / μ) :
    ((signDisagreements u v).card : ℝ) ≤ B ^ 2 / μ ^ 2 := by
  have hsq : ‖u - v‖ ^ 2 ≤ (B / μ) ^ 2 := by
    exact (sq_le_sq₀ (norm_nonneg _) (div_nonneg hB hμ.le)).2 herror
  have hsum :
      (∑ i, (u i - v i) ^ 2) = ‖u - v‖ ^ 2 := by
    rw [EuclideanSpace.norm_sq_eq]
    apply Finset.sum_congr rfl
    intro i _hi
    simp only [PiLp.sub_apply, Real.norm_eq_abs, sq_abs]
  calc
    ((signDisagreements u v).card : ℝ) ≤
        ∑ i, (u i - v i) ^ 2 :=
      card_signDisagreements_le_sum_sq u v hu
    _ = ‖u - v‖ ^ 2 := hsum
    _ ≤ (B / μ) ^ 2 := hsq
    _ = B ^ 2 / μ ^ 2 := by rw [div_pow]

end NumStability.HDP.Vector.SignRecovery
