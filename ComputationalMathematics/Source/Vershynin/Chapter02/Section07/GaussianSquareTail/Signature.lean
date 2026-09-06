import ComputationalMathematics.HDP.Scalar.LimitTheorems

/-!
# Frozen contract for the Gaussian-square tail display in Section 2.7

The source suppresses the Mills-ratio prefactor.  This proof-free signature
pins a precise stronger form: the displayed event identity plus the exact
two-sided bounds inherited from Proposition 2.1.2.
-/

noncomputable section

open MeasureTheory ProbabilityTheory Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.LimitTheorems

def hdp_02_hbody_h2_d7_hgaussian_hsquare_htail__contract_type : Prop :=
  ∀ t : ℝ, 0 < t →
    standardNormalLaw.real {x : ℝ | x ^ 2 > t} =
        standardNormalLaw.real {x : ℝ | |x| > Real.sqrt t} ∧
      2 * (Real.sqrt (2 * Real.pi))⁻¹ *
            ((1 / Real.sqrt t - 1 / (Real.sqrt t) ^ 3) *
              Real.exp (-t / 2)) ≤
          standardNormalLaw.real {x : ℝ | x ^ 2 > t} ∧
        standardNormalLaw.real {x : ℝ | x ^ 2 > t} ≤
          2 * (Real.sqrt (2 * Real.pi))⁻¹ *
            ((1 / Real.sqrt t) * Real.exp (-t / 2))

end NumStability.HDP.Contract
