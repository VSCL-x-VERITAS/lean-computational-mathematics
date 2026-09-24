import ComputationalMathematics.Source.Vershynin.Chapter03.Section06.MaxCutSDP.Signature

/-! The unit-vector maximum-cut relaxation is equivalent to a correlation-matrix SDP. -/

namespace NumStability.HDP.Contract

theorem hdp_03_body_3_6_maxcut_sdp :
    hdp_03_body_3_6_maxcut_sdp__contract_type := by
  intro n G _
  constructor
  · exact fun X ↦
      NumStability.HDP.Graph.exists_correlationMatrix_value_eq
        (G.adjMatrix ℝ) X
  · exact fun M hM ↦
      NumStability.HDP.Graph.exists_unitVectorFamily_matrixValue_eq
        (G.adjMatrix ℝ) M hM

set_option linter.style.nameCheck false in
theorem hdp_03_body_3_6_maxcut_sdp__contract :
    hdp_03_body_3_6_maxcut_sdp__contract_type :=
  hdp_03_body_3_6_maxcut_sdp

end NumStability.HDP.Contract
