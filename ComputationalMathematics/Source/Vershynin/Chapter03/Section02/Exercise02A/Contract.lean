import ComputationalMathematics.Source.Vershynin.Chapter03.Section02.Exercise02A.Signature

/-! Source-facing contract for Exercise 3.2.2(a). -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Exercise 3.2.2(a), printed page 47: applying the affine map `m + BZ`
to a centered isotropic vector gives mean `m` and covariance `S` when the
positive-semidefinite factor `B` squares to `S`. -/
theorem hdp_03_ex_3_2_2a : hdp_03_ex_3_2_2a__contract_type := by
  intro n Ω _ μ _ Z m S B hZ hMean hIso _ hB hBB
  have h := NumStability.HDP.Vector.mean_covariance_affineTransform_of_centered_isotropic
    m B Z hZ hMean hIso hB
  exact ⟨h.1, h.2.trans hBB⟩

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_2_2a__contract : hdp_03_ex_3_2_2a__contract_type :=
  hdp_03_ex_3_2_2a

end NumStability.HDP.Contract
