import ComputationalMathematics.HDP.Vector.PrincipalComponents

/-! Frozen contract signature for the ordered principal directions in Section 3.2.1. -/

noncomputable section

open MeasureTheory

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_2_pca_directions__contract_type : Prop :=
  ∀ {n : ℕ} {Ω : Type*} [MeasurableSpace Ω]
    {μ : Measure Ω} [IsProbabilityMeasure μ] (X : Fin n → Ω → ℝ)
    (hX : ∀ i, MemLp (X i) 2 μ),
    Antitone
        (NumStability.HDP.Vector.PrincipalComponents.secondMomentPrincipalEigenvalue μ X hX) ∧
      ∀ i,
        Matrix.mulVec
            (NumStability.HDP.Vector.Covariance.secondMomentMatrix μ X)
            (NumStability.HDP.Vector.PrincipalComponents.secondMomentPrincipalDirection μ X hX i) =
          (NumStability.HDP.Vector.PrincipalComponents.secondMomentPrincipalEigenvalue μ X hX i) •
            (NumStability.HDP.Vector.PrincipalComponents.secondMomentPrincipalDirection μ X hX i) ∧
        ‖NumStability.HDP.Vector.PrincipalComponents.secondMomentPrincipalDirection μ X hX i‖ = 1

end NumStability.HDP.Contract
