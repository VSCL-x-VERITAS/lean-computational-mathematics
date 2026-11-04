import Mathlib.Topology.MetricSpace.Cover
import ComputationalMathematics.Source.Vershynin.Chapter04.MaximalSeparated.Contract

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

/-- Positive-radius source correspondence for Lemma 4.2.6, with maximality
expressed by the source's adjoining-point criterion and the net conclusion
expressed using the original real metric. The broader characterization remains
available as `hdp_04_hlemma_h4_d2_d6`. -/
theorem hdp_04_maximal_separated_positive_is_net
    {T : Type*} [MetricSpace T] {K N : Set T} {ε : ℝ≥0}
    (hε : 0 < ε) (hNK : N ⊆ K)
    (hsep : N.Pairwise fun x y => (ε : ℝ) < dist x y)
    (hmax : ∀ x ∈ K, x ∉ N →
      ¬ (insert x N).Pairwise (fun a b => (ε : ℝ) < dist a b)) :
    ∀ ⦃x⦄, x ∈ K → ∃ y ∈ N, dist x y ≤ (ε : ℝ) := by
  have hsep' : Metric.IsSeparated ε N := by
    simpa [Metric.IsSeparated, Set.Pairwise, edist_dist] using hsep
  have hmax' : ∀ x ∈ K, x ∉ N → ¬ Metric.IsSeparated ε (insert x N) := by
    intro x hxK hxN hxsep
    apply hmax x hxK hxN
    simpa [Metric.IsSeparated, Set.Pairwise, edist_dist] using hxsep
  have hN : Maximal (fun M : Set T => M ⊆ K ∧ Metric.IsSeparated ε M) N :=
    (hdp_04_maximal_separated_positive_definition hε).2 ⟨⟨hNK, hsep'⟩, hmax'⟩
  have hcover := hdp_04_hlemma_h4_d2_d6 hN
  simpa [Metric.IsCover, SetRel.IsCover, edist_dist] using hcover

end NumStability.HDP.Contract
