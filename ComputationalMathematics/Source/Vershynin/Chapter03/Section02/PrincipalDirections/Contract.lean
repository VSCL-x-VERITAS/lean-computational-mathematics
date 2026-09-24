import ComputationalMathematics.Source.Vershynin.Chapter03.Section02.PrincipalDirections.Signature

/-! Source-facing contract for ordered principal directions in Section 3.2.1. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Section 3.2.1, printed pages 45-46: principal directions are unit
eigenvectors indexed by decreasing eigenvalue rank. -/
theorem hdp_03_body_3_2_pca_directions :
    hdp_03_body_3_2_pca_directions__contract_type := by
  intro n Ω _ μ _ X hX
  constructor
  · exact
      NumStability.HDP.Vector.PrincipalComponents.secondMomentPrincipalEigenvalue_antitone μ X hX
  · intro i
    exact ⟨
      NumStability.HDP.Vector.PrincipalComponents.secondMomentMatrix_mulVec_principalDirection
        μ X hX i,
      NumStability.HDP.Vector.PrincipalComponents.norm_secondMomentPrincipalDirection
        μ X hX i⟩

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen principal-direction signature. -/
theorem hdp_03_body_3_2_pca_directions__contract :
    hdp_03_body_3_2_pca_directions__contract_type :=
  hdp_03_body_3_2_pca_directions

end NumStability.HDP.Contract
