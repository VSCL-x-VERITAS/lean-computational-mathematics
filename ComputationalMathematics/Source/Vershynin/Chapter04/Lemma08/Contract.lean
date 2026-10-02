import ComputationalMathematics.HDP.Metric.PackingCoveringWitness

/-!
# Vershynin, Chapter 4, Lemma 4.2.8

Source-correspondence contract for the equivalence inequalities between
covering and packing numbers.
-/

open Set
open scoped ENNReal NNReal

namespace NumStability.HDP.Contract

private theorem isSeparated_iff_pairwise_dist
    {T : Type*} [MetricSpace T] (r : ℝ≥0) (P : Set T) :
    Metric.IsSeparated r P ↔
      P.Pairwise fun x y => (r : ℝ) < dist x y := by
  simp [Metric.IsSeparated, Set.Pairwise, edist_dist]

private theorem isCover_iff_pointwise_dist
    {T : Type*} [MetricSpace T] (r : ℝ≥0) (K N : Set T) :
    Metric.IsCover r K N ↔
      ∀ ⦃x⦄, x ∈ K → ∃ y ∈ N, dist x y ≤ (r : ℝ) := by
  simp [Metric.IsCover, SetRel.IsCover, edist_dist]

/-- Vershynin, *High-Dimensional Probability*, Lemma 4.2.8, in a
cardinal-exact witness form: every `2ε`-packing injects into every internal
`ε`-cover, and an `ε`-separated internal `ε`-cover exists.  These two clauses
imply the displayed packing--covering inequalities under either a literal
cardinal or a single-infinity numerical convention. -/
theorem hdp_04_hlemma_h4_d2_d8
    {T : Type*} [MetricSpace T] (K : Set T) (ε : ℝ≥0) (_hε : 0 < ε) :
    (∀ P : Set T, P ⊆ K →
      P.Pairwise (fun x y => ((2 * ε : ℝ≥0) : ℝ) < dist x y) →
      ∀ N : Set T, N ⊆ K →
        (∀ ⦃x⦄, x ∈ K → ∃ y ∈ N, dist x y ≤ (ε : ℝ)) →
        Cardinal.mk P ≤ Cardinal.mk N) ∧
      ∃ P : Set T, P ⊆ K ∧
        P.Pairwise (fun x y => (ε : ℝ) < dist x y) ∧
        ∀ ⦃x⦄, x ∈ K → ∃ y ∈ P, dist x y ≤ (ε : ℝ) := by
  constructor
  · intro P hPK hPsep N hNK hNcover
    exact Metric.cardinalMk_le_of_isSeparated_two_mul_of_isCover hPK
      ((isSeparated_iff_pairwise_dist (2 * ε) P).2 hPsep) hNK
      ((isCover_iff_pointwise_dist ε K N).2 hNcover)
  · obtain ⟨P, hPK, hPsep, hPcover⟩ := Metric.exists_isSeparated_isCover ε K
    exact ⟨P, hPK, (isSeparated_iff_pairwise_dist ε P).1 hPsep,
      (isCover_iff_pointwise_dist ε K P).1 hPcover⟩

end NumStability.HDP.Contract
