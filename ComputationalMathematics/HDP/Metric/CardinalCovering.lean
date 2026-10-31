import Mathlib.Topology.MetricSpace.CoveringNumbers
import Mathlib.SetTheory.Cardinal.Basic

/-!
# Cardinal-valued internal covering numbers

This exact-cardinal version retains distinctions between infinite covering
cardinalities.  It complements Mathlib's `ENat`-valued covering number, which
is optimized for finite covering estimates.
-/

noncomputable section

open Set
open scoped NNReal

namespace NumStability.HDP.Metric

/-- The set of cardinalities of internal closed-ball covers of `K`. -/
def internalCoverCardinals {T : Type*} [MetricSpace T]
    (ε : ℝ≥0) (K : Set T) : Set Cardinal :=
  {c | ∃ N : Set T, N ⊆ K ∧
    (∀ x ∈ K, ∃ y ∈ N, dist x y ≤ (ε : ℝ)) ∧ c = Cardinal.mk N}

/-- The least exact cardinality of a set of centers internal to `K` whose
closed `ε`-balls cover `K`.  Taking `sInf` over the admissible cardinality set
avoids the empty-proof-index collapse of a nested conditional `iInf`. -/
def internalCoveringCardinal {T : Type*} [MetricSpace T]
    (ε : ℝ≥0) (K : Set T) : Cardinal :=
  sInf (internalCoverCardinals ε K)

/-- The pointwise internal-net condition is exactly coverage by the union of
closed balls with those internal centers. -/
theorem internalNet_iff_subset_iUnion_closedBall
    {T : Type*} [MetricSpace T] {ε : ℝ≥0} {K N : Set T} :
    (∀ x ∈ K, ∃ y ∈ N, dist x y ≤ (ε : ℝ)) ↔
      K ⊆ ⋃ y ∈ N, Metric.closedBall y (ε : ℝ) := by
  constructor
  · intro h x hx
    obtain ⟨y, hyN, hxy⟩ := h x hx
    simp only [Set.mem_iUnion]
    exact ⟨y, hyN, Metric.mem_closedBall.mpr hxy⟩
  · intro h x hx
    have hxcover := h hx
    simp only [Set.mem_iUnion] at hxcover
    obtain ⟨y, hy⟩ := hxcover
    obtain ⟨hyN, hxy⟩ := hy
    exact ⟨y, hyN, Metric.mem_closedBall.mp hxy⟩

/-- Equivalent closed-ball minimization form of the exact-cardinal covering
number. -/
theorem internalCoveringCardinal_eq_sInf_closedBall
    {T : Type*} [MetricSpace T] (ε : ℝ≥0) (K : Set T) :
    internalCoveringCardinal ε K =
      sInf {c : Cardinal | ∃ N : Set T, N ⊆ K ∧
        K ⊆ ⋃ y ∈ N, Metric.closedBall y (ε : ℝ) ∧ c = Cardinal.mk N} := by
  unfold internalCoveringCardinal internalCoverCardinals
  congr 1
  ext c
  simp only [Set.mem_setOf_eq]
  constructor
  · rintro ⟨N, hNK, hcover, hc⟩
    exact ⟨N, hNK, internalNet_iff_subset_iUnion_closedBall.mp hcover, hc⟩
  · rintro ⟨N, hNK, hcover, hc⟩
    exact ⟨N, hNK, internalNet_iff_subset_iUnion_closedBall.mpr hcover, hc⟩

end NumStability.HDP.Metric
