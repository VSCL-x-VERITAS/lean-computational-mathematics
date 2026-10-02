import Mathlib.Topology.MetricSpace.Cover

/-!
# Vershynin, Chapter 4, Definition 4.2.1

Source-correspondence wrapper for internal epsilon-nets and their equivalent
closed-ball covering characterization. The public contract spells out the
source quantifiers, while the proof reuses Mathlib's `Metric.IsCover` and
`Metric.isCover_iff_subset_iUnion_closedBall`.
-/

open Set
open scoped NNReal

namespace NumStability.HDP.Contract

/-- Vershynin, *High-Dimensional Probability*, Definition 4.2.1: a positive-
radius epsilon-net lies in the covered set, covers every point within epsilon,
and equivalently covers the set by closed epsilon-balls centered in the net. -/
theorem hdp_04_hdef_h4_d2_d1 {T : Type*} [MetricSpace T]
    {K N : Set T} {ε : ℝ≥0} (_hε : 0 < ε) :
    (N ⊆ K ∧ ∀ x ∈ K, ∃ x₀ ∈ N, dist x x₀ ≤ ε) ↔
      (N ⊆ K ∧ K ⊆ ⋃ y ∈ N, Metric.closedBall y ε) := by
  rw [← Metric.isCover_iff_subset_iUnion_closedBall]
  simp [Metric.IsCover, SetRel.IsCover, edist_dist]

end NumStability.HDP.Contract
