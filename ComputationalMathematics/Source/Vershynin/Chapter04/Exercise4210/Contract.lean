import ComputationalMathematics.HDP.Metric.CoveringComparisons

/-!
# Vershynin Chapter 4, Exercise 4.2.10

Source contract for failure of exact monotonicity and the factor-two
approximate monotonicity of internal covering numbers.
-/

open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

private theorem isCover_iff_pointwise_dist
    {T : Type*} [MetricSpace T] (r : ℝ≥0) (K N : Set T) :
    Metric.IsCover r K N ↔
      ∀ ⦃x⦄, x ∈ K → ∃ y ∈ N, dist x y ≤ (r : ℝ) := by
  simp [Metric.IsCover, SetRel.IsCover, edist_dist]

/-- Vershynin, Exercise 4.2.10, in an exact-cardinal witness form.  The real
three-point example has an internal one-center cover, while its two-point
subset has exact internal covering cardinality two.  Under inclusion, every
internal half-radius cover of the larger set yields an internal full-radius
cover of the subset with no larger cardinality. -/
theorem hdp_04_exercise_4_2_10 :
    (∃ (L K : Set ℝ) (ε : ℝ≥0), 0 < ε ∧ L ⊆ K ∧
      (∃ C : Set ℝ, C ⊆ K ∧
        (∀ ⦃x⦄, x ∈ K → ∃ y ∈ C, dist x y ≤ (ε : ℝ)) ∧
        Cardinal.mk C = 1) ∧
      (∃ N : Set ℝ, N ⊆ L ∧
        (∀ ⦃x⦄, x ∈ L → ∃ y ∈ N, dist x y ≤ (ε : ℝ)) ∧
        Cardinal.mk N = 2) ∧
      ∀ N : Set ℝ, N ⊆ L →
        (∀ ⦃x⦄, x ∈ L → ∃ y ∈ N, dist x y ≤ (ε : ℝ)) →
        2 ≤ Cardinal.mk N) ∧
    (∀ {T : Type*} [MetricSpace T] {L K : Set T} {ε : ℝ≥0},
      0 < ε → L ⊆ K → ∀ C : Set T, C ⊆ K →
        (∀ ⦃x⦄, x ∈ K → ∃ y ∈ C, dist x y ≤ ((ε / 2 : ℝ≥0) : ℝ)) →
        ∃ N : Set T, N ⊆ L ∧
          (∀ ⦃x⦄, x ∈ L → ∃ y ∈ N, dist x y ≤ (ε : ℝ)) ∧
          Cardinal.mk N ≤ Cardinal.mk C) := by
  constructor
  · exact NumStability.HDP.Metric.exists_real_internalCover_cardinal_counterexample
  · intro T _ L K ε _hε hLK C _hCK hCcover
    have hCoverL : Metric.IsCover (ε / 2) L C :=
      (isCover_iff_pointwise_dist (ε / 2) L C).2 fun x hx => hCcover (hLK hx)
    obtain ⟨N, hNL, hNcover, hcard⟩ :=
      NumStability.HDP.Metric.exists_internalCover_cardinalMk_le_of_isCover_half hCoverL
    exact ⟨N, hNL, (isCover_iff_pointwise_dist ε L N).1 hNcover, hcard⟩

end NumStability.HDP.Contract
