import ComputationalMathematics.Source.Vershynin.Chapter02.Section03.Exercise08.Signature

/-!
# Exercise 2.3.8: Poisson normal approximation

The standardized real Poisson laws converge weakly to the standard normal law
as the rate tends to infinity.
-/

noncomputable section

open MeasureTheory Filter
open scoped Topology NNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.LimitTheorems
open NumStability.HDP.Scalar.PoissonNormal

/-- Exercise 2.3.8, printed page 20. -/
theorem hdp_02_hex_h2_d3_d8 :
    Tendsto standardizedPoissonLaw atTop
      (𝓝 (⟨standardNormalLaw, inferInstance⟩ : ProbabilityMeasure ℝ)) :=
  tendsto_standardizedPoissonLaw

/-- The implementation inhabits the frozen source-facing signature. -/
theorem hdp_02_hex_h2_d3_d8__contract :
    hdp_02_hex_h2_d3_d8__contract_type :=
  hdp_02_hex_h2_d3_d8

end NumStability.HDP.Contract
