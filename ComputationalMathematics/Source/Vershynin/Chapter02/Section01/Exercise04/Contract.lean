import ComputationalMathematics.Source.Vershynin.Chapter02.Section01.Exercise04.Signature
import ComputationalMathematics.HDP.Scalar.GaussianTails

/-! Source-facing contract for Exercise 2.1.4. -/

noncomputable section

open MeasureTheory ProbabilityTheory Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

open NumStability.HDP.Scalar.LimitTheorems

/-- Exercise 2.1.4, printed page 15: the exact standard-normal truncated
second-moment identity and its bound obtained from Proposition 2.1.2. -/
theorem hdp_02_hex_h2_d1_d4 (t : ℝ) (ht : 1 ≤ t) :
    (∫ x in Ioi t, x ^ 2 ∂standardNormalLaw) =
        t * (Real.sqrt (2 * Real.pi))⁻¹ * Real.exp (-(t ^ 2) / 2) +
          standardNormalLaw.real (Ici t) ∧
      (∫ x in Ioi t, x ^ 2 ∂standardNormalLaw) ≤
        (t + 1 / t) * (Real.sqrt (2 * Real.pi))⁻¹ *
          Real.exp (-(t ^ 2) / 2) :=
  NumStability.HDP.Scalar.GaussianTails.standardNormal_truncatedSecondMoment t ht

/-- The implementation inhabits the frozen source-facing signature. -/
theorem hdp_02_hex_h2_d1_d4__contract :
    hdp_02_hex_h2_d1_d4__contract_type := by
  intro t ht
  exact hdp_02_hex_h2_d1_d4 t ht

end NumStability.HDP.Contract
