import ComputationalMathematics.HDP.Metric.CoveringNumber

/-!
# Vershynin, Chapter 4, Remark 4.2.3

Source-correspondence wrapper for the covering-number characterization of
precompact subsets of a complete metric space.
-/

open Set
open scoped ENNReal NNReal Topology

namespace NumStability.HDP.Contract

/-- Vershynin, *High-Dimensional Probability*, Remark 4.2.3: in a complete
metric space, `K` is precompact precisely when its internal covering number is
finite at every positive radius. -/
theorem hdp_04_hremark_h4_d2_d3 {T : Type*} [MetricSpace T] [CompleteSpace T]
    {K : Set T} :
    IsCompact (closure K) ↔
      ∀ ε : ℝ≥0, 0 < ε → Metric.coveringNumber ε K < ⊤ :=
  NumStability.HDP.Metric.isCompact_closure_iff_coveringNumber_lt_top

end NumStability.HDP.Contract
