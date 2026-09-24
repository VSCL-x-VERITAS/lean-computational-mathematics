import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.GeneralNormal.Signature

/-! Source-facing contract for the general multivariate normal definition in Section 3.3.2. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Section 3.3.2, printed page 50: for an invertible positive-semidefinite
covariance matrix `S` with positive-semidefinite square root `B`, a vector has
the affine normal law `m + BZ` exactly when applying `B⁻¹` after centering
produces the standard normal law; moreover, that affine law has mean `m` and
covariance `S`. -/
theorem hdp_03_body_3_3_general_normal_def :
    hdp_03_body_3_3_general_normal_def__contract_type := by
  intro n Ω _ μ _ X m S B _ hSunit hBpos hBB
  have hBBunit : IsUnit (B * B) := hBB.symm ▸ hSunit
  have hBunit : IsUnit B := isUnit_of_mul_isUnit_left hBBunit
  refine ⟨
    NumStability.HDP.Vector.Gaussian.hasAffineStandardNormalLaw_iff_standardized
      hBunit, ?_⟩
  intro hX
  refine ⟨
    NumStability.HDP.Vector.Gaussian.meanVector_eq_of_hasAffineStandardNormalLaw hX,
    ?_⟩
  rw [NumStability.HDP.Vector.Gaussian.covarianceMatrix_eq_mul_transpose_of_hasAffineStandardNormalLaw
    hX]
  have hBtranspose : B.transpose = B := by
    simpa [Matrix.conjTranspose_eq_transpose_of_trivial] using hBpos.1
  rw [hBtranspose, hBB]

set_option linter.style.nameCheck false in
/-- The implementation inhabits the frozen Section 3.3.2 general-normal signature. -/
theorem hdp_03_body_3_3_general_normal_def__contract :
    hdp_03_body_3_3_general_normal_def__contract_type :=
  hdp_03_body_3_3_general_normal_def

end NumStability.HDP.Contract
