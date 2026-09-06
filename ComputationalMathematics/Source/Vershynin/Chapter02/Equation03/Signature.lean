import ComputationalMathematics.HDP.Scalar.LimitTheorems
/-!
# Frozen contract signature for Equation (2.3)

This proof-free signature records the standard-normal density upper bound.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.LimitTheorems

def hdp_02_heq_h2_d3__contract_type : Prop :=
  ∀ t : ℝ, 1 ≤ t →
    standardNormalLaw.real (Ici t) ≤
      (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-(t ^ 2) / 2)

end NumStability.HDP.Contract
