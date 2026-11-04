import ComputationalMathematics.HDP.Matrix.OperatorNormLowerExpectation

/-!
# Vershynin Chapter 4, Exercise 4.4.7
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

/-- Vershynin, Exercise 4.4.7: under Theorem 4.4.5's independent centered
sub-Gaussian hypotheses and the additional unit-variance assumption, the
expected operator norm is at least `(sqrt m + sqrt n) / 4` once both dimensions
are sufficiently large.  The threshold is chosen before the dimensions and
the matrix, and depends only on a common upper bound for the entrywise `ψ₂`
scale (and on the absolute constant). -/
theorem hdp_04_exercise_4_4_7 :
    ∃ C : ℝ, 1 ≤ C ∧
      ∀ K : ℝ, 0 ≤ K → ∃ N : ℕ,
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ} (hm : 0 < m) (hn : 0 < n),
        N ≤ m → N ≤ n →
        letI : Nonempty (Fin m) := Fin.pos_iff_nonempty.mp hm
        letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
        ∀ (A : Ω → Matrix (Fin m) (Fin n) ℝ),
        (∀ ij : Fin m × Fin n,
          NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
            (fun ω ↦ A ω ij.1 ij.2)) →
        (∀ ij : Fin m × Fin n,
          Integrable (fun ω ↦ A ω ij.1 ij.2) μ ∧
            (∫ ω, A ω ij.1 ij.2 ∂μ) = 0) →
        (∀ ij : Fin m × Fin n,
          (∫ ω, A ω ij.1 ij.2 ^ 2 ∂μ) = 1) →
        iIndepFun (fun ij : Fin m × Fin n ↦
          fun ω ↦ A ω ij.1 ij.2) μ →
        NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
          (fun ij : Fin m × Fin n ↦ fun ω ↦ A ω ij.1 ij.2) ≤ K →
        (Real.sqrt (m : ℝ) + Real.sqrt (n : ℝ)) / 4 ≤
          ∫ ω, NumStability.realMatrixOperatorNorm (A ω) ∂μ := by
  rcases NumStability.HDP.Matrix.exists_expected_operatorNorm_lower_bound_of_independent_unitVariance_entries with
    ⟨C, hC, hMain⟩
  refine ⟨C, hC, ?_⟩
  intro K hK
  refine ⟨⌈(2 * C * K ^ 2) ^ 2⌉₊, ?_⟩
  intro Ω _ μ _ m n hm hn hNm hNn
  letI : Nonempty (Fin m) := Fin.pos_iff_nonempty.mp hm
  letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
  intro A hSub hCenter hSecond hIndep hKmax
  apply hMain hm hn A
  · exact fun ij ↦ (hSub ij).1
  · exact fun ij ↦
      (NumStability.HDP.Scalar.SubGaussian.isSubGaussian_iff_psiTwoNorm_finite
        (μ := μ) (X := fun ω ↦ A ω ij.1 ij.2)).mp (hSub ij)
  · exact fun ij ↦ (hCenter ij).1
  · exact hSecond
  · exact hIndep
  · have hC0 : 0 ≤ C := le_trans zero_le_one hC
    have hKactual0 : 0 ≤
        NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
          (fun ij : Fin m × Fin n ↦ fun ω ↦ A ω ij.1 ij.2) :=
      NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax_nonneg
    have hthreshold : (2 * C * K ^ 2) ^ 2 ≤ (m : ℝ) := by
      exact (Nat.le_ceil ((2 * C * K ^ 2) ^ 2)).trans
        (by exact_mod_cast hNm)
    have hlarge : 2 * C * K ^ 2 ≤ Real.sqrt (m : ℝ) :=
      (Real.le_sqrt (by positivity) (by positivity)).2 hthreshold
    have hKsquared :
        (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
          (fun ij : Fin m × Fin n ↦ fun ω ↦ A ω ij.1 ij.2)) ^ 2 ≤ K ^ 2 :=
      (sq_le_sq₀ hKactual0 hK).2 hKmax
    exact (mul_le_mul_of_nonneg_left hKsquared (by positivity)).trans hlarge
  · have hC0 : 0 ≤ C := le_trans zero_le_one hC
    have hKactual0 : 0 ≤
        NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
          (fun ij : Fin m × Fin n ↦ fun ω ↦ A ω ij.1 ij.2) :=
      NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax_nonneg
    have hthreshold : (2 * C * K ^ 2) ^ 2 ≤ (n : ℝ) := by
      exact (Nat.le_ceil ((2 * C * K ^ 2) ^ 2)).trans
        (by exact_mod_cast hNn)
    have hlarge : 2 * C * K ^ 2 ≤ Real.sqrt (n : ℝ) :=
      (Real.le_sqrt (by positivity) (by positivity)).2 hthreshold
    have hKsquared :
        (NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
          (fun ij : Fin m × Fin n ↦ fun ω ↦ A ω ij.1 ij.2)) ^ 2 ≤ K ^ 2 :=
      (sq_le_sq₀ hKactual0 hK).2 hKmax
    exact (mul_le_mul_of_nonneg_left hKsquared (by positivity)).trans hlarge

end NumStability.HDP.Contract
