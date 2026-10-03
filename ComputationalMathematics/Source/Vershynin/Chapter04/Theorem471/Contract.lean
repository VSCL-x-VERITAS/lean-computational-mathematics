import ComputationalMathematics.HDP.Vector.GeneralCovarianceEstimation

/-!
# Vershynin Chapter 4, Theorem 4.7.1
-/

noncomputable section

open Matrix MeasureTheory ProbabilityTheory
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- Vershynin, Theorem 4.7.1 (covariance estimation).  `Z` is the population
random vector and `X₁, …, Xₘ` are independent copies.  The only tail hypothesis
is the source's relative marginal condition (4.24).  The population and sample
matrices are the literal second-moment and empirical second-moment matrices;
no whitening factor, invertibility, or integrability premise is exposed. -/
theorem hdp_04_theorem_4_7_1 :
    ∃ C : ℝ, 0 < C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω}
        [IsProbabilityMeasure μ] {m n : ℕ},
        0 < m → 0 < n →
        ∀ (Z : Ω → Fin n → ℝ) (X : Fin m → Ω → Fin n → ℝ)
          (K : ℝ≥0),
        1 ≤ K →
        (∀ j, Measurable (fun ω ↦ Z ω j)) →
        (∀ j, MemLp (fun ω ↦ Z ω j) 2 μ) →
        (∀ i j, Measurable (fun ω ↦ X i ω j)) →
        (∀ i, IdentDistrib (X i) Z μ μ) →
        iIndepFun X μ →
        NumStability.HDP.Vector.SubGaussian.SatisfiesPsiTwoL2Bound μ
          (fun j ω ↦ Z ω j) K →
        (∫ ω, NumStability.realMatrixOperatorNorm
          (NumStability.HDP.Vector.Covariance.randomSampleCovariance X ω -
            NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
              (fun j ω ↦ Z ω j)) ∂μ) ≤
          C * (K : ℝ) ^ 2 *
            (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) *
            NumStability.realMatrixOperatorNorm
              (NumStability.HDP.Vector.Covariance.secondMomentMatrix μ
                (fun j ω ↦ Z ω j)) := by
  rcases
      NumStability.HDP.Vector.Covariance.exists_expected_sampleCovariance_error_bound_of_iid with
    ⟨C, hC, hbound⟩
  exact ⟨C, hC, hbound⟩

/-- The covariance estimate with explicit probability normalization, full
vector laws and joint row-event independence, finite ordinary second moments,
and literal coordinate operator norms. The ambient dimension may be zero. -/
theorem hdp_04_theorem_4_7_1_explicit_probability :
    ∃ C : ℝ, 0 < C ∧
      ∀ {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {m n : ℕ},
        μ Set.univ = 1 → 0 < m →
        ∀ (Z : Ω → Fin n → ℝ) (X : Fin m → Ω → Fin n → ℝ) (K : ℝ≥0),
        1 ≤ K →
        (∀ j, Measurable (fun ω ↦ Z ω j)) →
        (∀ j, Integrable (fun ω ↦ Z ω j ^ 2) μ) →
        (∀ i j, Measurable (fun ω ↦ X i ω j)) →
        (∀ i, AEMeasurable (X i) μ ∧ AEMeasurable Z μ ∧
          Measure.map (X i) μ = Measure.map Z μ) →
        (∀ (S : Finset (Fin m)) (B : Fin m → Set (Fin n → ℝ)),
          (∀ i, i ∈ S → MeasurableSet (B i)) →
          μ (⋂ i ∈ S, (X i) ⁻¹' B i) = ∏ i ∈ S, μ ((X i) ⁻¹' B i)) →
        (∀ x : Fin n → ℝ,
          NumStability.HDP.Scalar.SubGaussian.PsiTwoNorm μ
            (fun ω ↦ ∑ j, Z ω j * x j) ≤
              (K : ℝ≥0∞) * ENNReal.ofReal
                (Real.sqrt (∫ ω, (∑ j, Z ω j * x j) ^ 2 ∂μ))) →
        (∫ ω, sSup {q : ℝ | ∃ x : Fin n → ℝ, (∑ j, x j ^ 2) = 1 ∧
          q = Real.sqrt (∑ a, (∑ b,
            ((m : ℝ)⁻¹ * ∑ i, X i ω a * X i ω b -
              ∫ η, Z η a * Z η b ∂μ) * x b) ^ 2)} ∂μ) ≤
          C * (K : ℝ) ^ 2 *
            (Real.sqrt ((n : ℝ) / (m : ℝ)) + (n : ℝ) / (m : ℝ)) *
            sSup {q : ℝ | ∃ x : Fin n → ℝ, (∑ j, x j ^ 2) = 1 ∧
              q = Real.sqrt (∑ a, (∑ b, (∫ ω, Z ω a * Z ω b ∂μ) * x b) ^ 2)} := by
  obtain ⟨C, hC, hbound⟩ :=
    NumStability.HDP.Vector.Covariance.exists_expected_sampleCovariance_error_bound_of_iid_all_dimensions
  refine ⟨C, hC, ?_⟩
  intro Ω instΩ μ m n hμ hm Z X K hK hZMeas hZSq hXMeas hLaw hEvents hMarginal
  letI : IsProbabilityMeasure μ := isProbabilityMeasure_iff.mpr hμ
  have hZLp : ∀ j, MemLp (fun ω ↦ Z ω j) 2 μ := fun j ↦
    (memLp_two_iff_integrable_sq (hZMeas j).aestronglyMeasurable).mpr (hZSq j)
  have hIdent : ∀ i, IdentDistrib (X i) Z μ μ :=
    fun i ↦ ⟨(hLaw i).1, (hLaw i).2.1, (hLaw i).2.2⟩
  have hIndep : iIndepFun X μ :=
    iIndepFun_iff_measure_inter_preimage_eq_mul.mpr (fun S {B} hS ↦ hEvents S B hS)
  have hRel :=
    (NumStability.HDP.Vector.SubGaussian.satisfiesPsiTwoL2Bound_iff_secondMoment
      hZMeas hZSq).mpr hMarginal
  simpa only [NumStability.realMatrixOperatorNorm_eq_coordinate_sSup,
    NumStability.HDP.Vector.Covariance.randomSampleCovariance,
    NumStability.HDP.Vector.Covariance.sampleCovariance,
    NumStability.HDP.Vector.Covariance.secondMomentMatrix, Matrix.sub_apply] using
      hbound hm Z X K hK hZMeas hZLp hXMeas hIdent hIndep hRel

end NumStability.HDP.Contract
