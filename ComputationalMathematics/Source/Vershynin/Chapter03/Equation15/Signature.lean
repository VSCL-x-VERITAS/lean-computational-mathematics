import ComputationalMathematics.HDP.Scalar.LimitTheorems

/-! Frozen proof-free signature for display (3.15). -/

noncomputable section

open MeasureTheory ProbabilityTheory Set

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.LimitTheorems

set_option linter.style.nameCheck false in
def hdp_03_eq_3_15__contract_type : Prop :=
  ∀ R : ℝ, 1 ≤ R →
    (∫ x in {x : ℝ | |x| > R}, x ^ 2 ∂standardNormalLaw) ≤
        2 * (R + 1 / R) * (Real.sqrt (2 * Real.pi))⁻¹ *
          Real.exp (-(R ^ 2) / 2) ∧
      2 * (R + 1 / R) * (Real.sqrt (2 * Real.pi))⁻¹ *
          Real.exp (-(R ^ 2) / 2) < 4 / R ^ 2

end NumStability.HDP.Contract
