import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.LeverageScore.Core
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.RowNorm.TraceMoments

/-!
# Residual cross moments for independent leverage row sampling

The residual is orthogonal to the columns of the basis. Sampling its cross
product with those columns has mean zero and second moment at most
`d / s` times its squared norm. Rows with zero leverage require no support
assumption on the residual.
-/

namespace NumStability

open scoped BigOperators

/-- Cross product of a sampled basis with a sampled residual, written without
square roots. Division at zero leverage is harmless because the basis row is zero. -/
noncomputable def rowSampleResidualCross {m d s : ℕ}
    (U : Fin m → Fin d → ℝ) (r : Fin m → ℝ)
    (samples : RowTrace m s) : Fin d → ℝ :=
  fun j => (∑ t : Fin s,
    U (samples t) j * r (samples t) / rowSqNormProb U (samples t)) / (s : ℝ)

/-- Zero leverage forces every coordinate of that basis row to vanish. -/
theorem rowSampleResidualCross_row_zero_of_prob_zero {m d : ℕ}
    (U : Fin m → Fin d → ℝ) (hden : 0 < rowSqNormProbDen U)
    (i : Fin m) (hi : rowSqNormProb U i = 0) (j : Fin d) : U i j = 0 := by
  have hz : rowNormSq U i = 0 := by
    exact (div_eq_zero_iff.mp hi).resolve_right hden.ne'
  exact (rowNormSq_eq_zero_iff U i).mp hz j

private theorem residualCross_mean {m d : ℕ}
    (U : Fin m → Fin d → ℝ) (hden : 0 < rowSqNormProbDen U)
    (r : Fin m → ℝ) (j : Fin d) :
    (∑ i : Fin m, rowSqNormProb U i * (U i j * r i / rowSqNormProb U i)) =
      ∑ i : Fin m, U i j * r i := by
  apply Finset.sum_congr rfl
  intro i _
  by_cases hi : rowSqNormProb U i = 0
  · rw [rowSampleResidualCross_row_zero_of_prob_zero U hden i hi j]
    simp
  · field_simp

private theorem residualCross_row_second_moment_le {m d : ℕ}
    (U : Fin m → Fin d → ℝ) (hden : 0 < rowSqNormProbDen U)
    (r : Fin m → ℝ) (i : Fin m) :
    (∑ j : Fin d, rowSqNormProb U i *
      (U i j * r i / rowSqNormProb U i) ^ 2) ≤ rowSqNormProbDen U * r i ^ 2 := by
  by_cases hi : rowSqNormProb U i = 0
  · simp only [hi, zero_mul, Finset.sum_const_zero]
    exact mul_nonneg hden.le (sq_nonneg _)
  · have hrow : rowNormSq U i ≠ 0 := by
      intro hz
      exact hi (by simp [rowSqNormProb, hz])
    have heq : (∑ j : Fin d, rowSqNormProb U i *
        (U i j * r i / rowSqNormProb U i) ^ 2) =
        rowNormSq U i * r i ^ 2 / rowSqNormProb U i := by
      unfold rowNormSq
      rw [Finset.sum_mul, Finset.sum_div]
      apply Finset.sum_congr rfl
      intro j _
      field_simp
    rw [heq, rowSqNormProb]
    exact le_of_eq (by field_simp)

