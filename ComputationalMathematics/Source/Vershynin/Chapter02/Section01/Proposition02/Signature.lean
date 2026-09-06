import ComputationalMathematics.HDP.Scalar.LimitTheorems
/-!
# Frozen contract signature for Proposition 2.1.2

This proof-free signature records the two-sided standard-normal tail estimate.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.LimitTheorems

def hdp_02_hprop_h2_d1_d2__contract_type : Prop :=
  ∀ t : ℝ, 0 < t →
    (Real.sqrt (2 * Real.pi))⁻¹ *
          ((1 / t - 1 / t ^ 3) * Real.exp (-(t ^ 2) / 2)) ≤
        standardNormalLaw.real (Ici t) ∧
      standardNormalLaw.real (Ici t) ≤
        (Real.sqrt (2 * Real.pi))⁻¹ *
          ((1 / t) * Real.exp (-(t ^ 2) / 2))

end NumStability.HDP.Contract
