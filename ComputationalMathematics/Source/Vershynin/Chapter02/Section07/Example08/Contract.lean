import ComputationalMathematics.Source.Vershynin.Chapter02.Section07.Example08.Signature

/-! Stable source-facing wrapper for Example 2.7.8. -/

noncomputable section

namespace NumStability.HDP.Contract

/-- Example 2.7.8: canonical sub-exponential variables and the exact
positive-rate exponential-law scales in the book's normalization. -/
theorem hdp_02_hexample_h2_d7_d8 :
    hdp_02_hexample_h2_d7_d8__contract_type := by
  refine ⟨NumStability.HDP.Scalar.SubGaussian.property_to_subExponentialMoment,
    ?_, ?_, ?_⟩
  · intro Ω _ μ X hX
    exact ⟨
      NumStability.HDP.Scalar.SubExponential.psiOneGauge_sq_lt_top_iff hX,
      NumStability.HDP.Scalar.SubExponential.psiOneGauge_sq_eq_psiTwoGauge_sq hX⟩
  · intro lambda hlambda
    exact ⟨
      NumStability.HDP.Scalar.SubExponentialExamples.integral_id_expMeasure hlambda,
      NumStability.HDP.Scalar.SubExponentialExamples.variance_id_expMeasure hlambda,
      NumStability.HDP.Scalar.SubExponentialExamples.psiOneGauge_id_expMeasure hlambda⟩
  · exact
      NumStability.HDP.Scalar.SubExponentialExamples.psiOneGauge_id_poissonRealLaw_lt_top

/-- Mechanical receipt that the checked wrapper inhabits the frozen target. -/
theorem hdp_02_hexample_h2_d7_d8__contract :
    hdp_02_hexample_h2_d7_d8__contract_type :=
  hdp_02_hexample_h2_d7_d8

end NumStability.HDP.Contract
