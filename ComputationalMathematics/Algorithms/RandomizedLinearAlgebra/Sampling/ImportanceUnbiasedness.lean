import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.IndependentTrace
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.Elementwise.Core
import ComputationalMathematics.Algorithms.RandomizedLinearAlgebra.Sampling.RowNorm.Gram

/-! # Unbiased importance-sampling sketches

The supplied finite law may have zero atoms, provided the input vanishes there.
-/
namespace NumStability
open scoped BigOperators

theorem iid_elementwiseTraceSketchWithProb_expectation_entry
    {m n s : ℕ} (A : Fin m → Fin n → ℝ)
    (P : FiniteProbability (Fin m × Fin n)) (hs : 0 < s)
    (hcover : ∀ i j, P.prob (i,j) = 0 → A i j = 0) (i : Fin m) (j : Fin n) :
    (P.iid s).expectationReal (fun ω =>
      elementwiseTraceSketchWithProb s A (fun _ _ => 0)
        (fun r c => P.prob (r,c)) ω i j) = A i j := by
  classical
  have hsR : (s : ℝ) ≠ 0 := by exact_mod_cast hs.ne'
  have hone : P.expectationReal
      (fun x => elementwiseSampleContributionWithProb s A
        (fun r c => P.prob (r,c)) x i j) = A i j / (s : ℝ) := by
    simp only [FiniteProbability.expectationReal, elementwiseSampleContributionWithProb,
      elementwiseIncrementWithProb, Fintype.sum_prod_type]
    simp only [mul_ite, mul_zero, ite_and]
    simp only [Finset.sum_ite_irrel, Finset.sum_ite_eq', Finset.mem_univ, if_true]
    simp only [Finset.sum_const_zero, Finset.sum_ite_eq', Finset.mem_univ, if_true]
    by_cases hp : P.prob (i,j) = 0
    · simp [hp, hcover i j hp]
    · field_simp
  have heval (t : Fin s) : (P.iid s).expectationReal
      (fun ω => elementwiseTraceContributionWithProb s A
        (fun r c => P.prob (r,c)) ω t i j) = A i j / (s : ℝ) := by
    simp_rw [elementwiseTraceContributionWithProb_eq_sampleContributionWithProb]
    exact (P.iid_expectationReal_eval t
      (fun x => elementwiseSampleContributionWithProb s A
        (fun r c => P.prob (r,c)) x i j)).trans hone
  change (P.iid s).expectationReal (fun ω => 0 +
    ∑ t, elementwiseTraceContributionWithProb s A
      (fun r c => P.prob (r,c)) ω t i j) = A i j
  simp only [zero_add, FiniteProbability.expectationReal_sum, heval, Finset.sum_const,
    Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
  field_simp

/-- Expected Gram entry of the literal square-root-rescaled iid row sketch. -/
theorem iid_rowSampleSketchWithProb_expectation_gram
    {m n s : ℕ} (A : Fin m → Fin n → ℝ)
    (P : FiniteProbability (Fin m)) (hs : 0 < s)
    (hcover : ∀ i, P.prob i = 0 → ∀ j, A i j = 0) (j k : Fin n) :
    (P.iid s).expectationReal
      (fun ω => rowGram (rowSampleSketchWithProb s A P.prob ω) j k) = rowGram A j k := by
  classical
  have hsR : (s : ℝ) ≠ 0 := by exact_mod_cast hs.ne'
  have hone : P.expectationReal
      (fun i => rowSampleIncrementWithProb s A P.prob i j *
        rowSampleIncrementWithProb s A P.prob i k) = rowGram A j k / (s : ℝ) := by
    unfold FiniteProbability.expectationReal rowGram
    rw [Finset.sum_div]
    apply Finset.sum_congr rfl
    intro i _
    by_cases hp : P.prob i = 0
    · simp [hp, hcover i hp j, rowSampleIncrementWithProb]
    · have hsnonneg : 0 ≤ (s : ℝ) * P.prob i := mul_nonneg (Nat.cast_nonneg _) (P.prob_nonneg _)
      simp only [rowSampleIncrementWithProb, rowSampleScaleDenWithProb]
      rw [div_mul_div_comm, Real.mul_self_sqrt hsnonneg]
      field_simp
  have heval (t : Fin s) : (P.iid s).expectationReal
      (fun ω => rowSampleIncrementWithProb s A P.prob (ω t) j *
        rowSampleIncrementWithProb s A P.prob (ω t) k) = rowGram A j k / (s : ℝ) := by
    exact (P.iid_expectationReal_eval t
      (fun i => rowSampleIncrementWithProb s A P.prob i j *
        rowSampleIncrementWithProb s A P.prob i k)).trans hone
  change (P.iid s).expectationReal (fun ω =>
    ∑ t, rowSampleIncrementWithProb s A P.prob (ω t) j *
      rowSampleIncrementWithProb s A P.prob (ω t) k) = rowGram A j k
  simp only [FiniteProbability.expectationReal_sum, heval, Finset.sum_const,
    Finset.card_univ, Fintype.card_fin, nsmul_eq_mul]
  field_simp

end NumStability
