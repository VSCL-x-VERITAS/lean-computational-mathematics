import ComputationalMathematics.Source.Vershynin.Chapter03.Section04.Exercise05.Signature

/-! Exercise 3.4.5: bounded `ψ₂` norm forces exponential support size. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- An isotropic random vector with a fixed vector `ψ₂` bound and exact
finite support has exponentially many support points in high dimension. -/
theorem hdp_03_ex_3_4_5 : hdp_03_ex_3_4_5__contract_type := by
  intro K hK
  rcases NumStability.HDP.Vector.FiniteSupport.exists_exponential_support_lower_bound K hK with
    ⟨c, hc, hbound⟩
  refine ⟨c, 2 * K ^ 2 * Real.log 2, hc, by positivity, ?_⟩
  intro N n hN p hp x _hinjective _hpositive hlarge hIso hPsi
  exact hbound hN p hp x hlarge hIso hPsi

set_option linter.style.nameCheck false in
theorem hdp_03_ex_3_4_5__contract : hdp_03_ex_3_4_5__contract_type :=
  hdp_03_ex_3_4_5

end NumStability.HDP.Contract
