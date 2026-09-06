import ComputationalMathematics.HDP.Scalar.PoissonLimit

/-!
# Contract: HDP Theorem 1.3.4

The source's Poisson limit theorem for a triangular array of independent
Bernoulli variables.  The canonical product PMF below packages precisely the
joint law of each independent row, so the statement is expressed directly as
weak convergence of the row-sum laws.
-/

noncomputable section

namespace NumStability.HDP.Contract

open Filter MeasureTheory
open scoped Topology NNReal

/-- Theorem 1.3.4 (Poisson Limit Theorem): if the largest Bernoulli parameter
in a row tends to zero and the row sums of parameters tend to `rate`, then the
laws of the independent Bernoulli row sums converge to `Poisson(rate)`. -/
theorem hdp_01_hthm_h1_d3_d4
    (p : (N : ℕ) → Fin (N + 1) → ℝ≥0)
    (hp : ∀ N i, p N i ≤ 1) (rate : ℝ≥0)
    (hmax : Tendsto
      (fun N =>
        (NumStability.HDP.Scalar.LimitTheorems.poissonRowMax p N : ℝ))
      atTop (𝓝 0))
    (hsum : Tendsto
      (NumStability.HDP.Scalar.LimitTheorems.poissonRowSum p)
      atTop (𝓝 (rate : ℝ))) :
    Tendsto
      (NumStability.HDP.Scalar.LimitTheorems.poissonBernoulliRowProbabilityMeasure
        p hp)
      atTop
      (𝓝 (NumStability.HDP.Scalar.LimitTheorems.poissonRealProbabilityMeasure
        rate)) :=
  NumStability.HDP.Scalar.LimitTheorems.tendsto_poissonBernoulliRowProbabilityMeasure
    p hp rate hmax hsum

end NumStability.HDP.Contract