/-- The squared cross moment has the `d / s` leverage sampling rate. -/
theorem rowSampleResidualCross_expectation_vecNorm2Sq_le {m d s : ℕ}
    (U : Fin m → Fin d → ℝ) (hU : HasOrthonormalColumns U) (hd : 0 < d)
    (r : Fin m → ℝ) (hs : 0 < (s : ℝ))
    (horth : ∀ j : Fin d, ∑ i : Fin m, U i j * r i = 0) :
    (rowSqNormTraceProbability (steps := s) U
      (rowSqNormProbDen_pos_of_orthonormal_columns U hU hd)).expectationReal
        (fun samples => vecNorm2Sq (rowSampleResidualCross U r samples)) ≤
      ((d : ℝ) / (s : ℝ)) * vecNorm2Sq r := by
  classical
  let hden := rowSqNormProbDen_pos_of_orthonormal_columns U hU hd
  have hcoord : ∀ j : Fin d,
      (rowSqNormTraceProbability (steps := s) U hden).expectationReal
        (fun samples => rowSampleResidualCross U r samples j ^ 2) =
      (1 / (s : ℝ)) * ∑ i : Fin m,
        rowSqNormProb U i * (U i j * r i / rowSqNormProb U i) ^ 2 := by
    intro j
    have hv := rowSqNormTraceProbability_expectationReal_sampleAverage_sub_mean_sq
      (s := s) U hden hs (fun i => U i j * r i / rowSqNormProb U i)
    simpa [residualCross_mean U hden r j, horth j, rowSampleResidualCross] using hv
  calc
    _ = ∑ j : Fin d, (1 / (s : ℝ)) * ∑ i : Fin m,
        rowSqNormProb U i * (U i j * r i / rowSqNormProb U i) ^ 2 := by
      unfold vecNorm2Sq
      rw [FiniteProbability.expectationReal_sum]
      exact Finset.sum_congr rfl (fun j _ => hcoord j)
    _ = (1 / (s : ℝ)) * ∑ i : Fin m, ∑ j : Fin d,
        rowSqNormProb U i * (U i j * r i / rowSqNormProb U i) ^ 2 := by
      rw [← Finset.mul_sum, Finset.sum_comm]
    _ ≤ (1 / (s : ℝ)) * ∑ i : Fin m, rowSqNormProbDen U * r i ^ 2 := by
      apply mul_le_mul_of_nonneg_left _ (by positivity)
      exact Finset.sum_le_sum (fun i _ => residualCross_row_second_moment_le U hden r i)
    _ = ((d : ℝ) / (s : ℝ)) * vecNorm2Sq r := by
      rw [← Finset.mul_sum, rowSqNormProbDen_eq_nat_of_orthonormal_columns U hU]
      unfold vecNorm2Sq
      ring

/-- Markov bound for a residual cross product at a relative squared-norm
threshold. The zero residual is included. -/
theorem rowSampleResidualCross_eventProb_ge_one_sub {m d s : ℕ}
    (U : Fin m → Fin d → ℝ) (hU : HasOrthonormalColumns U) (hd : 0 < d)
    (r : Fin m → ℝ) (hs : 0 < (s : ℝ))
    (horth : ∀ j : Fin d, ∑ i : Fin m, U i j * r i = 0)
    (η : ℝ) (hη : 0 < η) :
    1 - 4 * (d : ℝ) / ((s : ℝ) * η) ≤
      (rowSqNormTraceProbability (steps := s) U
        (rowSqNormProbDen_pos_of_orthonormal_columns U hU hd)).eventProb
          {samples | vecNorm2Sq (rowSampleResidualCross U r samples) ≤
            η / 4 * vecNorm2Sq r} := by
  classical
  let P := rowSqNormTraceProbability (steps := s) U
    (rowSqNormProbDen_pos_of_orthonormal_columns U hU hd)
  by_cases hr : vecNorm2Sq r = 0
  · have hrzero : ∀ i, r i = 0 := by
      have hsum := (Finset.sum_eq_zero_iff_of_nonneg
        (fun i (_ : i ∈ (Finset.univ : Finset (Fin m))) => sq_nonneg (r i))).mp hr
      intro i
      exact sq_eq_zero_iff.mp (hsum i (Finset.mem_univ i))
    have hevent : P.eventProb
        {samples | vecNorm2Sq (rowSampleResidualCross U r samples) ≤
          η / 4 * vecNorm2Sq r} = 1 := by
      apply P.eventProb_eq_one_of_forall
      intro samples
      simp [rowSampleResidualCross, hrzero, vecNorm2Sq]
    change _ ≤ P.eventProb _
    rw [hevent]
    have : 0 ≤ 4 * (d : ℝ) / ((s : ℝ) * η) := by positivity
    linarith
  · have hrpos : 0 < vecNorm2Sq r := lt_of_le_of_ne (vecNorm2Sq_nonneg r) (Ne.symm hr)
    have hT : 0 < η / 4 * vecNorm2Sq r := by positivity
    have hmarkov := P.eventProb_real_le_ge_one_sub_expectationReal_div
      (fun samples => vecNorm2Sq (rowSampleResidualCross U r samples))
      (η / 4 * vecNorm2Sq r) (fun _ => vecNorm2Sq_nonneg _) hT
    have hm := rowSampleResidualCross_expectation_vecNorm2Sq_le U hU hd r hs horth
    have hratio : P.expectationReal
        (fun samples => vecNorm2Sq (rowSampleResidualCross U r samples)) /
          (η / 4 * vecNorm2Sq r) ≤ 4 * (d : ℝ) / ((s : ℝ) * η) := by
      calc
        _ ≤ (((d : ℝ) / (s : ℝ)) * vecNorm2Sq r) /
            (η / 4 * vecNorm2Sq r) := div_le_div_of_nonneg_right hm hT.le
        _ = _ := by field_simp
    exact (sub_le_sub_left hratio 1).trans hmarkov

end NumStability
