import ComputationalMathematics.HDP.Metric.CoveringComparisons

/-!
# Vershynin Chapter 4, Exercise 4.2.9

Source contract for the factor-two comparison between covering numbers with
internal and unrestricted centers.
-/

open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

private theorem isCover_iff_pointwise_dist
    {T : Type*} [MetricSpace T] (r : ℝ≥0) (K N : Set T) :
    Metric.IsCover r K N ↔
      ∀ ⦃x⦄, x ∈ K → ∃ y ∈ N, dist x y ≤ (r : ℝ) := by
  simp [Metric.IsCover, SetRel.IsCover, edist_dist]

/-- Vershynin, Exercise 4.2.9, in a cardinal-exact witness form.  Every
internal cover is an exterior cover, while an exterior half-radius cover can
be moved into `K` without increasing its cardinality. -/
theorem hdp_04_exercise_4_2_9
    {T : Type*} [MetricSpace T] (K : Set T) (ε : ℝ≥0)
    (_hε : 0 < ε) :
    (∀ N : Set T, N ⊆ K →
      (∀ ⦃x⦄, x ∈ K → ∃ y ∈ N, dist x y ≤ (ε : ℝ)) →
      ∃ C : Set T,
        (∀ ⦃x⦄, x ∈ K → ∃ y ∈ C, dist x y ≤ (ε : ℝ)) ∧
        Cardinal.mk C ≤ Cardinal.mk N) ∧
      ∀ C : Set T,
        (∀ ⦃x⦄, x ∈ K → ∃ y ∈ C, dist x y ≤ ((ε / 2 : ℝ≥0) : ℝ)) →
        ∃ N : Set T, N ⊆ K ∧
          (∀ ⦃x⦄, x ∈ K → ∃ y ∈ N, dist x y ≤ (ε : ℝ)) ∧
          Cardinal.mk N ≤ Cardinal.mk C := by
  constructor
  · intro N _hNK hNcover
    exact ⟨N, hNcover, le_rfl⟩
  · intro C hCcover
    obtain ⟨N, hNK, hNcover, hcard⟩ :=
      NumStability.HDP.Metric.exists_internalCover_cardinalMk_le_of_isCover_half
        ((isCover_iff_pointwise_dist (ε / 2) K C).2 hCcover)
    exact ⟨N, hNK, (isCover_iff_pointwise_dist ε K N).1 hNcover, hcard⟩

end NumStability.HDP.Contract
