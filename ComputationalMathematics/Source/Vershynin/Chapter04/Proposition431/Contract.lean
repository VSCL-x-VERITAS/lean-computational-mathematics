import ComputationalMathematics.HDP.Metric.EntropyCoding

/-!
# Vershynin Chapter 4, Proposition 4.3.1
-/

noncomputable section

open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- Vershynin, Proposition 4.3.1, in its exact integer-threshold form.

An `N`-bit code at accuracy `ε` forces the `ε`-covering number to be at
most `2^N`. Conversely, an `ε/2`-cover with at most `2^N` centers produces
an `N`-bit code at accuracy `ε`. Taking the least admissible `N` gives the
source's floor/ceiling metric-entropy inequalities without hiding the
zero/infinite boundary cases in logarithm conventions. -/
theorem hdp_04_proposition_4_3_1
    {T : Type*} [PseudoEMetricSpace T] (K : Set T) (ε : ℝ≥0) (N : ℕ) :
    (NumStability.HDP.Metric.IsMetricCode K ε N →
      Metric.coveringNumber ε K ≤ (2 ^ N : ℕ)) ∧
    (Metric.coveringNumber (ε / 2) K ≤ (2 ^ N : ℕ) →
      NumStability.HDP.Metric.IsMetricCode K ε N) := by
  exact ⟨
    NumStability.HDP.Metric.coveringNumber_le_two_pow_of_isMetricCode,
    NumStability.HDP.Metric.isMetricCode_of_coveringNumber_half_le_two_pow⟩

end NumStability.HDP.Contract
