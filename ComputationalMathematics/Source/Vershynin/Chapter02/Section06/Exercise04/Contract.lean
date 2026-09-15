import ComputationalMathematics.Source.Vershynin.Chapter02.Section06.Exercise04.Signature
import ComputationalMathematics.Source.Vershynin.Chapter02.Section02.Theorem06.Contract
import ComputationalMathematics.HDP.Scalar.BoundedHoeffdingFromSubGaussian

/-! Stable source-facing wrapper for Exercise 2.6.4. -/

noncomputable section

open MeasureTheory
open ProbabilityTheory
open scoped BigOperators

namespace NumStability.HDP.Contract

/-- Exercise 2.6.4 in the literal no-prefactor form of Theorem 2.2.6.  The
separate `BoundedHoeffdingFromSubGaussian` module records the immediate
two-sided deduction from Theorem 2.6.3; it necessarily retains a leading `2`,
so this checked source wrapper reuses the already established theorem. -/
theorem hdp_02_hex_h2_d6_d4 :
    hdp_02_hex_h2_d6_d4__contract_type := by
  refine ⟨2, by norm_num, ?_⟩
  intro ι Ω _ _ μ _ X m M t hX hIndep hbound ht
  convert hdp_02_hthm_h2_d2_d6_source hX hIndep hbound ht using 1 <;> ring

/-- Mechanical receipt that the checked wrapper inhabits the frozen target. -/
theorem hdp_02_hex_h2_d6_d4__contract :
    hdp_02_hex_h2_d6_d4__contract_type :=
  hdp_02_hex_h2_d6_d4

end NumStability.HDP.Contract
