import ComputationalMathematics.Source.Vershynin.Chapter02.Section01.Proposition02.Signature
import ComputationalMathematics.HDP.Scalar.GaussianTails
/-! Source-facing contract for Proposition 2.1.2. -/

noncomputable section

open MeasureTheory ProbabilityTheory Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.LimitTheorems

/-- Proposition 2.1.2, printed page 13: the two-sided Mills-ratio estimate for
the upper tail of a standard-normal random variable. -/
theorem hdp_02_hprop_h2_d1_d2 (t : ℝ) (ht : 0 < t) :
    (Real.sqrt (2 * Real.pi))⁻¹ *
          ((1 / t - 1 / t ^ 3) * Real.exp (-(t ^ 2) / 2)) ≤
        standardNormalLaw.real (Ici t) ∧
      standardNormalLaw.real (Ici t) ≤
        (Real.sqrt (2 * Real.pi))⁻¹ *
          ((1 / t) * Real.exp (-(t ^ 2) / 2)) :=
  NumStability.HDP.Scalar.GaussianTails.standardNormalTail_bounds t ht

/-- The implementation inhabits the frozen source-facing signature. -/
theorem hdp_02_hprop_h2_d1_d2__contract :
    hdp_02_hprop_h2_d1_d2__contract_type := by
  intro t ht
  exact hdp_02_hprop_h2_d1_d2 t ht

end NumStability.HDP.Contract
