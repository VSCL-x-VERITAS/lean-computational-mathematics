import ComputationalMathematics.HDP.Metric.CardinalCovering

/-!
# Vershynin, Chapter 4, Definition 4.2.2

Source-correspondence wrapper for exact-cardinal internal covering numbers. The
public contract retains distinct infinite cardinalities as well as finite ones.
-/

open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- Vershynin, *High-Dimensional Probability*, Definition 4.2.2: the covering
number is the least cardinality of an internal epsilon-net, equivalently the
least cardinality of a family of closed epsilon-balls centered in the set and
covering it. -/
theorem hdp_04_hdef_h4_d2_d2 {T : Type*} [MetricSpace T]
    {K : Set T} {ε : ℝ≥0} (_hε : 0 < ε) :
    (NumStability.HDP.Metric.internalCoveringCardinal ε K =
      sInf {c : Cardinal | ∃ N : Set T, N ⊆ K ∧
        (∀ x ∈ K, ∃ x₀ ∈ N, dist x x₀ ≤ (ε : ℝ)) ∧
        c = Cardinal.mk N}) ∧
    (NumStability.HDP.Metric.internalCoveringCardinal ε K =
      sInf {c : Cardinal | ∃ N : Set T, N ⊆ K ∧
        K ⊆ ⋃ y ∈ N, Metric.closedBall y (ε : ℝ) ∧
        c = Cardinal.mk N}) := by
  constructor
  · rfl
  · exact NumStability.HDP.Metric.internalCoveringCardinal_eq_sInf_closedBall ε K

end NumStability.HDP.Contract
