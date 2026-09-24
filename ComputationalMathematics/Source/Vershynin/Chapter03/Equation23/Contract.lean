import ComputationalMathematics.Source.Vershynin.Chapter03.Equation23.Signature

/-! Display (3.23): the adjacency-matrix formula for a labeled graph cut. -/

namespace NumStability.HDP.Contract

theorem hdp_03_eq_3_23 : hdp_03_eq_3_23__contract_type := by
  intro n G _ x
  have hrestricted := NumStability.HDP.Graph.signCutValue_eq_half_sum_opposite G x
  exact ⟨(NumStability.HDP.Graph.signCutValue_eq_cutSize_positiveVertices G x).symm.trans
      hrestricted,
    hrestricted.symm, rfl⟩

set_option linter.style.nameCheck false in
theorem hdp_03_eq_3_23__contract : hdp_03_eq_3_23__contract_type :=
  hdp_03_eq_3_23

end NumStability.HDP.Contract
