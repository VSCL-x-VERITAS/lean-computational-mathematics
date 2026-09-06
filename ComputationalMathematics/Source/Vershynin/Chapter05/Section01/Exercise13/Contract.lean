import ComputationalMathematics.Source.Vershynin.Chapter05.Section01.Exercise13.Signature
import ComputationalMathematics.HDP.Concentration.MetricMeasure

/-! Stable Chapter 5 forwarding theorem for Exercise 5.1.13. -/

noncomputable section

open MeasureTheory
open Set
open scoped ENNReal

namespace NumStability.HDP.Contract

theorem hdp_05_hex_h5_d1_d13__contract :
    hdp_05_hex_h5_d1_d13__contract_type := by
  intro Ω instΩ μ instμ Z m hZ hm i K hK hProp
  exact NumStability.HDP.Contract.hdp_05_hex_h5_d1_d13 hZ hm hK hProp

end NumStability.HDP.Contract
