import ComputationalMathematics.HDP.Scalar.LimitTheorems

/-!
# Frozen contract signature for Exercise 2.1.4

This proof-free signature records the standard-normal truncated second-moment
identity and its printed upper bound.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.LimitTheorems

def hdp_02_hex_h2_d1_d4__contract_type : Prop :=
  ∀ t : ℝ, 1 ≤ t →
    (∫ x in Ioi t, x ^ 2 ∂standardNormalLaw) =
        t * (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-(t ^ 2) / 2) +
          standardNormalLaw.real (Ici t) ∧
      (∫ x in Ioi t, x ^ 2 ∂standardNormalLaw) ≤
        (t + 1 / t) * (Real.sqrt (2 * Real.pi))⁻¹ *
          Real.exp (-(t ^ 2) / 2)

end NumStability.HDP.Contract
