import ComputationalMathematics.HDP.Vector.AffineMoments

/-! Frozen signature for Exercise 3.2.2(b), inverse-square-root whitening. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_ex_3_2_2b__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
      {μ : Measure Ω} [IsProbabilityMeasure μ]
      (X : Fin n → Ω → ℝ) (m : Fin n → ℝ)
      (S B : Matrix (Fin n) (Fin n) ℝ),
    (∀ i, MemLp (X i) 2 μ) →
      NumStability.HDP.Vector.Covariance.meanVector μ X = m →
      NumStability.HDP.Vector.Covariance.covarianceMatrix μ X = S →
      S.PosSemidef → IsUnit S → B.PosSemidef → B * B = S →
      NumStability.HDP.Vector.Covariance.meanVector μ
          (NumStability.HDP.Vector.centeredLinearTransform m B⁻¹ X) = 0 ∧
        NumStability.HDP.Vector.Isotropy.IsIsotropic μ
          (NumStability.HDP.Vector.centeredLinearTransform m B⁻¹ X)

end NumStability.HDP.Contract
