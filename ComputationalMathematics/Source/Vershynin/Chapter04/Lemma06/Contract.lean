import Mathlib.Topology.MetricSpace.Cover

/-!
# Vershynin, Chapter 4, Lemma 4.2.6

Source-correspondence wrapper for the fact that maximal separated subsets are
nets.
-/

open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

/-- Vershynin, *High-Dimensional Probability*, Lemma 4.2.6: every maximal
`ε`-separated subset of `K` is an `ε`-net of `K`. The source's positive
radius can be relaxed to a nonnegative radius, including zero. -/
theorem hdp_04_hlemma_h4_d2_d6 {T : Type*} [MetricSpace T]
    {K N : Set T} {ε : ℝ≥0}
    (hN : Maximal (fun M : Set T ↦ M ⊆ K ∧ Metric.IsSeparated ε M) N) :
    Metric.IsCover ε K N :=
  Metric.IsCover.of_maximal_isSeparated hN

end NumStability.HDP.Contract
