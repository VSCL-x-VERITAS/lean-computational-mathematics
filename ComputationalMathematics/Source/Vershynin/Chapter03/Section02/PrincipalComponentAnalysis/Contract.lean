import ComputationalMathematics.Source.Vershynin.Chapter03.Section02.PrincipalComponentAnalysis.Signature

/-! Source-facing contract for PCA in Section 3.2.1. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Section 3.2.1, printed pages 45--46: PCA orders the eigenvectors of the
second-moment matrix by decreasing eigenvalue, retains the first `k`, and
projects every data realization onto their span. -/
theorem hdp_03_body_3_2_pca : hdp_03_body_3_2_pca__contract_type := by
  intro Ω _ n μ X hX k _hk0 hk
  let hM := NumStability.HDP.Vector.Covariance.secondMomentMatrix_posSemidef X hX
  refine ⟨
    NumStability.HDP.Vector.PrincipalComponents.secondMomentPrincipalEigenvalue_antitone μ X hX,
    ?_, ?_⟩
  · intro i
    exact
      NumStability.HDP.Vector.PrincipalComponents.secondMomentMatrix_mulVec_principalDirection
        μ X hX i
  · intro ω
    let x : EuclideanSpace ℝ (Fin n) := WithLp.toLp 2 (fun i => X i ω)
    exact ⟨
      NumStability.HDP.Vector.PrincipalComponents.principalProjection_mem hM k hk.le x,
      NumStability.HDP.Vector.PrincipalComponents.sub_principalProjection_mem_orthogonal
        hM k hk.le x⟩

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen PCA projection signature. -/
theorem hdp_03_body_3_2_pca__contract : hdp_03_body_3_2_pca__contract_type :=
  hdp_03_body_3_2_pca

end NumStability.HDP.Contract
