import ComputationalMathematics.HDP.Vector.Covariance

/-!
# Vershynin Chapter 4, covariance-matrix definition
-/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

/-- Vershynin, Section 4.7: for a centered vector the covariance is its
second-moment matrix; without centering it is the expected centered outer
product. -/
theorem hdp_04_covariance_matrix_definition
    {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Fin n → Ω → ℝ) (hX : ∀ i, MemLp (X i) 2 μ) :
    NumStability.HDP.Vector.Covariance.covarianceMatrix μ X =
        (fun i j => ∫ ω,
          (X i ω - ∫ ω, X i ω ∂μ) * (X j ω - ∫ ω, X j ω ∂μ) ∂μ) ∧
      (NumStability.HDP.Vector.Covariance.meanVector μ X = 0 →
        NumStability.HDP.Vector.Covariance.covarianceMatrix μ X =
          NumStability.HDP.Vector.Covariance.secondMomentMatrix μ X) := by
  constructor
  · exact NumStability.HDP.Vector.Covariance.covarianceMatrix_eq_centeredOuter μ X
  · exact NumStability.HDP.Vector.Covariance.covarianceMatrix_eq_secondMomentMatrix X hX

end NumStability.HDP.Contract
