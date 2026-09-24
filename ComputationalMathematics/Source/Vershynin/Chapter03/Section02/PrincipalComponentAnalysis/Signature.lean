import ComputationalMathematics.HDP.Vector.PrincipalComponents

/-! Frozen contract signature for the PCA projection algorithm in Section 3.2.1. -/

noncomputable section

namespace NumStability.HDP.Contract

set_option linter.style.nameCheck false in
def hdp_03_body_3_2_pca__contract_type : Prop :=
  ∀ {Ω : Type*} [MeasurableSpace Ω] {n : ℕ}
    (μ : MeasureTheory.Measure Ω) (X : Fin n → Ω → ℝ)
    (hX : ∀ i, MeasureTheory.MemLp (X i) 2 μ)
    (k : ℕ) (_hk0 : 0 < k) (hk : k < n),
    let hM := NumStability.HDP.Vector.Covariance.secondMomentMatrix_posSemidef X hX
    Antitone
        (NumStability.HDP.Vector.PrincipalComponents.secondMomentPrincipalEigenvalue μ X hX) ∧
      (∀ i,
        Matrix.mulVec (NumStability.HDP.Vector.Covariance.secondMomentMatrix μ X)
            (NumStability.HDP.Vector.PrincipalComponents.secondMomentPrincipalDirection μ X hX i) =
          (NumStability.HDP.Vector.PrincipalComponents.secondMomentPrincipalEigenvalue μ X hX i) •
            (NumStability.HDP.Vector.PrincipalComponents.secondMomentPrincipalDirection μ X hX i)) ∧
      ∀ ω,
        let x : EuclideanSpace ℝ (Fin n) := WithLp.toLp 2 (fun i => X i ω)
        NumStability.HDP.Vector.PrincipalComponents.principalProjection hM k hk.le x ∈
            NumStability.HDP.Vector.PrincipalComponents.principalSubspace hM k hk.le ∧
          x - NumStability.HDP.Vector.PrincipalComponents.principalProjection hM k hk.le x ∈
            (NumStability.HDP.Vector.PrincipalComponents.principalSubspace hM k hk.le)ᗮ

end NumStability.HDP.Contract
