import ComputationalMathematics.Source.Vershynin.Chapter03.Section03.ConvexWhitening.Signature

/-! Source-facing contract for whitening a uniform convex-body law. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Section 3.3.5, printed page 55: after centering a uniform convex-body
random vector, applying the inverse positive-semidefinite covariance factor
produces a centered isotropic vector. -/
theorem hdp_03_body_3_3_convex_whitening :
    hdp_03_body_3_3_convex_whitening__contract_type := by
  intro n Ω _ μ _ X K S B _ hX hMean hCov _ hSunit hB hBB
  have hBBunit : IsUnit (B * B) := hBB.symm ▸ hSunit
  have hBunit : IsUnit B := isUnit_of_mul_isUnit_left hBBunit
  exact NumStability.HDP.Vector.centered_isotropic_centeredLinearTransform_inverse
    0 B X hX hMean (hCov.trans hBB.symm) hB hBunit

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_3_convex_whitening__contract :
    hdp_03_body_3_3_convex_whitening__contract_type :=
  hdp_03_body_3_3_convex_whitening

end NumStability.HDP.Contract
