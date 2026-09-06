import ComputationalMathematics.Source.Vershynin.Chapter02.Equation03.Signature
import ComputationalMathematics.HDP.Scalar.GaussianTails

/-! Source-facing contract for Equation (2.3). -/

noncomputable section

open MeasureTheory ProbabilityTheory Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.LimitTheorems

/-- Equation (2.3), printed page 13: for `t ≥ 1`, the standard-normal upper
tail is bounded by the standard-normal density at `t`. -/
theorem hdp_02_heq_h2_d3 (t : ℝ) (ht : 1 ≤ t) :
    standardNormalLaw.real (Ici t) ≤
      (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-(t ^ 2) / 2) :=
  NumStability.HDP.Scalar.GaussianTails.standardNormalTail_le_density t ht

/-- The implementation inhabits the frozen source-facing signature. -/
theorem hdp_02_heq_h2_d3__contract : hdp_02_heq_h2_d3__contract_type := by
  intro t ht
  exact hdp_02_heq_h2_d3 t ht

end NumStability.HDP.Contract
