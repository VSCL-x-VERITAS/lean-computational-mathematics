import ComputationalMathematics.HDP.Vector.GaussianAffine

/-! Frozen contract signature for the general multivariate normal definition in Section 3.3.2. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_3_general_normal_def__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ]
    (X : Fin n → Ω → ℝ) (m : Fin n → ℝ)
    (S B : Matrix (Fin n) (Fin n) ℝ),
      S.PosSemidef → IsUnit S → B.PosSemidef → B * B = S →
      ((NumStability.HDP.Vector.Gaussian.HasAffineStandardNormalLaw μ X m B ↔
          HasLaw
            (fun ω => NumStability.HDP.Vector.Gaussian.standardizeAffineMap
              m B (fun i => X i ω))
            (NumStability.standardGaussianVectorMeasure n) μ) ∧
        (NumStability.HDP.Vector.Gaussian.HasAffineStandardNormalLaw μ X m B →
          NumStability.HDP.Vector.Covariance.meanVector μ X = m ∧
          NumStability.HDP.Vector.Covariance.covarianceMatrix μ X = S))

end NumStability.HDP.Contract
