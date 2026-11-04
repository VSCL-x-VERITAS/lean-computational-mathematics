import ComputationalMathematics.HDP.Metric.CoveringComparisons

/-!
# Exercise 4.2.9: exterior and internal covering numbers

This proof-free proposition records the positive-radius metric-space comparison
selected by the Chapter 4 source-admission case. The two covering numbers use
extended-natural finite minima, with `⊤` when no finite cover exists. Exterior
centers range over the same ambient metric space as the set being covered.
-/

set_option autoImplicit false

open scoped NNReal

universe u

namespace NumStability.HDP.Contract

/-- Source-facing numerical target for Vershynin, Exercise 4.2.9. -/
def exercise429NumericalTarget : Prop :=
  ∀ (T : Type u) [MetricSpace T] (K : Set T) (ε : ℝ≥0),
    0 < ε →
      Metric.externalCoveringNumber ε K ≤ Metric.coveringNumber ε K ∧
      Metric.coveringNumber ε K ≤ Metric.externalCoveringNumber (ε / 2) K

end NumStability.HDP.Contract
