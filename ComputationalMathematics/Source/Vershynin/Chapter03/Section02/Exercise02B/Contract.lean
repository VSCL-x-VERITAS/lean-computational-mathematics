import ComputationalMathematics.Source.Vershynin.Chapter03.Section02.Exercise02B.Signature

/-! Source-facing contract for Exercise 3.2.2(b). -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Exercise 3.2.2(b), printed page 47: subtracting the mean and applying the
inverse positive-semidefinite square root of an invertible covariance matrix
produces a centered isotropic random vector. -/
theorem hdp_03_ex_3_2_2b : hdp_03_ex_3_2_2b__contract_type := by
  intro n Ω _ μ _ X m S B hX hMean hCov _ hSunit hB hBB
  have hBBunit : IsUnit (B * B) := hBB.symm ▸ hSunit
  have hBunit : IsUnit B := isUnit_of_mul_isUnit_left hBBunit
  exact NumStability.HDP.Vector.centered_isotropic_centeredLinearTransform_inverse
    m B X hX hMean (hCov.trans hBB.symm) hB hBunit

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_2_2b__contract : hdp_03_ex_3_2_2b__contract_type :=
  hdp_03_ex_3_2_2b

end NumStability.HDP.Contract
