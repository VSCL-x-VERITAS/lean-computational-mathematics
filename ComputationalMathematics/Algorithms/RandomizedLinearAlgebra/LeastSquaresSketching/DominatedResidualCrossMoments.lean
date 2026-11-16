import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.RowNorm.TraceMoments
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.IndependentTraceMoments

/-!
# Residual cross moments for a supplied iid row law

The scalar variance identity specializes the generic finite iid sample-average
variance theorem.
An importance-weight cap then bounds the residual cross moment.
-/
namespace NumStability
open scoped BigOperators

/-- Finite-index sum form of the generic iid sample-average variance identity. -/
theorem FiniteProbability.iid_expectationReal_sampleAverage_sub_mean_sq_fin_formula
    {m s : ℕ} (P : FiniteProbability (Fin m)) (hs : 0 < (s : ℝ)) (f : Fin m → ℝ) :
    let μ : ℝ := P.expectationReal f
    (P.iid s).expectationReal
      (fun samples => ((∑ t : Fin s, f (samples t)) / (s : ℝ) - μ) ^ 2) =
      (1 / (s : ℝ)) * ∑ i : Fin m, P.prob i * (f i - μ) ^ 2 := by
  dsimp
  rw [P.iid_expectationReal_sampleAverage_sub_mean_sq hs f]
  unfold FiniteProbability.varianceReal
  change (∑ i : Fin m, P.prob i * (f i - P.expectationReal f) ^ 2) / (s : ℝ) = _
  ring

/-- Importance-weighted sampled residual cross product for the supplied law. -/
noncomputable def dominatedResidualCross {m d s : ℕ}
    (U : Fin m → Fin d → ℝ) (P : FiniteProbability (Fin m))
    (r : Fin m → ℝ) (samples : Fin s → Fin m) : Fin d → ℝ :=
  fun j => (∑ t : Fin s, U (samples t) j * r (samples t) / P.prob (samples t)) / (s : ℝ)

private theorem dominatedResidualCross_cap_nonneg {m d : ℕ} {L : ℝ}
    (U : Fin m → Fin d → ℝ) (P : FiniteProbability (Fin m))
    (hcap : ∀ i, rowNormSq U i ≤ L * P.prob i) : 0 ≤ L := by
  have hsum := Finset.sum_le_sum (fun i (_ : i ∈ (Finset.univ : Finset (Fin m))) => hcap i)
  rw [← Finset.mul_sum, P.prob_sum, mul_one] at hsum
  exact (Finset.sum_nonneg (fun i _ => rowNormSq_nonneg U i)).trans hsum

private theorem dominatedResidualCross_row_zero {m d : ℕ} {L : ℝ}
    (U : Fin m → Fin d → ℝ) (P : FiniteProbability (Fin m))
    (hcap : ∀ i, rowNormSq U i ≤ L * P.prob i)
    (i : Fin m) (hi : P.prob i = 0) (j : Fin d) : U i j = 0 := by
  have hz : rowNormSq U i = 0 :=
    le_antisymm (by simpa [hi] using hcap i) (rowNormSq_nonneg U i)
  exact (rowNormSq_eq_zero_iff U i).mp hz j

private theorem dominatedResidualCross_mean {m d : ℕ} {L : ℝ}
    (U : Fin m → Fin d → ℝ) (P : FiniteProbability (Fin m)) (r : Fin m → ℝ)
    (hcap : ∀ i, rowNormSq U i ≤ L * P.prob i) (j : Fin d) :
    P.expectationReal (fun i => U i j * r i / P.prob i) = ∑ i, U i j * r i := by
  unfold FiniteProbability.expectationReal
  apply Finset.sum_congr rfl
  intro i _
  by_cases hi : P.prob i = 0
  · simp [hi, dominatedResidualCross_row_zero U P hcap i hi j]
  · field_simp

private theorem dominatedResidualCross_row_second_moment_le {m d : ℕ} {L : ℝ}
    (U : Fin m → Fin d → ℝ) (P : FiniteProbability (Fin m)) (r : Fin m → ℝ)
    (hcap : ∀ i, rowNormSq U i ≤ L * P.prob i) (i : Fin m) :
    (∑ j : Fin d, P.prob i * (U i j * r i / P.prob i) ^ 2) ≤ L * r i ^ 2 := by
  by_cases hi : P.prob i = 0
  · simp only [hi, zero_mul, Finset.sum_const_zero]
    exact mul_nonneg (dominatedResidualCross_cap_nonneg U P hcap) (sq_nonneg _)
  · have heq : (∑ j : Fin d, P.prob i * (U i j * r i / P.prob i) ^ 2) =
        (rowNormSq U i / P.prob i) * r i ^ 2 := by
      unfold rowNormSq
      rw [Finset.sum_div, Finset.sum_mul]
      apply Finset.sum_congr rfl
      intro j _
      field_simp
    rw [heq]
    have hpos : 0 < P.prob i := lt_of_le_of_ne (P.prob_nonneg i) (Ne.symm hi)
    exact mul_le_mul_of_nonneg_right ((div_le_iff₀ hpos).mpr (hcap i)) (sq_nonneg _)

