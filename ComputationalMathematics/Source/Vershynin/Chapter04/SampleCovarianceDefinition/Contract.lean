import ComputationalMathematics.HDP.Vector.CovarianceEstimation

/-!
# Vershynin Chapter 4, sample-covariance definition
-/

noncomputable section

namespace NumStability.HDP.Contract

/-- Vershynin, Section 4.7: the sample covariance is the average of the
sample outer products. -/
theorem hdp_04_sample_covariance_definition {m n : ℕ}
    (X : Fin m → Fin n → ℝ) (a b : Fin n) :
    NumStability.HDP.Vector.Covariance.sampleCovariance X a b =
      (m : ℝ)⁻¹ * ∑ i, X i a * X i b := rfl

end NumStability.HDP.Contract
