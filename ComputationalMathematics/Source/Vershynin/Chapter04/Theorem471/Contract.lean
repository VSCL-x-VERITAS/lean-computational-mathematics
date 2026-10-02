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

end NumStability.HDP.Contract
