import ComputationalMathematics.HDP.Convex.Uniform
import ComputationalMathematics.HDP.Vector.AffineMoments

/-! Frozen signature for whitening a uniform convex-body law in Section 3.3.5. -/

noncomputable section

open MeasureTheory ProbabilityTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_3_convex_whitening__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
      {μ : Measure Ω} [IsProbabilityMeasure μ]
      (X : Fin n → Ω → ℝ) (K : Set (Fin n → ℝ))
      (S B : Matrix (Fin n) (Fin n) ℝ),
    NumStability.HDP.Convex.HasUniformConvexBodyLaw μ X K →
      (∀ i, MemLp (X i) 2 μ) →
      NumStability.HDP.Vector.Covariance.meanVector μ X = 0 →
      NumStability.HDP.Vector.Covariance.covarianceMatrix μ X = S →
      S.PosSemidef → IsUnit S → B.PosSemidef → B * B = S →
      NumStability.HDP.Vector.Covariance.meanVector μ
          (NumStability.HDP.Vector.centeredLinearTransform 0 B⁻¹ X) = 0 ∧
        NumStability.HDP.Vector.Isotropy.IsIsotropic μ
          (NumStability.HDP.Vector.centeredLinearTransform 0 B⁻¹ X)

end NumStability.HDP.Contract
