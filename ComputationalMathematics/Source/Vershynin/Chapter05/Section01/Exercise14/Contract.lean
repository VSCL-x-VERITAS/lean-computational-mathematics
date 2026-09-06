import ComputationalMathematics.Source.Vershynin.Chapter05.Section01.Exercise14.Signature
import ComputationalMathematics.HDP.Concentration.MetricMeasure

/-! Stable Chapter 5 forwarding theorem for Exercise 5.1.14. -/

noncomputable section

namespace NumStability.HDP.Contract

theorem hdp_05_hex_h5_d1_d14__contract :
    hdp_05_hex_h5_d1_d14__contract_type := by
  intro Ω instΩ instMetric instBorel μ instμ A hAclosed hAnonempty K hK hYint
    hFunctional hAprob
  exact NumStability.HDP.Contract.hdp_05_hex_h5_d1_d14
    hAclosed hAnonempty hK hYint hFunctional hAprob

end NumStability.HDP.Contract
