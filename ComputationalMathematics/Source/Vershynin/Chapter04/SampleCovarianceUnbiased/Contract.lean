import ComputationalMathematics.HDP.Vector.CovarianceEstimation

/-!
# Vershynin Chapter 4, unbiased sample covariance
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

/-- Vershynin, Section 4.7: the empirical second-moment matrix of identically
distributed samples is an unbiased estimator of the population second-moment
matrix. Integrability states the finite-expectation convention explicitly. -/
theorem hdp_04_sample_covariance_unbiased
    {Ω : Type*} [MeasurableSpace Ω] {μ : Measure Ω} {m n : ℕ}
    (hm : 0 < m) (X : Fin m → Ω → Fin n → ℝ) (Z : Ω → Fin n → ℝ)
    (hident : ∀ i, IdentDistrib (X i) Z μ μ)
    (hint : ∀ i a b, Integrable (fun ω ↦ X i ω a * X i ω b) μ)
    (a b : Fin n) :
    (∫ ω, NumStability.HDP.Vector.Covariance.randomSampleCovariance X ω a b ∂μ) =
      NumStability.HDP.Vector.Covariance.secondMomentMatrix
        μ (fun i ω ↦ Z ω i) a b :=
  NumStability.HDP.Vector.Covariance.integral_randomSampleCovariance_eq_secondMomentMatrix
    hm X Z hident hint a b

end NumStability.HDP.Contract
