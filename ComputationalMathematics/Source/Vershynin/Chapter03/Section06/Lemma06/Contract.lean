import ComputationalMathematics.Source.Vershynin.Chapter03.Section06.Lemma06.Signature

/-! Lemma 3.6.6: Grothendieck's Gaussian sign-correlation identity. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_03_lem_3_6_6 : hdp_03_lem_3_6_6__contract_type := by
  intro n u v hu hv
  exact NumStability.HDP.Graph.grothendieckSignCorrelation u v hu hv

set_option linter.style.nameCheck false in
theorem hdp_03_lem_3_6_6__contract : hdp_03_lem_3_6_6__contract_type :=
  hdp_03_lem_3_6_6

end NumStability.HDP.Contract