/-- The residual cross second moment is linear in the importance-weight cap. -/
theorem dominatedResidualCross_expectation_vecNorm2Sq_le {m d s : ℕ} {L : ℝ}
    (U : Fin m → Fin d → ℝ) (P : FiniteProbability (Fin m)) (r : Fin m → ℝ)
    (hs : 0 < (s : ℝ)) (hcap : ∀ i, rowNormSq U i ≤ L * P.prob i)
    (horth : ∀ j : Fin d, ∑ i : Fin m, U i j * r i = 0) :
    (P.iid s).expectationReal (fun samples => vecNorm2Sq (dominatedResidualCross U P r samples)) ≤
      (L / (s : ℝ)) * vecNorm2Sq r := by
  classical
  have hcoord : ∀ j : Fin d,
      (P.iid s).expectationReal (fun samples => dominatedResidualCross U P r samples j ^ 2) =
      (1 / (s : ℝ)) * ∑ i : Fin m, P.prob i * (U i j * r i / P.prob i) ^ 2 := by
    intro j
    have hv := P.iid_expectationReal_sampleAverage_sub_mean_sq_fin_formula hs
      (fun i => U i j * r i / P.prob i)
    simpa [dominatedResidualCross_mean U P r hcap j, horth j, dominatedResidualCross] using hv
  calc
    _ = (1 / (s : ℝ)) * ∑ i : Fin m, ∑ j : Fin d,
        P.prob i * (U i j * r i / P.prob i) ^ 2 := by
      unfold vecNorm2Sq
      rw [FiniteProbability.expectationReal_sum]
      simp_rw [hcoord]
      rw [← Finset.mul_sum, Finset.sum_comm]
    _ ≤ (1 / (s : ℝ)) * ∑ i : Fin m, L * r i ^ 2 := by
      apply mul_le_mul_of_nonneg_left _ (by positivity)
      exact Finset.sum_le_sum (fun i _ => dominatedResidualCross_row_second_moment_le U P r hcap i)
    _ = (L / (s : ℝ)) * vecNorm2Sq r := by
      rw [← Finset.mul_sum]
      unfold vecNorm2Sq
      ring

/-- Relative Markov bound for the importance-weighted residual cross product.
Zero residuals and zero-probability basis rows are included. -/
theorem dominatedResidualCross_eventProb_ge_one_sub {m d s : ℕ} {L : ℝ}
    (U : Fin m → Fin d → ℝ) (P : FiniteProbability (Fin m)) (r : Fin m → ℝ)
    (hs : 0 < (s : ℝ)) (hcap : ∀ i, rowNormSq U i ≤ L * P.prob i)
    (horth : ∀ j : Fin d, ∑ i : Fin m, U i j * r i = 0)
    (η : ℝ) (hη : 0 < η) :
    1 - 4 * L / ((s : ℝ) * η) ≤ (P.iid s).eventProb
      {samples | vecNorm2Sq (dominatedResidualCross U P r samples) ≤ η / 4 * vecNorm2Sq r} := by
  classical
  let Q := P.iid s
  have hL : 0 ≤ L := dominatedResidualCross_cap_nonneg U P hcap
  by_cases hr : vecNorm2Sq r = 0
  · have hrzero : ∀ i, r i = 0 := by
      have hsum := (Finset.sum_eq_zero_iff_of_nonneg
        (fun i (_ : i ∈ (Finset.univ : Finset (Fin m))) => sq_nonneg (r i))).mp hr
      intro i
      exact sq_eq_zero_iff.mp (hsum i (Finset.mem_univ i))
    have hevent : Q.eventProb
        {samples | vecNorm2Sq (dominatedResidualCross U P r samples) ≤ η / 4 * vecNorm2Sq r} = 1 := by
      apply Q.eventProb_eq_one_of_forall
      intro samples
      simp [dominatedResidualCross, hrzero, vecNorm2Sq]
    change _ ≤ Q.eventProb _
    rw [hevent]
    have : 0 ≤ 4 * L / ((s : ℝ) * η) := by positivity
    linarith
  · have hrpos : 0 < vecNorm2Sq r := lt_of_le_of_ne (vecNorm2Sq_nonneg r) (Ne.symm hr)
    have hT : 0 < η / 4 * vecNorm2Sq r := by positivity
    have hmom := dominatedResidualCross_expectation_vecNorm2Sq_le U P r hs hcap horth
    have hmarkov := Q.eventProb_real_le_ge_one_sub_expectationReal_div
      (fun samples => vecNorm2Sq (dominatedResidualCross U P r samples))
      (η / 4 * vecNorm2Sq r) (fun _ => vecNorm2Sq_nonneg _) hT
    have hratio : Q.expectationReal
        (fun samples => vecNorm2Sq (dominatedResidualCross U P r samples)) /
          (η / 4 * vecNorm2Sq r) ≤ 4 * L / ((s : ℝ) * η) := by
      calc
        _ ≤ (L / (s : ℝ) * vecNorm2Sq r) / (η / 4 * vecNorm2Sq r) :=
          div_le_div_of_nonneg_right hmom hT.le
        _ = _ := by field_simp
    exact (sub_le_sub_left hratio 1).trans hmarkov

end NumStability
