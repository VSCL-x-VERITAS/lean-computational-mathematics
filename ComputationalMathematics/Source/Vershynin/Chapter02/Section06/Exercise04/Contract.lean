import ComputationalMathematics.Source.Vershynin.Chapter02.Section06.Exercise04.Signature
import ComputationalMathematics.HDP.Scalar.BoundedHoeffdingFromSubGaussian

/-! Stable source-facing wrapper for Exercise 2.6.4. -/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.BoundedHoeffdingFromSubGaussian

/-- Exercise 2.6.4: Hoeffding's inequality follows from the weighted
sub-Gaussian tail theorem, with the explicit exponent constant `1/4`. -/
theorem hdp_02_hex_h2_d6_d4 :
    hdp_02_hex_h2_d6_d4__contract_type := by
  refine ⟨1 / 4, by norm_num, ?_⟩
  intro ι Ω _ _ μ _ X m M t hX hIndep hbound ht hWidth
  have h := boundedIndependentHoeffdingFromSubGaussian
    hX hIndep hbound ht.le hWidth
  convert h using 1 <;> ring

/-- Mechanical receipt that the checked wrapper inhabits the frozen target. -/
theorem hdp_02_hex_h2_d6_d4__contract :
    hdp_02_hex_h2_d6_d4__contract_type :=
  hdp_02_hex_h2_d6_d4

end NumStability.HDP.Contract
