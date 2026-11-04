import ComputationalMathematics.HDP.Matrix.SymmetricOperatorNormSubGaussian

/-!
# Operator norm of symmetric matrices with bounded independent entries

The bounded-entry specialization of the symmetric sub-Gaussian operator-norm
tail.  This is the reusable probabilistic step behind the stochastic-block
noise estimate.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set
open scoped ENNReal

namespace NumStability.HDP.Matrix

/-- A symmetric random matrix with independent centered entries on and above
the diagonal, all bounded in absolute value by one, has operator norm
`O(√n)` except on an event of probability at most `4 exp (-n)`. -/
theorem exists_symmetric_operatorNorm_sqrt_tail_of_independent_centered_bounded_entries :
    ∃ C : ℝ, 0 < C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {n : ℕ} (hn : 0 < n),
        letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
        ∀ (A : Ω → Matrix (Fin n) (Fin n) ℝ),
        (∀ ω i j, A ω i j = A ω j i) →
        (∀ i j, Measurable (fun ω => A ω i j)) →
        (∀ ω i j, |A ω i j| ≤ 1) →
        (∀ ij : {ij : Fin n × Fin n // ij.1 ≤ ij.2},
          (∫ ω, A ω ij.1.1 ij.1.2 ∂μ) = 0) →
        iIndepFun
          (fun ij : {ij : Fin n × Fin n // ij.1 ≤ ij.2} =>
            fun ω => A ω ij.1.1 ij.1.2) μ →
        μ.real {ω |
          C * Real.sqrt n < NumStability.realMatrixOperatorNorm (A ω)} ≤
            4 * Real.exp (-(n : ℝ)) := by
  rcases
      exists_symmetric_operatorNorm_tail_of_independent_centered_subGaussian_entries with
    ⟨C, hC, hTail⟩
  let B : ℝ := (Real.sqrt (Real.log 2))⁻¹
  refine ⟨2 * C * B, by dsimp [B]; positivity, ?_⟩
  intro Ω instΩ μ instμ n hn
  letI : Nonempty (Fin n) := Fin.pos_iff_nonempty.mp hn
  intro A hSym hMeas hBound hMean hIndep
  have hB : 0 < B := by
    dsimp [B]
    positivity
  have hSub : ∀ ij : {ij : Fin n × Fin n // ij.1 ≤ ij.2},
      NumStability.HDP.Scalar.SubGaussian.IsSubGaussian μ
        (fun ω => A ω ij.1.1 ij.1.2) := by
    intro ij
    exact NumStability.HDP.Scalar.SubGaussian.isSubGaussian_of_abs_le_const
      (hMeas ij.1.1 ij.1.2) zero_lt_one (fun ω => hBound ω ij.1.1 ij.1.2)
  have hCenter : ∀ ij : {ij : Fin n × Fin n // ij.1 ≤ ij.2},
      Integrable (fun ω => A ω ij.1.1 ij.1.2) μ ∧
        (∫ ω, A ω ij.1.1 ij.1.2 ∂μ) = 0 := by
    intro ij
    refine ⟨?_, hMean ij⟩
    refine (MeasureTheory.integrable_const (μ := μ) (1 : ℝ)).mono' ?_ ?_
    · exact (hMeas ij.1.1 ij.1.2).aestronglyMeasurable
    · filter_upwards [] with ω
      simpa only [Real.norm_eq_abs, norm_one] using hBound ω ij.1.1 ij.1.2
  have hPsi :
      NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
          (fun ij : Fin n × Fin n => fun ω => A ω ij.1 ij.2) ≤ B := by
    unfold NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax
    apply Finset.sup'_le Finset.univ_nonempty
    intro ij _hij
    have hGauge :=
      NumStability.HDP.Scalar.SubGaussian.essentiallyBoundedPsiTwoGauge
        (μ := μ) (X := fun ω => A ω ij.1 ij.2)
        (hMeas ij.1 ij.2) zero_lt_one
        (Filter.Eventually.of_forall fun ω => hBound ω ij.1 ij.2)
    have hToReal := ENNReal.toReal_mono ENNReal.ofReal_ne_top hGauge
    simpa [NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm, B,
      ENNReal.toReal_ofReal hB.le] using hToReal
  have hTailSqrt := hTail hn A hSym hSub hCenter hIndep
    (show 0 < Real.sqrt (n : ℝ) by positivity)
  have hThreshold :
      C * NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
          (fun ij : Fin n × Fin n => fun ω => A ω ij.1 ij.2) *
            (Real.sqrt n + Real.sqrt n) ≤
        (2 * C * B) * Real.sqrt n := by
    have hSqrt : 0 ≤ Real.sqrt (n : ℝ) := Real.sqrt_nonneg _
    have hCB : C *
        NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
          (fun ij : Fin n × Fin n => fun ω => A ω ij.1 ij.2) ≤ C * B :=
      mul_le_mul_of_nonneg_left hPsi hC.le
    calc
      C * NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
            (fun ij : Fin n × Fin n => fun ω => A ω ij.1 ij.2) *
          (Real.sqrt n + Real.sqrt n) ≤
          (C * B) * (Real.sqrt n + Real.sqrt n) := by
            exact mul_le_mul_of_nonneg_right hCB (by positivity)
      _ = (2 * C * B) * Real.sqrt n := by ring
  have hSubset :
      {ω | (2 * C * B) * Real.sqrt n <
          NumStability.realMatrixOperatorNorm (A ω)} ⊆
        {ω | C * NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
              (fun ij : Fin n × Fin n => fun ω => A ω ij.1 ij.2) *
              (Real.sqrt n + Real.sqrt n) <
            NumStability.realMatrixOperatorNorm (A ω)} := by
    intro ω hω
    exact hThreshold.trans_lt hω
  calc
    μ.real {ω | (2 * C * B) * Real.sqrt n <
        NumStability.realMatrixOperatorNorm (A ω)} ≤
        μ.real {ω | C * NumStability.HDP.Scalar.SubGaussian.psiTwoNormMax μ
              (fun ij : Fin n × Fin n => fun ω => A ω ij.1 ij.2) *
              (Real.sqrt n + Real.sqrt n) <
            NumStability.realMatrixOperatorNorm (A ω)} :=
      measureReal_mono hSubset (measure_ne_top μ _)
    _ ≤ 4 * Real.exp (-(Real.sqrt (n : ℝ)) ^ 2) := hTailSqrt
    _ = 4 * Real.exp (-(n : ℝ)) := by
      rw [Real.sq_sqrt]
      positivity

end NumStability.HDP.Matrix
