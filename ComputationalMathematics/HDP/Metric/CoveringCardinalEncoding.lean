import ComputationalMathematics.HDP.Metric.CountableCovering

/-!
# Cardinal and extended-natural covering-number encodings

The existing exact internal minimum projects to Mathlib's covering number.
At positive radius in a second countable metric space, decoding that value
recovers the exact minimum. This is a mathematical encoding comparison, with
no commitment to any source's convention for infinity.
-/

noncomputable section

open Set
open scoped NNReal

namespace NumStability.HDP.Metric

/-- Projection of the attained exact internal minimum agrees with
Mathlib's internal closed-ball covering number, at every nonnegative radius. -/
theorem toENat_internalCoveringCardinal_eq_coveringNumber
    {E : Type*} [MetricSpace E] (K : Set E) (ε : ℝ≥0) :
    Cardinal.toENat (internalCoveringCardinal ε K) =
      _root_.Metric.coveringNumber ε K := by
  apply le_antisymm
  · unfold _root_.Metric.coveringNumber
    refine le_iInf fun N ↦ le_iInf fun hNK ↦ le_iInf fun hcover ↦ ?_
    have hnet : ∀ x ∈ K, ∃ y ∈ N, dist x y ≤ (ε : ℝ) :=
      internalNet_iff_subset_iUnion_closedBall.mpr
        (_root_.Metric.isCover_iff_subset_iUnion_closedBall.mp hcover)
    have hminimum : internalCoveringCardinal ε K ≤ Cardinal.mk N :=
      csInf_le (OrderBot.bddBelow _) ⟨N, hNK, hnet, rfl⟩
    simpa only [Set.toENat_cardinalMk] using
      OrderHomClass.monotone Cardinal.toENat hminimum
  · obtain ⟨N, hNK, hnet, hcard⟩ :=
      exists_internal_net_card_eq_internalCoveringCardinal K ε
    have hcover : _root_.Metric.IsCover ε K N :=
      _root_.Metric.isCover_iff_subset_iUnion_closedBall.mpr
        (internalNet_iff_subset_iUnion_closedBall.mp hnet)
    have hbound := hcover.coveringNumber_le_encard hNK
    simpa only [← Set.toENat_cardinalMk, hcard] using hbound

/-- On the positive-radius second countable domain, decoding Mathlib's
extended-natural covering number loses no exact minimum-cardinality data. -/
theorem internalCoveringCardinal_eq_ofENat_coveringNumber
    {E : Type*} [MetricSpace E] [SecondCountableTopology E]
    (K : Set E) {ε : ℝ≥0} (hε : 0 < ε) :
    internalCoveringCardinal ε K = (_root_.Metric.coveringNumber ε K : Cardinal) := by
  rw [← toENat_internalCoveringCardinal_eq_coveringNumber K ε,
    ofENat_toENat_internalCoveringCardinal K hε]

end NumStability.HDP.Metric
