import ComputationalMathematics.Source.Vershynin.Chapter03.Section04.Remark08.Signature

/-! Remark 3.4.8: one-dimensional marginals of the uniform law on
`√n Sⁿ⁻¹` converge in distribution to the standard normal law. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_rem_3_4_8 : hdp_03_rem_3_4_8__contract_type :=
  NumStability.HDP.Vector.Spherical.ProjectiveLimit.tendsto_sphericalMarginalProbabilityMeasure

set_option linter.style.nameCheck false in
theorem hdp_03_rem_3_4_8__contract : hdp_03_rem_3_4_8__contract_type :=
  hdp_03_rem_3_4_8

end NumStability.HDP.Contract
