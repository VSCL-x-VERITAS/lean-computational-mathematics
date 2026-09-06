import ComputationalMathematics.HDP.Scalar.LimitTheorems.Basic

/-! Stable source-facing contract for the Chapter 1 Poisson-law definition. -/

noncomputable section

open MeasureTheory
open scoped NNReal

namespace NumStability.HDP.Contract

/-- Stable source-facing alias for the local Poisson law interface. -/
noncomputable def hdp_01_hdef_hpoisson (rate : ℝ≥0) : Measure ℕ :=
  NumStability.HDP.Scalar.LimitTheorems.poissonLaw rate

/-- Equation (1.8): the point mass of the Poisson law with rate `rate`. -/
theorem hdp_01_heq_h1_d8 (rate : ℝ≥0) (k : ℕ) :
    hdp_01_hdef_hpoisson rate {k} =
      ENNReal.ofReal
        (Real.exp (-(rate : ℝ)) * (rate : ℝ) ^ k / Nat.factorial k) := by
  exact NumStability.HDP.Scalar.LimitTheorems.poissonLaw_mass rate k

end NumStability.HDP.Contract
