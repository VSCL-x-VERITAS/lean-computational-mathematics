import ComputationalMathematics.HDP.Scalar.IndependentSums.PoissonChernoff

/-! Source-facing Chapter 2 contracts for Exercise 2.3.3 and display (2.8). -/

noncomputable section

open MeasureTheory ProbabilityTheory
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- The Poisson upper-tail estimate stated in Exercise 2.3.3. -/
theorem hdp_02_hex_h2_d3_d3
    (rate : ℝ≥0) {t : ℝ} (ht : (rate : ℝ) < t) :
    (poissonMeasure rate).real {n : ℕ | t ≤ (n : ℝ)} ≤
      Real.exp (-(rate : ℝ)) *
        ((Real.exp 1 * (rate : ℝ) / t) ^ t) :=
  NumStability.HDP.Scalar.IndependentSums.PoissonChernoff.poissonChernoffUpper
    rate ht

/-- Display (2.8), exposed separately at its printed locator. -/
theorem hdp_02_heq_h2_d8
    (rate : ℝ≥0) {t : ℝ} (ht : (rate : ℝ) < t) :
    (poissonMeasure rate).real {n : ℕ | t ≤ (n : ℝ)} ≤
      Real.exp (-(rate : ℝ)) *
        ((Real.exp 1 * (rate : ℝ) / t) ^ t) :=
  hdp_02_hex_h2_d3_d3 rate ht

end NumStability.HDP.Contract
