import ComputationalMathematics.Source.Vershynin.Chapter03.Equation30.Signature

/-! Display (3.30): the normalized arcsine identity for the two Krivine
feature maps. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_eq_3_30 : hdp_03_eq_3_30__contract_type := by
  intro n u v hu hv
  exact NumStability.HDP.Tensor.krivineFeature_arcsin u v hu hv

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_30__contract : hdp_03_eq_3_30__contract_type :=
  hdp_03_eq_3_30

end NumStability.HDP.Contract
