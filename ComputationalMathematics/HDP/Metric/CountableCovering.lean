import ComputationalMathematics.HDP.Metric.CardinalCovering
import Mathlib.Topology.Bases
import Mathlib.SetTheory.Cardinal.ENat

/-!
# Countable internal coverings

Positive-radius internal coverings in second countable metric spaces have
countable cardinality. Exact internal covering cardinalities are attained,
and their extended-natural projection recovers them on this domain.
-/

open Set
open scoped NNReal

namespace NumStability.HDP.Metric

/-- Positive-radius internal covers can be chosen countable in a second
countable metric space, by the existing dense-set certificate for the subtype. -/
theorem exists_countable_internal_net_of_secondCountable
    {E : Type*} [MetricSpace E] [SecondCountableTopology E]
    (K : Set E) {ε : ℝ} (hε : 0 < ε) :
    ∃ N : Set E, N ⊆ K ∧ N.Countable ∧
      ∀ x ∈ K, ∃ y ∈ N, dist x y ≤ ε := by
  obtain ⟨C, hC, hCdense⟩ := TopologicalSpace.exists_countable_dense K
  refine ⟨Subtype.val '' C, ?_, hC.image Subtype.val, ?_⟩
  · rintro x ⟨y, _hy, rfl⟩
    exact y.property
  · intro x hx
    obtain ⟨y, hy, hxy⟩ := hCdense.exists_dist_lt ⟨x, hx⟩ hε
    exact ⟨y.val, ⟨y, hy, rfl⟩, hxy.le⟩

/-- The exact internal covering cardinal is at most countably infinite at a
positive radius. This does not specify any book's convention for infinity. -/
theorem internalCoveringCardinal_le_aleph0_of_secondCountable
    {E : Type*} [MetricSpace E] [SecondCountableTopology E]
    (K : Set E) {ε : ℝ≥0} (hε : 0 < ε) :
    internalCoveringCardinal ε K ≤ Cardinal.aleph0 := by
  obtain ⟨N, hNK, hNcount, hNcover⟩ :=
    exists_countable_internal_net_of_secondCountable K (by exact_mod_cast hε)
  have hmember : Cardinal.mk N ∈ internalCoverCardinals ε K :=
    ⟨N, hNK, hNcover, rfl⟩
  exact (csInf_le (OrderBot.bddBelow _) hmember).trans hNcount.le_aleph0

/-- The minimum exact cardinality is attained, because the whole set is an
eligible internal cover and cardinals are well ordered. No finite-cover or
packing-maximum premise is introduced. -/
theorem exists_internal_net_card_eq_internalCoveringCardinal
    {E : Type*} [MetricSpace E] (K : Set E) (ε : ℝ≥0) :
    ∃ N : Set E, N ⊆ K ∧
      (∀ x ∈ K, ∃ y ∈ N, dist x y ≤ (ε : ℝ)) ∧
      Cardinal.mk N = internalCoveringCardinal ε K := by
  have hnonempty : (internalCoverCardinals ε K).Nonempty := by
    refine ⟨Cardinal.mk K, K, Set.Subset.rfl, ?_, rfl⟩
    intro x hx
    exact ⟨x, hx, by simp⟩
  have hmin : internalCoveringCardinal ε K ∈ internalCoverCardinals ε K :=
    csInf_mem hnonempty
  obtain ⟨N, hNK, hcover, heq⟩ := hmin
  exact ⟨N, hNK, hcover, heq.symm⟩

/-- At positive radius in a second countable metric space, the ENat
projection recovers the exact covering cardinal without information loss. -/
theorem ofENat_toENat_internalCoveringCardinal
    {E : Type*} [MetricSpace E] [SecondCountableTopology E]
    (K : Set E) {ε : ℝ≥0} (hε : 0 < ε) :
    (Cardinal.toENat (internalCoveringCardinal ε K) : Cardinal) =
      internalCoveringCardinal ε K :=
  Cardinal.ofENat_toENat (internalCoveringCardinal_le_aleph0_of_secondCountable K hε)

/-- Equality of projected positive-radius covering values is equivalent to
exact cardinal equality on this mathematical domain. -/
theorem toENat_internalCoveringCardinal_eq_iff
    {E : Type*} [MetricSpace E] [SecondCountableTopology E]
    (K L : Set E) {ε δ : ℝ≥0} (hε : 0 < ε) (hδ : 0 < δ) :
    Cardinal.toENat (internalCoveringCardinal ε K) =
      Cardinal.toENat (internalCoveringCardinal δ L) ↔
      internalCoveringCardinal ε K = internalCoveringCardinal δ L :=
  Cardinal.toENat_eq_iff_of_le_aleph0
    (internalCoveringCardinal_le_aleph0_of_secondCountable K hε)
    (internalCoveringCardinal_le_aleph0_of_secondCountable L hδ)

end NumStability.HDP.Metric
